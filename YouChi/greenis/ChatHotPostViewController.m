//
//  ChatPostViewController.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/12.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "ChatHotPostViewController.h"
#import "AppConstants.h"
#import "Masonry.h"
#import "ProgressHUD.h"
#import "PlistEditor.h"
#import "SDRefresh.h"
#import "PostContainer.h"

#import "PostPhotoBrowserViewController.h"
#import "ChatPostDetailViewController.h"

#import "ChatQueryUserViewController.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@interface ChatHotPostViewController () <RefreshDelegate, PostContainerDelegate, PostDetailViewDelegate>

@property (nonatomic) BOOL                                      isDataShow;
@property (strong, nonatomic) UIScrollView                      *verticalScrollView;
@property (strong, nonatomic) UIView                            *verticalScrollViewContainer;
@property (strong, nonatomic) PostContainer                     *postContainer;

@property (nonatomic) BOOL                                      isChatPostDataLoaded;

@property (strong, nonatomic) NSMutableArray                    *ChatLiaoLiaoDataDics;
@property (strong, nonatomic) NSMutableArray                    *ChatLiaoLiaoDatas;

@property (strong, nonatomic) UIButton                          *getDataFailButton;

@end

@implementation ChatHotPostViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    _isDataShow = NO;
    
    [self initNavigationBar];
    [self initVerticalScrollView];
//    [self setupRefreshHeader];
    [self initStatus];
    
    [ProgressHUD show:NSLocalizedString(@"loading", @"")];

    [self getDataFromServer];
}

- (void)getDataFromServer {/*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/post/list/hot/top10/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"AccessToken":[AppConstants userInfo].accessToken};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              //                NSLog(@"success urlString = %@", urlString);
              //                NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSArray *posts = [responseObject objectForKey:@"posts"];
                  
                  _ChatLiaoLiaoDataDics = [[NSMutableArray alloc] init];
                  [_ChatLiaoLiaoDataDics addObjectsFromArray:posts];
                  
                  _ChatLiaoLiaoDatas = [[NSMutableArray alloc] init];
                  
                  for (int i = 0; i < _ChatLiaoLiaoDataDics.count; i++) {
                      ChatLiaoLiaoPostDataModel *dataModel = [[ChatLiaoLiaoPostDataModel alloc] init];
                      dataModel.addtime = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"add_time"];
                      dataModel.clickDegree = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"click_degree"];
                      dataModel.commentDegree = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"comment_degree"];
                      dataModel.content = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"content"];
                      dataModel.hotDegree = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"hot_degree"];
                      dataModel.Id = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"id"];
                      dataModel.avatar = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"avatar"];
                      dataModel.thumbsupDegree = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumbsup_degree"];
                      dataModel.userId = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"userId"];
                      dataModel.userName = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"nickName"];
                      dataModel.image1URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image1URL"];
                      dataModel.image2URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image2URL"];
                      dataModel.image3URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image3URL"];
                      dataModel.image4URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image4URL"];
                      dataModel.image5URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image5URL"];
                      dataModel.image6URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image6URL"];
                      dataModel.image7URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image7URL"];
                      dataModel.image8URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image8URL"];
                      dataModel.image9URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image9URL"];
                      dataModel.thumbImage1URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image1URL"];
                      dataModel.thumbImage2URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image2URL"];
                      dataModel.thumbImage3URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image3URL"];
                      dataModel.thumbImage4URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image4URL"];
                      dataModel.thumbImage5URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image5URL"];
                      dataModel.thumbImage6URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image6URL"];
                      dataModel.thumbImage7URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image7URL"];
                      dataModel.thumbImage8URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image8URL"];
                      dataModel.thumbImage9URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image9URL"];
                      dataModel.liked = [[[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"isThumbsup"] intValue] == 1 ? @"1" : @"0";
                      
                      [_ChatLiaoLiaoDatas addObject:dataModel];
                  }
                  
                  [self setChatPostViewData];
              }
              else if ([[responseObject objectForKey:@"errno"] isEqualToString:@"4401"]) {
                  [AppConstants relogin:^(BOOL success){
                      if (success) {
                          [self getDataFromServer];
                      }
                      else {
                          [AppConstants notice2ManualRelogin];
                      }
                  }];
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                  NSLog(@"获取列表失败 %@", urlString);
                  
                  [self getDataFail];
              }
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              NSLog(@"false urlString = %@", urlString);
              NSLog(@"Error: %@", error);
              
              [self getDataFail];
          }];
*/}

- (void)initNavigationBar {
    self.navigationItem.title = NSLocalizedString(@"zuihuotiezi", @"");
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

- (void)setupRefreshHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    refreshHeader.delegate = self;
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_verticalScrollView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"Refreshing");
            
            [NSThread detachNewThreadSelector:@selector(reloadAllData) toTarget:self withObject:nil];
            
            [weakRefreshHeader endRefreshing];
        });
    };
}

- (void)initStatus {
    _isDataShow = NO;
}

- (void)setChatPostViewData {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatPostRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatPostRequestFail" object:nil];
    
    _postContainer = [[PostContainer alloc] initWithDatas:_ChatLiaoLiaoDatas andPostType:PostNormal];
    
    _postContainer.delegate = self;
    
    _isChatPostDataLoaded = YES;
    
    [self prepareToShowData];
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

- (void)reloadAllData {
    [_getDataFailButton removeFromSuperview];

    if (!_isDataShow) {
        [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    }
    
    [self getDataFromServer];
}

- (void)prepareToShowData {
    
    if (_isChatPostDataLoaded)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initViews];
        });
    }
}

- (void)initViews {
    [self initPostContainer];
    
    _isDataShow = YES;
    
    [ProgressHUD dismiss];
}

- (void)initPostContainer {
    NSLog(@"initPostContainer");
    
    _postContainer.backgroundColor = [UIColor whiteColor];
    
    [_postContainer removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_postContainer];
    
    [_postContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(_verticalScrollViewContainer);
    }];
    
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_postContainer);
    }];
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

#pragma mark - PostDetailViewDelegate delegate
- (void)postDetailViewChangeWithData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index {
    [_postContainer changeWithData:data atIndex:index];
}

#pragma mark - postContainer delegate
- (void)postContainerClickAtData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index {
    
    ChatPostDetailViewController *chatPostDetailViewController = [[ChatPostDetailViewController alloc] initWithData:data andIndex:index];
    
    chatPostDetailViewController.delegate = self;
    
    [self.navigationController pushViewController:chatPostDetailViewController animated:YES];
}

- (void)postContainerLikeByPostid:(NSString*)postid {
    
}

- (void)postContainerHeadImageViewClickByUserid:(NSString*)userid andUsername:(NSString*)username andUserAvatar:(NSString*)Avatar {
    NSLog(@"userid = %@", userid);
    
    ChatQueryUserViewController *chatQueryUserViewController = [[ChatQueryUserViewController alloc] initWithUserid:userid andUserAvatar:Avatar andUsername:username];
    
    chatQueryUserViewController.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:chatQueryUserViewController animated:YES];
}

- (void)postContainerContentImageViewClickAtIndex:(NSInteger)index andImages:(NSArray*)images {
    NSLog(@"index = %ld, images count = %lu", (long)index, (unsigned long)[images count]);
    
    PostPhotoBrowserViewController *photoBrowserViewController = [[PostPhotoBrowserViewController alloc] initWithImages:images isUrl:YES andIndex:index];
    
    [self presentViewController:photoBrowserViewController animated:YES completion:nil];
    
    //    photoBrowserViewController.hidesBottomBarWhenPushed = YES;
    
    //    [self.navigationController pushViewController:photoBrowserViewController animated:YES];
    
    //    [self.navigationController presentViewController:photoBrowserViewController animated:YES completion:nil];
}

- (void)postContainerLongPressAtData:(ChatLiaoLiaoPostDataModel *)data {
    
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