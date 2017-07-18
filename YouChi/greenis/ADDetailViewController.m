//
//  ADDetailViewController.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/20.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "ADDetailViewController.h"
#import "Masonry.h"
#import "FileOperator.h"
#import "AppConstants.h"
#import "IntroduceContainer.h"
#import "IntroduceDetailViewController.h"
#import "BTConstants.h"

#import "ProgressHUD.h"
#import "SDRefresh.h"

#import "UIImageView+YYWebImage.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@interface ADDetailViewController () <IntroduceContainerDelegate, RefreshDelegate>

@property (strong, nonatomic) NSString                      *articleId;
@property (strong, nonatomic) NSString                      *titleStr;
@property (strong, nonatomic) NSString                      *zhaiyao;
//在view上的滑动试图
@property (strong, nonatomic) UIScrollView                  *verticalScrollView;
@property (strong, nonatomic) UIView                        *verticalScrollViewContainer;
@property (strong, nonatomic) UIImageView                   *titleImageView;
@property (strong, nonatomic) IntroduceContainer            *introduceContainer;

@property (strong, nonatomic) IntroduceDetailViewController *introduceDetailVC;

@property (nonatomic) BOOL                                  isDataShow;
@property (strong, nonatomic) UIButton                      *getDataFailButton;

@property (nonatomic) NSInteger                                 currentPage;
@property (nonatomic) float                             totalHeight;

@property (nonatomic, strong) MASConstraint             *bottomConstraint;
@property (nonatomic, strong) MASConstraint             *heightConstraint;

@property (strong, nonatomic) NSMutableArray                    *IntroduceDataDics;
@property (strong, nonatomic) NSMutableArray                    *IntroduceDatas;

@property (strong, nonatomic) NSString                  *imageUrl;

@property (strong, nonatomic) UIView                    *headerView;
@end

@implementation ADDetailViewController

- (instancetype)initWithArticleId:(NSString *)articleId andTitle:(NSString*)title andZhaiyao:(NSString *)zhaiyao andImageUrl:(NSString*)imageUrl{
    self = [super init];
    if (self) {
        _articleId = articleId;
        _titleStr = title;
        _zhaiyao = zhaiyao;
        _imageUrl = imageUrl;
    }
    return self;
}

- (instancetype)initWithAdDataModel:(AdDataModel *)m
{
    self = [super init];
    if (self) {
        _adDataModel = m;
        _articleId = m.articleid;
        _titleStr = m.title;
        _zhaiyao = m.zhaiyao;
        _imageUrl = m.imageUrl;
    }
    return self;
}
/*
- (void)viewDidLayoutSubviews {
    //    NSLog(@"effectView width = %f, height = %f", _effectView.frame.size.width, _effectView.frame.size.height);
    
    float totalY = _titleImageView.frame.size.height + _introduceContainer.frame.size.height;
    
    if (totalY > _totalHeight) {
        _totalHeight = totalY;
    }
    
    NSLog(@"_totalHeight = %f", _totalHeight);
    
    if (_totalHeight < [AppConstants uiScreenHeight] - [AppConstants uiNavigationBarHeight]) {
        NSLog(@"if %d %d", [AppConstants uiScreenHeight], [AppConstants uiNavigationBarHeight]);
        [_bottomConstraint uninstall];
        
        [_verticalScrollViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            _heightConstraint = make.height.mas_equalTo([AppConstants uiScreenHeight] - [AppConstants uiNavigationBarHeight] + 1);
        }];
    }
    else {
        NSLog(@"else %d %d", [AppConstants uiScreenHeight], [AppConstants uiNavigationBarHeight]);
        [_heightConstraint uninstall];
        
        [_verticalScrollViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            _bottomConstraint = make.bottom.equalTo(_introduceContainer.mas_bottom);
        }];
    }
}*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isDataShow = NO;
    _currentPage = 1;

    [self initNavigationBar];
    [self initVerticalScrollView];
    [self requestData];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([AppConstants downloadButtonPress2Pop]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)initNavigationBar {
    self.navigationItem.title = _titleStr;
    
}

- (void)requestData {
    [_getDataFailButton removeFromSuperview];
    
    if (_isDataShow == NO) {
        [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    }
    
    [self getDataFromServerWithPage:_currentPage];
}

- (void)getDataFromServerWithPage:(NSInteger)page {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@resource/article/detail/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"ArticleId":_articleId, @"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
    
    [HTTP_CLIENT POST:urlString parameters:parameters
          progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"success urlString = %@", urlString);
                //NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSArray *articles = [responseObject objectForKey:@"formulas"];
                  
                  _IntroduceDataDics = [[NSMutableArray alloc] init];
                  [_IntroduceDataDics addObjectsFromArray:articles];
                  
                  _IntroduceDatas = [[NSMutableArray alloc] init];
                  
                  for (int i = 0; i < _IntroduceDataDics.count; i++) {
                      IntroduceDataModel *dataModel = [[IntroduceDataModel alloc] init];
                      dataModel.effect = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Effect"];
                      dataModel.formulaID = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"FormulaID"];
                      dataModel.formulaName = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"FormulaName"];
                      dataModel.imageUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"ImgUrl"];
                      dataModel.ingredients = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Ingredients"];
                      dataModel.introduction = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Introduction"];
                      dataModel.steps = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Steps"];
                      dataModel.userNickName = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"UserNickName"];
                      dataModel.videoUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"VideoUrl"];
                      dataModel.albumsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"albums_total"];
                      dataModel.commentTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"comment_total"];
                      dataModel.friendsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"friends_total"];
                      dataModel.stepTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"step_total"];
                      dataModel.tagsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"tags_total"];
                      dataModel.shareUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"share_url"];
                      
                      [_IntroduceDatas addObject:dataModel];
                  }
                  
                  [self setDataAndShowViews];
                  
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                  NSLog(@"获取列表失败 %@", urlString);
                  
                  [self getDataFail];
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"false urlString = %@", urlString);
              NSLog(@"Error: %@", error);
              
              [self getDataFail];
          }];
}

- (void)getDataFail {
//    当数据没有加载出来时，显示一个WiFi的button
    [_getDataFailButton removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADDetailRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADDetailRequestFail" object:nil];
    
    [ProgressHUD showError:NSLocalizedString(@"jiazaishibai", @"")];
    
    if (_isDataShow == NO) {
        _getDataFailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getDataFailButton setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
        [_getDataFailButton addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_getDataFailButton];
        
        [_getDataFailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.width.and.height.equalTo(@160);
        }];
    }
}

- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    refreshFooter.delegate = self;
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshFooter addToScrollView:_verticalScrollView];
    
    __weak SDRefreshFooterView *weakRefreshFooter = refreshFooter;
    refreshFooter.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"Refreshing");
            
            [NSThread detachNewThreadSelector:@selector(loadMore) toTarget:self withObject:nil];
            
            [weakRefreshFooter endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    //    [refreshHeader beginRefreshing];
}

- (void)loadMore {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreDone) name:@"loadMoreDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreFail) name:@"loadMoreFail" object:nil];
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [_introduceContainer loadMoreWithPage:_currentPage + 1 andID:_articleId];
    });
}

- (void)loadMoreDone {
    _currentPage++;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadMoreDone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadMoreFail" object:nil];
}

- (void)loadMoreFail {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadMoreDone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadMoreFail" object:nil];
}

- (void) setDataAndShowViews{

    [self setIntroduceData];
    [self initViews];
    
    if ([_IntroduceDatas count] >= 5) {
        [self setupFooter];
    }
    
    [self.view setNeedsUpdateConstraints];
}

- (void)setIntroduceData {
    
    _introduceContainer = [[IntroduceContainer alloc] initWithDatas:_IntroduceDatas andStyle:StyleRecipe];
    
    _introduceContainer.delegate = self;
}

- (void)initViews {
    [self initTitleImageView];
    [self initIntroduceContainer];
    
    [self.view setNeedsUpdateConstraints];
    
    _isDataShow = YES;
    
    [_getDataFailButton removeFromSuperview];
    
    [ProgressHUD dismiss];
}

- (void)initVerticalScrollView {
    _verticalScrollView = [UIScrollView new];
    _verticalScrollView.backgroundColor = [UIColor whiteColor];
    _verticalScrollView.scrollsToTop = YES;
    [self.view addSubview:_verticalScrollView];
    [_verticalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
        //scroview和view大小相同
        make.top.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);//.with.offset([AppConstants uiTabBarHeight]);
    }];
    //一个view
    _verticalScrollViewContainer = [UIView new];
    _verticalScrollViewContainer.backgroundColor = [UIColor whiteColor];
    [_verticalScrollView addSubview:_verticalScrollViewContainer];
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_verticalScrollView);
        make.width.equalTo(_verticalScrollView);
    }];
}


- (void)initTitleImageView {
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_headerView];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(_verticalScrollViewContainer);
        //        make.height.mas_equalTo([AppConstants uiScreenHeight] / 4);
    }];
    
    _titleImageView = [[UIImageView alloc] init];
    
    _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    _titleImageView.clipsToBounds = YES;
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], _imageUrl];
    
    [_titleImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];

    [_headerView addSubview:_titleImageView];
    
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verticalScrollViewContainer.mas_top);
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.height.mas_equalTo([AppConstants uiScreenHeight] / 3);
    }];
    
    UIView *zhaiyaoView = [[UIView alloc] init];
    zhaiyaoView.backgroundColor = [AppConstants backgroundColor];
    
    UILabel *zhaiyaoLabel = [[UILabel alloc] init];
    zhaiyaoLabel.font = [UIFont systemFontOfSize:15];
    zhaiyaoLabel.textColor = [UIColor blackColor];
    zhaiyaoLabel.text = _zhaiyao;
    zhaiyaoLabel.textAlignment = NSTextAlignmentLeft;
    zhaiyaoLabel.numberOfLines = 0;
    
    [_headerView addSubview:zhaiyaoView];
    [_headerView addSubview:zhaiyaoLabel];
    
    [zhaiyaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleImageView.mas_bottom).with.offset(5);
        make.width.equalTo(_titleImageView).with.offset(-20);
//        make.bottom.equalTo(_titleImageView).with.offset(-5);
        make.centerX.equalTo(_titleImageView);
    }];

    [zhaiyaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_titleImageView.mas_bottom);
//        make.top.and.bottom.equalTo(zhaiyaoLabel);
        make.centerX.equalTo(_titleImageView);
        make.height.equalTo(zhaiyaoLabel.mas_height).with.offset(10);
    }];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(zhaiyaoView.mas_bottom).with.offset(5);
    }];
}

- (void)initIntroduceContainer {
    _introduceContainer.backgroundColor = [UIColor clearColor];
    
    [_introduceContainer removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_introduceContainer];
    
    [_introduceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_headerView.mas_bottom);
    }];
    
    if (_introduceContainer.totalCount < 5) {
        [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            _heightConstraint = make.height.mas_equalTo([AppConstants uiScreenHeight] - [AppConstants uiNavigationBarHeight] + 1);
        }];
    }
    else {
        [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            _bottomConstraint = make.bottom.equalTo(_introduceContainer.mas_bottom);
        }];
    }
    
}

#pragma mark - introduceContainer delegate
- (void)introduceContainerClickAtData:(NSObject *)data {

    [AppConstants addHistoryBrowseWithData:(IntroduceDataModel *)data];

    _introduceDetailVC = [[IntroduceDetailViewController alloc] initWithData:(IntroduceDataModel *)data];

    _introduceDetailVC.view.backgroundColor = [UIColor whiteColor];

    _introduceDetailVC.navigationItem.title = ((IntroduceDataModel*)data).formulaName;
    
    [self.navigationController pushViewController:_introduceDetailVC animated:YES];
    
    _introduceDetailVC = nil;
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

- (void)dealloc {
    NSLog(@"dealloc");
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
