//
//  RecipeViewController.m
//
//
//  Created by LICAN LONG on 15/7/16.
//
//

#import "RecipeViewController.h"
#import "AppConstants.h"
#import "Masonry.h"
#import "AdScrollView.h"
#import "AdDataModel.h"
#import "IntroduceContainer.h"
#import "IntroduceDataModel.h"
#import "BlurView.h"
#import "ArticleScrollView.h"
#import "ArticleDataModel.h"
#import "IntroduceDetailViewController.h"
#import "ADDetailViewController.h"
#import "PlistEditor.h"
#import "SDRefresh.h"
#import "SearchViewController.h"
#import "ArticleCell.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "YCDefines.h"
#import "YCImagePlayerView.h"
#import "IntroduceDetailCell.h"
#import "UIViewController+Action.h"
#import "YCContainerControl.h"

@interface RecipeViewController () <UIScrollViewDelegate, AdScrollViewDelegate, RefreshDelegate, IntroduceContainerDelegate, ArticleScrollViewDelegate, UIAlertViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) UIScrollView                      *verticalScrollView;
@property (strong, nonatomic) UIView                            *verticalScrollViewContainer;
@property (strong, nonatomic) AdScrollView                      *adScrollView;
@property (strong, nonatomic) UIView                            *introduceBar;
@property (strong, nonatomic) IntroduceContainer                *introduceContainer;
@property (strong, nonatomic) NSMutableArray                    *introduceViewsArray;
@property (strong, nonatomic) ArticleScrollView                 *articleScrollView;
@property (strong, nonatomic) UIPageControl                     *pageControl;
@property (strong, nonatomic) IntroduceDetailViewController     *introduceDetailVC;
@property (strong, nonatomic) ADDetailViewController            *adDetailViewController;
@property (strong, nonatomic) UIImageView                       *thumbImageView;
@property(nonatomic,strong) NSTimer  * timer;
@property (strong, nonatomic) NSArray                           *formulaArray;

@property (nonatomic)         CGFloat                           viewSize;
@property (nonatomic) BOOL                                      isRefreshing;

@property (nonatomic) BOOL                                      isADScrollViewDataLoaded;
@property (nonatomic) BOOL                                      isIntroduceDataLoaded;
@property (nonatomic) BOOL                                      isArticleScrollLoaded;

@property (nonatomic) BOOL                                      isDataShow;

@property (strong, nonatomic) UIButton                          *getDataFailButton;
@property (strong, nonatomic) UIButton                          *popButton;
@property (strong, nonatomic) UIWindow                          *window;
@property (strong, nonatomic) UIView                            *whiteViewForRefresh;

@property (strong, nonatomic) NSMutableArray                    *ADDataDics;
@property (strong, nonatomic) NSMutableArray                    *IntroduceDataDics;
@property (strong, nonatomic) NSMutableArray                    *ArticleDataDics;
@property (strong, nonatomic) NSMutableArray<AdDataModel *>     *ADDatas;
@property (strong, nonatomic) NSMutableArray                    *IntroduceDatas;
@property (strong, nonatomic) NSMutableArray                    *ArticleDatas;

@property (strong, nonatomic) SDRefreshHeaderView               *refreshHeader;
@property (strong, nonatomic) UIImageView                       *view1;
@property (strong, nonatomic) UIImageView                       *view2;

@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation RecipeViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"dismiss");
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     _isDataShow = NO;
     
     _ADDataDics = [[NSMutableArray alloc] init];
     _IntroduceDataDics = [[NSMutableArray alloc] init];
     _ArticleDataDics = [[NSMutableArray alloc] init];
     _ADDatas = [[NSMutableArray alloc] init];
     _IntroduceDatas = [[NSMutableArray alloc] init];
     _ArticleDatas = [[NSMutableArray alloc] init];
     
     //    [self initNavigationBar];
     [self initVerticalScrollView];
     [self setupHeader];
     [self initStatus];
     //创建悬浮框[self performSelector:@selector(createButton) withObject:nil afterDelay:1];
     [ProgressHUD show:NSLocalizedString(@"loading", @"")];
     
     //if (![FileOperator fileExist:[AppConstants localFileADData]]) {
     NSLog(@"server");
     [self getADDataFromServer];
     
     NSLog(@"server");
     [self getIntroduceDataFromServer];
     
     
     NSLog(@"server");
     [self getArticleDataFromServer];
     */
    WSELF;
    //[self initSearchButton];
    [self initSearchBar];
    
    self.configureDelegate = self;
    [self adjustContentIn:self.tableView];
    
    //int articleCountInRow = 3;
    [self setCellInfosBlock:^NSArray<CellInfo *> *(__kindof NSArray * _Nullable datas) {
        return @[
                 [CellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
                     return [AppConstants uiScreenHeight] / 3;
                 } number:^NSInteger(NSInteger section) {
                     SSELF;
                     return self.ADDatas?1:0;
                 } model:nil],
                 
                 [CellInfo cellInfoWithId:cellInset height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
                     return 25;
                 } number:^NSInteger(NSInteger section) {
                     SSELF;
                     return self.ADDatas?1:0;
                 }],
                 
                 [CellInfo cellInfoWithId:cell1 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
                     return 75;
                 } number:^NSInteger(NSInteger section) {
                     SSELF;
                     return self.IntroduceDatas.count;
                 } model:nil],
                 
                 [CellInfo cellInfoWithId:cell2 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
                     return [AppConstants uiScreenWidth] / 3 + 30;
                 } number:^NSInteger(NSInteger section) {
                     SSELF;
                     return self.ArticleDatas.count;
                 } model:^id _Nullable(NSIndexPath * _Nonnull indexPath) {
                     SSELF;
                     return self.ArticleDatas[indexPath.row];
                 }],
                 
                 [CellInfo cellInfoWithId:cellInset1 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
                     return 25;
                 } number:^NSInteger(NSInteger section) {
                     return 1;
                 }],
                 
                 ];
    }];
    
#pragma mark - 1
    NSString *urlString = [NSString stringWithFormat:@"%@resource/article/frontpage/slide/list/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"page":@"1", @"pageSize":@"10"};
    
    [HTTP_CLIENT POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ;
        NSLog(@"公告栏 = %@", urlString);
        NSLog(@"公告栏详情: %@", responseObject);
        
        if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
            NSArray *articles = [responseObject objectForKey:@"articles"];
            
            self.ADDatas = [NSArray modelArrayWithClass:[AdDataModel class] json:articles].mutableCopy;
            //[self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
            NSLog(@"获取列表失败 %@", urlString);
            
            //[self getDataFail];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"false urlString = %@", urlString);
        NSLog(@"Error: %@", error);
        
        //[self getDataFail];
    }];
    
#pragma mark - 2
    NSString *urlString2 = [NSString stringWithFormat:@"%@resource/formula/frontpage/list/index.ashx", [AppConstants httpHeader]];
    
    [HTTP_CLIENT POST:urlString2 parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ;
        NSLog(@"公告栏 = %@", urlString);
        NSLog(@"公告栏详情: %@", responseObject);
        
        if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
            NSArray *articles = [responseObject objectForKey:@"formulas"];
            
            self.IntroduceDatas = [NSArray modelArrayWithClass:[IntroduceDataModel class] json:articles].mutableCopy;
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
            NSLog(@"获取列表失败 %@", urlString);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"false urlString = %@", urlString);
        NSLog(@"Error: %@", error);
        
    }];
    
#pragma mark - 3
    
    
    
    NSString *urlString3 = [NSString stringWithFormat:@"%@resource/article/frontpage/list/index.ashx", [AppConstants httpHeader]];
    
    
    
    [HTTP_CLIENT POST:urlString3 parameters:parameters
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"success urlString = %@", urlString);
                 NSLog(@"Success: %@", responseObject);
                 
                 if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                     NSArray *articles = [responseObject objectForKey:@"articles"];
                     
                     NSArray<ArticleDataModel *> *articleDatas = [NSArray modelArrayWithClass:[ArticleDataModel class] json:articles];
                     NSMutableArray *ads = [NSMutableArray new];
                     int articleCountInRow = 3;
                     for (int n = 0; n < articleDatas.count/articleCountInRow; n++) {
                         NSUInteger loc = articleCountInRow*n ;
                         NSUInteger end = MIN(articleDatas.count , loc+articleCountInRow);
                         [ads addObject:[articleDatas subarrayWithRange:NSMakeRange(loc, end-loc)]];
                     }
                    
                     self.ArticleDatas = ads;
                     [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationAutomatic];
                     
                     
                 }
                 else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                     NSLog(@"获取列表失败 %@", urlString);
                     
                 }
                 
             }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 NSLog(@"false urlString = %@", urlString);
                 NSLog(@"Error: %@", error);
                 
             }];
    
}

- (void)onConfigureCell:(__kindof TableCell *__weak)cell reuseIdentifier:(NSString *)reuseIdentifier tableView:(__kindof UITableView *__weak)tableView
{
    WSELF;
#pragma mark - 公告栏
    if (reuseIdentifier == cell0) {
        [cell registerContentViewClass:[YCADView class]];
        [cell setInitAsyncBlock:^(__kindof UIView * _Nonnull contentView) {
            
            YCADView *as = contentView;
            [as yc_initView];
            as.pageControlPosition = ICPageControlPosition_TopCenter;
            
            [as setUpdateBlock:^(NSInteger index, UIImageView *imageView) {
                SSELF;
                AdDataModel *model = self.ADDatas[index];
                NSString *url = [NSString stringWithFormat:@"%@%@",[AppConstants httpImageHeader],model.imageUrl];
                [imageView yc_setImageWithURL:url placeholder:nil];
                
                int tag = 10000;
                YYLabel *title = [imageView viewWithTag:tag];
                if (!title) {
                    title = [YYLabel newInSuperView:imageView];
                    title.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
                    title.textAlignment = NSTextAlignmentCenter;
                    title.textColor = [UIColor whiteColor];
                    [title mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(25);
                        make.left.bottom.right.equalTo(imageView);
                    }];
                    title.tag = tag;
                }
                title.text = model.title;
            }];
            [as setSelectBlock:^(NSInteger index, UIImageView *imageView) {
                SSELF;
                AdDataModel *model = self.ADDatas[index];
                ADDetailViewController *adDetailViewController = [[ADDetailViewController alloc] initWithAdDataModel:model];
                [adDetailViewController onSetupBackButton];
                adDetailViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:adDetailViewController animated:YES];
            }];
            
            [cell setUpdateBlock:^(NSIndexPath * _Nonnull indexPath) {
                SSELF;
                if ([cell containModelData:self.ADDatas]) {
                    return ;
                }
                [as reloadImageData:self.ADDatas];
                
            }];
            
            
        }];
    }
    
#pragma mark - 今日推荐
    if (reuseIdentifier == cellInset) {
        [cell setInitBlock:^(__kindof UIView * _Nonnull contentView) {
            
            UIView *introduceBar = [UIView newInSuperView:contentView];
            introduceBar.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:234.0/255.0 blue:232.0/255.0 alpha:1.0];
            
            UIImageView *thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageThumb"]];
            UILabel *introduceLabel = [[UILabel alloc] init];
            introduceLabel.text = NSLocalizedString(@"jinrituijian", @"");
            
            [introduceBar addSubview:thumbImageView];
            [introduceBar addSubview:introduceLabel];
            
            [thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(introduceBar).with.offset(2);
                make.bottom.equalTo(introduceBar).with.offset(-2);
                make.left.mas_equalTo(introduceBar.mas_left).with.offset(10);
                make.width.mas_equalTo(thumbImageView.mas_height).with.offset(10);
            }];
            
            [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(thumbImageView.mas_right).with.offset(8);
                make.centerY.equalTo(thumbImageView.mas_centerY);
            }];
            
            [cell setLayoutBlock:^(CGRect frame) {
                introduceBar.frame = frame;
            }];
        }];
    }
#pragma mark - 推荐cell
    if (reuseIdentifier == cell1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitAsyncBlock:^(__kindof UIView * _Nonnull contentView) {
            IntroduceDetailCell *idc = [[[IntroduceDetailCell alloc]initWithStyleRecipe]addInSuperView:contentView];
            [cell setLayoutBlock:^(CGRect frame) {
                idc.frame = frame;
            }];
            
            [cell setAutoLayoutBlock:^(CGRect frame) {
                [idc yc_initView];
            }];
            
            [cell setUpdateBlock:^(NSIndexPath * _Nonnull indexPath) {
                SSELF;
                IntroduceDataModel *m = self.IntroduceDatas[indexPath.row];
                if ([cell containModelData:m]) {
                    return ;
                }
                [idc updateIntroduceDataModel:m];
            }];
            
            [cell setSelectBlock:^(NSIndexPath * _Nonnull indexPath) {
                SSELF;
                IntroduceDataModel *m = self.IntroduceDatas[indexPath.row];
                IntroduceDetailViewController *introduceDetailVC = [[IntroduceDetailViewController alloc] initWithData:m];
                [introduceDetailVC onSetupBackButton];
                introduceDetailVC.view.backgroundColor = [UIColor whiteColor];
                introduceDetailVC.hidesBottomBarWhenPushed = YES;
                introduceDetailVC.navigationItem.title = m.formulaName;
                
                [self.navigationController pushViewController:introduceDetailVC animated:YES];
            }];
        }];
    }
    
#pragma mark - 文章cell
    if (reuseIdentifier == cell2) {
        cell.separatorInset = UIEdgeInsetsZero;
        [cell registerContentViewClass:[YCContainerControl class]];
        [cell setInitAsyncBlock:^(__kindof UIView * _Nonnull contentView) {
            YCContainerControl<ArticleCell *> *cc = contentView;
            [cc setElementCount:3 block:^ArticleCell *(NSInteger idx) {
                ArticleCell *c = [[ArticleCell alloc]init];
                [c setSelectBlock:^{
                    SSELF;
                    NSArray *ms = cell.modelData;
                    AdDataModel *model = ms[idx];
                    ADDetailViewController *adDetailViewController = [[ADDetailViewController alloc] initWithAdDataModel:model];
                    [adDetailViewController onSetupBackButton];
                    [self.navigationController pushViewController:adDetailViewController animated:YES];
                }];
                return c;
            }];
            
            [cell setAutoLayoutBlock:^(CGRect frame) {
                [cc.elements enumerateObjectsUsingBlock:^(ArticleCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj yc_initView];
                }];
            }];
            
            [cell setUpdateBlock:^(NSIndexPath * _Nonnull indexPath) {
                SSELF;
                NSArray *ms = [self modelForIndexPath:indexPath];
                if ([cell containModelData:ms]) {
                    return ;
                }
                [cc.elements enumerateObjectsUsingBlock:^(__kindof ArticleCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx<ms.count) {
                        obj.hidden = NO;
                        [obj updateArticleDataModel:ms[idx]];
                    }
                    
                    else {
                        obj.hidden = YES;
                    }
                }];
            }];
        }];
    }
}

- (void)getLaunchImage {/*
                         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                         manager.responseSerializer = [AFJSONResponseSerializer serializer];
                         
                         AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
                         securityPolicy.allowInvalidCertificates = YES;
                         manager.securityPolicy = securityPolicy;
                         
                         NSString *urlString = [NSString stringWithFormat:@"%@resource/SplashScreen/first/index.ashx", [AppConstants httpHeader]];
                         
                         //    NSDictionary *parameters = @{@"page":@"1", @"pageSize":@"10"};
                         
                         [manager POST:urlString parameters:nil
                         success:^(AFHTTPRequestOperation *operation,id responseObject) {
                         //NSLog(@"欢迎页 urlString = %@", urlString);
                         //NSLog(@"欢迎页: %@", responseObject);
                         
                         if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                         NSArray *pics = [responseObject objectForKey:@"pics"];
                         
                         NSString *imageUrl = [[pics objectAtIndex:0] objectForKey:@"url"];
                         
                         if (![imageUrl isEqualToString:@""]) {
                         NSLog(@"getLaunchImage AppInfoDic = %@", [AppConstants AppInfoDic]);
                         
                         [PlistEditor alterPlist:@"AppInfo" alertValue:imageUrl forKey:@"launchImage"];
                         
                         [AppConstants writeDic2File];
                         }
                         }
                         else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                         NSLog(@"获取列表失败 %@", urlString);
                         
                         }
                         
                         }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                         NSLog(@"false urlString = %@", urlString);
                         NSLog(@"Error: %@", error);
                         
                         }];
                         */}


- (void)viewDidLayoutSubviews {
    /*
     float contentHeight = _adScrollView.frame.size.height + _introduceContainer.frame.size.height + _articleScrollView.frame.size.height;
     
     if (contentHeight <= [AppConstants uiScreenHeight] && _isDataShow == YES) {
     _whiteViewForRefresh = [[UIView alloc] init];
     _whiteViewForRefresh.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:234.0/255.0 blue:232.0/255.0 alpha:1.0];
     
     dispatch_async(dispatch_get_main_queue(), ^{
     [_verticalScrollViewContainer addSubview:_whiteViewForRefresh];
     
     [_whiteViewForRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.and.right.equalTo(_verticalScrollViewContainer);
     make.top.mas_equalTo(_articleScrollView.mas_bottom);
     make.height.mas_equalTo([AppConstants uiScreenHeight]);
     }];
     });
     }
     else {
     dispatch_async(dispatch_get_main_queue(), ^{
     [_whiteViewForRefresh removeFromSuperview];
     });
     }*/
}

- (void)setupHeader
{
    _refreshHeader = [SDRefreshHeaderView refreshView];
    _refreshHeader.delegate = self;
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [_refreshHeader addToScrollView:_verticalScrollView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = _refreshHeader;
    __weak NSObject *weakSelf = self;
    _refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"Refreshing");
            
            [NSThread detachNewThreadSelector:@selector(reloadAllData) toTarget:weakSelf withObject:nil];
            
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [_refreshHeader beginRefreshing];
}


- (void)initViews {
    if (_isDataShow) {
        NSArray *views = [_verticalScrollViewContainer subviews];
        for(UIView *view in views)
        {
            [view removeFromSuperview];
        }
    }
    
    [self initAdScrollView];
    [self initIntroduceBar];
    [self initIntroduceContainer];
    [self initSv1];
    
    [self.view setNeedsUpdateConstraints];
    
    _isDataShow = YES;
    
    [_getDataFailButton removeFromSuperview];
    
    [ProgressHUD dismiss];
    
    NSLog(@"views count = %lu", (unsigned long)[[_verticalScrollViewContainer subviews] count]);
    
    if ([[_verticalScrollViewContainer subviews] count] > 4) {
        [self initViews];
    }
}

- (void)prepareForAnimation {
    //    _searchBar.transform = CGAffineTransformMakeScale(0, 0);
    _thumbImageView.transform = CGAffineTransformMakeScale(0, 0);
}

- (void)doAnimation {
    /*    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone
     animations: ^{
     _searchBar.transform = CGAffineTransformMakeScale(1, 1);
     }completion:nil];*/
    
    [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone
                     animations: ^{
                         _thumbImageView.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //    _searchBar.transform = CGAffineTransformMakeScale(0, 0);
    //    _thumbImageView.transform = CGAffineTransformMakeScale(0, 0);
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    NSLog(@"viewDidAppear");
//
//    if ([AppConstants downloadButtonPress2Pop]) {
//        [AppConstants setDownloadButtonPress2Pop:NO];
//
//        NSLog(@"here");
//
//        //((AppDelegate*)[[UIApplication sharedApplication] delegate]).mainTabBarController.selectedIndex = 1;
//    }
//
//    if (((AppDelegate*)[[UIApplication sharedApplication] delegate]).isRecipeCacheCleared) {
//        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).isRecipeCacheCleared = NO;
//
//        NSLog(@"refresh");
//
//        [self reloadAllData];
//    }
//}

- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    _searchBar.placeholder = NSLocalizedString(@"searchPlaceholder", @"");
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    
    // Change search bar text color
    searchField.textColor = [UIColor whiteColor];
    
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    _searchBar.size = self.navigationController.navigationBar.size;
    self.navigationItem.titleView = _searchBar;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self searchButtonPress];
    return NO;
}

- (void)initStatus {
    _isADScrollViewDataLoaded = NO;
    _isIntroduceDataLoaded = NO;
    _isArticleScrollLoaded = NO;
    //    _isMasterScrollViewLoaded = NO;
    
    _introduceViewsArray = [NSMutableArray arrayWithCapacity:(100)];
}

- (void)initNavigationBar {
    //    [self initSearchBar];
    self.navigationItem.title = NSLocalizedString(@"mifang", @"");
    //    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:20.0],NSFontAttributeName, nil]];
    
    [self initSearchButton];
}

/*
 - (void)initSearchBar {
 _searchBar = [[UISearchBar alloc] init];
 _searchBar.placeholder = @"请输入水果、功效、口感等";
 _searchBar.searchBarStyle = UISearchBarStyleMinimal;
 _searchBar.frame = CGRectMake([AppConstants searchBarX], [AppConstants searchBarY], [AppConstants searchBarWidth], 0);
 _searchBar.delegate = self;
 [self.navigationController.navigationBar addSubview:_searchBar];
 }*/

- (void)initSearchButton {
    UIImage *searchButtonImage = [UIImage imageNamed:@"searchBLE"];
    searchButtonImage = [searchButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:searchButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonPress)];
}

- (void)initVerticalScrollView {
    _verticalScrollView = [UIScrollView new];
    _verticalScrollView.backgroundColor = [UIColor whiteColor];
    _verticalScrollView.scrollsToTop = YES;
    [self.view addSubview:_verticalScrollView];
    [_verticalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _verticalScrollViewContainer = [UIView new];
    _verticalScrollViewContainer.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:234.0/255.0 blue:232.0/255.0 alpha:1.0];
    [_verticalScrollView addSubview:_verticalScrollViewContainer];
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_verticalScrollView);
        make.width.equalTo(_verticalScrollView);
    }];
}

- (void)getDataFail {
    [_getDataFailButton removeFromSuperview];
    
    [ProgressHUD showError:NSLocalizedString(@"jiazaishibai", @"")];
    
    if (_isDataShow == NO) {
        _getDataFailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getDataFailButton setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
        [_getDataFailButton addTarget:self action:@selector(reloadAllData) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_getDataFailButton];
        
        [_getDataFailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.width.and.height.equalTo(@160);
        }];
    }
}

- (void)setAdScrollViewData {
    if (_adScrollView == nil) {
        _adScrollView = [[AdScrollView alloc] init];
        _adScrollView.dataArray = _ADDatas;
        
        NSLog(@"_ADDatas count = %lu", (unsigned long)[_ADDatas count]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_verticalScrollView addSubview:_adScrollView.pageControl];
            [_verticalScrollView addSubview:_adScrollView.titleView];
        });
    }
    else {
        _adScrollView.dataArray = _ADDatas;
    }
    _adScrollView.adDelegate = self;
    _isADScrollViewDataLoaded = YES;
    
    [self prepareToShowData];
}

- (void)setIntroduceData {
    _introduceContainer = [[IntroduceContainer alloc] initWithDatas:_IntroduceDatas andStyle:StyleRecipe];
    
    _introduceContainer.delegate = self;
    
    _isIntroduceDataLoaded = YES;
    
    [self prepareToShowData];
}

- (void)setArticleData {
    _articleScrollView = [[ArticleScrollView alloc] init];
    _articleScrollView.dataArray = _ArticleDatas;
    _articleScrollView.articleDelegate = self;
    
    _isArticleScrollLoaded = YES;
    
    [self prepareToShowData];
}

- (void)prepareToShowData {
    if (_isADScrollViewDataLoaded &&
        _isIntroduceDataLoaded &&
        _isArticleScrollLoaded)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initViews];
            
            [self doAnimation];
        });
    }
}

- (void)initAdScrollView {
    [_adScrollView removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_adScrollView];
    
    [_adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.mas_equalTo(_verticalScrollViewContainer.mas_top);
        make.height.mas_equalTo([AppConstants uiScreenHeight] / 3);
    }];
    
    [_adScrollView setNeedsUpdateConstraints];
}

- (void)initIntroduceBar {
    _introduceBar = [[UIView alloc] init];
    _introduceBar.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:234.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageThumb"]];
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.text = NSLocalizedString(@"jinrituijian", @"");
    
    [_thumbImageView removeFromSuperview];
    [introduceLabel removeFromSuperview];
    [_introduceBar addSubview:_thumbImageView];
    [_introduceBar addSubview:introduceLabel];
    
    [_introduceBar removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_introduceBar];
    
    [_introduceBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.height.mas_equalTo(@25);
        make.top.mas_equalTo(_adScrollView.mas_bottom);
    }];
    
    [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_introduceBar).with.offset(2);
        make.bottom.equalTo(_introduceBar).with.offset(-2);
        make.left.mas_equalTo(_introduceBar.mas_left).with.offset(10);
        make.width.mas_equalTo(_thumbImageView.mas_height).with.offset(10);
    }];
    
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_thumbImageView.mas_right).with.offset(8);
        make.centerY.equalTo(_thumbImageView.mas_centerY);
    }];
}

- (void)initIntroduceContainer {
    _introduceContainer.backgroundColor = [UIColor clearColor];
    
    [_introduceContainer removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_introduceContainer];
    
    [_introduceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_introduceBar.mas_bottom);
    }];
}

- (void)initSv1 {
    //    _articleScrollView = [[ArticleScrollView alloc] init];
    //    _articleScrollView.imageArray = _articleDataModel.imageArray;
    //    _articleScrollView.backgroundColor = [UIColor whiteColor];
    //    _articleScrollView1.index = 1;
    [_articleScrollView removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_articleScrollView];
    
    [_articleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.mas_equalTo(_introduceContainer.mas_bottom).with.offset(3);
        //        make.height.equalTo(([AppConstants uiScreenWidth] - 60) / 3 + 20));
        make.height.equalTo([NSNumber numberWithInt:([AppConstants uiScreenWidth] / 3 + 30)]);
    }];
    
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_articleScrollView.mas_bottom).with.offset(3);
    }];
    
    [_view1 removeFromSuperview];
    [_view2 removeFromSuperview];
    
    _view1 = [[UIImageView alloc] init];
    _view1.image = [UIImage imageNamed:@"goDetail"];
    _view1.transform = CGAffineTransformMakeRotation(M_PI);
    _view1.alpha = 0.5;
    
    _view2 = [[UIImageView alloc] init];
    _view2.image = [UIImage imageNamed:@"goDetail"];
    _view2.alpha = 0.5;
    
    [_verticalScrollView addSubview:_view1];
    [_verticalScrollView addSubview:_view2];
    
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_articleScrollView).with.offset(5);
        make.left.equalTo(_articleScrollView).with.offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_articleScrollView).with.offset(5);
        make.right.equalTo(_articleScrollView).with.offset(-5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    [self getLaunchImage];
    /*
     int x = arc4random() % 10;
     
     NSLog(@"x = %d", x);
     
     // 10%概率提示用户更新
     if (x == 5) {
     [self checkForUpdate];
     }*/
}
/*
 - (void)checkForUpdate {
 
 __block NSString *version;
 
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 manager.responseSerializer = [AFJSONResponseSerializer serializer];
 
 AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
 securityPolicy.allowInvalidCertificates = YES;
 manager.securityPolicy = securityPolicy;
 
 NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", [AppConstants AppID]];
 
 [manager GET:urlString parameters:nil
 success:^(AFHTTPRequestOperation *operation,id responseObject) {
 NSLog(@"success urlString = %@", urlString);
 NSLog(@"Success: %@", responseObject);
 
 NSArray *configData = [responseObject valueForKey:@"results"];
 for (id config in configData)
 {
 version = [config valueForKey:@"version"];
 }
 
 if (![version isEqualToString:[AppConstants AppVersion]])
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tishi", @"")
 message:NSLocalizedString(@"xinbanbenkeyong", @"")
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"quxiao", @"")
 otherButtonTitles:NSLocalizedString(@"qianwanggengxin", @"")
 ,nil];
 
 [alert show];
 }
 }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
 NSLog(@"false urlString = %@", urlString);
 NSLog(@"Error: %@", error);
 }];
 }*/

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)searchButtonPress {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    
    searchViewController.hidesBottomBarWhenPushed = YES;
    [searchViewController onSetupBackButton];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma marks -- UIAlertView Delegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", [AppConstants AppID]];
        //            https://itunes.apple.com/cn/app/ge-li-si/id?mt=8
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - AdScrollView delegate
- (void)AdScrollViewClicked {
    int current = _adScrollView.contentOffset.x/[AppConstants uiScreenWidth];
    
    NSLog(@"_ver = %lu", (unsigned long)[[_verticalScrollView subviews] count]);
    
    _adDetailViewController = [[ADDetailViewController alloc] initWithArticleId:((AdDataModel*)[_ADDatas objectAtIndex:current]).articleid andTitle:((AdDataModel*)[_ADDatas objectAtIndex:current]).title andZhaiyao:((AdDataModel*)[_ADDatas objectAtIndex:current]).zhaiyao andImageUrl:((AdDataModel*)[_ADDatas objectAtIndex:current]).imageUrl];
    
    _adDetailViewController.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:_adDetailViewController animated:YES];
    
    _adDetailViewController = nil;
}

#pragma mark - introduceContainer delegate
- (void)introduceContainerClickAtData:(NSObject*)data {
    [AppConstants addHistoryBrowseWithData:(IntroduceDataModel *)data];
    
    _introduceDetailVC = [[IntroduceDetailViewController alloc] initWithData:(IntroduceDataModel *)data];
    
    _introduceDetailVC.view.backgroundColor = [UIColor whiteColor];
    _introduceDetailVC.hidesBottomBarWhenPushed = YES;
    _introduceDetailVC.navigationItem.title = ((IntroduceDataModel *)data).formulaName;
    
    [self.navigationController pushViewController:_introduceDetailVC animated:YES];
    
    _introduceDetailVC = nil;
}

#pragma mark - introduceContainer delegate
- (void) articleScrollViewClickAtIndex:(NSInteger)index {
    NSLog(@"articleScrollViewClickAtIndex");
    
    _adDetailViewController = [[ADDetailViewController alloc] initWithArticleId:((ArticleDataModel*)[_ArticleDatas objectAtIndex:index]).articleid andTitle:((ArticleDataModel*)[_ArticleDatas objectAtIndex:index]).title andZhaiyao:((ArticleDataModel*)[_ArticleDatas objectAtIndex:index]).zhaiyao andImageUrl:((ArticleDataModel*)[_ArticleDatas objectAtIndex:index]).imageUrl];
    
    _adDetailViewController.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:_adDetailViewController animated:YES];
    
    _adDetailViewController = nil;
}

#pragma mark - Refresh delegate
- (void)viewWillRefresh {
    NSLog(@"viewWillRefresh");
    //    [self removeClickedObservers];
    
    _verticalScrollView.userInteractionEnabled = NO;
}

- (void)viewDidRefresh {
    NSLog(@"viewDidRefresh");
    
    _verticalScrollView.userInteractionEnabled = YES;
}

#pragma UIScrollView Delegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
