//
//  ChatViewController.m
//  Fruit-juice-iOS6
//
//  Created by LICAN LONG on 15/7/13.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "ChatViewController.h"
#import "AppConstants.h"
#import "Masonry.h"
#import "ProgressHUD.h"
#import "PlistEditor.h"
#import "SDRefresh.h"
#import "AdScrollView.h"
#import "ChatAdDataModel.h"
#import "IntroduceContainer.h"
#import "ChatTopicDataModel.h"
#import "ChatUserDataModel.h"
#import "ChatCollectionContainer.h"
#import "ChatActivityViewController.h"
#import "ChatHotPostViewController.h"
#import "ChatQueryUserViewController.h"
#import "ChatTopicViewController.h"
#import "ChatLiaoLiaoPostDataModel.h"
#import "PostContainer.h"
#import "PostPhotoBrowserViewController.h"
#import "ChatADViewController.h"
#import "ChatPostDetailViewController.h"
#import "PostViewController.h"
#import "LocalImageViewController.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#import "FileOperator.h"
#import "YYKit.h"

@interface ChatViewController () <RefreshDelegate, AdScrollViewDelegate, IntroduceContainerDelegate, ChatCollectionContainerDelegate, PostContainerDelegate, UIScrollViewDelegate, LocalImageViewControllerDelegate, PostDetailViewDelegate>

@property (nonatomic) BOOL                                      isDataShow;
@property (strong, nonatomic) UIScrollView                      *verticalScrollView;
@property (strong, nonatomic) UIView                            *verticalScrollViewContainer;
@property (strong, nonatomic) AdScrollView                      *adScrollView;
@property (strong, nonatomic) UIView                            *buttonContainer;
@property (strong, nonatomic) IntroduceContainer                *topicContainer;
@property (strong, nonatomic) ChatCollectionContainer           *userCollectionContainer;

@property (strong, nonatomic) ChatActivityViewController        *chatActivityViewController;
@property (strong, nonatomic) ChatHotPostViewController         *chatHotPostViewController;

@property (strong, nonatomic) UIButton                          *getDataFailButton;

@property (nonatomic) BOOL                                      isChatADScrollViewDataLoaded;
@property (nonatomic) BOOL                                      isChatTopicDataLoaded;
@property (nonatomic) BOOL                                      isChatLiaoLiaoDataLoaded;

@property (nonatomic) BOOL                                      isChatUserDataLoaded;
@property (nonatomic) NSInteger                                 currentPage;

@property (strong, nonatomic) PostContainer                     *postContainer;

@property (nonatomic) BOOL                                      isLoadingMore;

@property (nonatomic) BOOL                                      isPush;
@property (nonatomic) BOOL                                      isAllowPush;
@property (strong, nonatomic) NSArray                           *selectedImages;

@property (strong, nonatomic) LocalImageViewController          *localImageViewController;

@property (strong, nonatomic) NSMutableArray                    *ChatADDataDics;
@property (strong, nonatomic) NSMutableArray                    *ChatTopicDataDics;
@property (strong, nonatomic) NSMutableArray                    *ChatUserDataDics;
@property (strong, nonatomic) NSMutableArray                    *ChatLiaoLiaoDataDics;

@property (strong, nonatomic) NSMutableArray                    *ChatADDatas;
@property (strong, nonatomic) NSMutableArray                    *ChatTopicDatas;
@property (strong, nonatomic) NSMutableArray                    *ChatUserDatas;
@property (strong, nonatomic) NSMutableArray                    *ChatLiaoLiaoDatas;

@property (strong, nonatomic) SDRefreshHeaderView               *refreshHeader;
@end

@implementation ChatViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isPush && _isAllowPush) {
        _isAllowPush = NO;
        _isPush = NO;
//        发表聊聊界面
        PostViewController *postViewController = [[PostViewController alloc] initWithImages:_selectedImages andPrefix:@"" andID:@""];
        postViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:postViewController animated:YES];
    }
    
    if (((AppDelegate*)[[UIApplication sharedApplication] delegate]).isChatCacheCleared) {
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).isChatCacheCleared = NO;
        
        NSLog(@"refresh");
        
        [self reloadAllData];
    }
    
    if ([AppConstants isJustPostANewPost]) {
        [AppConstants setJustPostANewPost:NO];
        [self reloadAllData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _isDataShow = NO;
    _currentPage = 1;
    _isLoadingMore = NO;
    
    _isChatADScrollViewDataLoaded = NO;
    _isChatTopicDataLoaded = NO;
    _isChatUserDataLoaded = NO;
    _isChatLiaoLiaoDataLoaded = NO;
    
    _ChatADDataDics = [[NSMutableArray alloc] init];
    _ChatTopicDataDics = [[NSMutableArray alloc] init];
    _ChatUserDataDics = [[NSMutableArray alloc] init];
    _ChatLiaoLiaoDataDics = [[NSMutableArray alloc] init];
    _ChatADDatas = [[NSMutableArray alloc] init];
    _ChatTopicDatas = [[NSMutableArray alloc] init];
    _ChatUserDatas = [[NSMutableArray alloc] init];
    _ChatLiaoLiaoDatas = [[NSMutableArray alloc] init];
    
    [self initNavigationBar];
    [self initVerticalScrollView];
    [self setupRefreshHeader];
    [self setupFooter];
    
    [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    
    if (![FileOperator fileExist:[AppConstants localFileChatADData]]) {
        NSLog(@"server");
        [self getChatADDataFromServer];
    }
    else {
        NSLog(@"local");
        [self getChatADDataFromLocal];
    }
    
    if (![FileOperator fileExist:[AppConstants localFileChatTopicData]]) {
        NSLog(@"server");
        [self getChatTopicDataFromServer];
    }
    else {
        NSLog(@"local");
        [self getChatTopicDataFromLocal];
    }
    
    if (![FileOperator fileExist:[AppConstants localFileChatUserData]]) {
        NSLog(@"server");
        [self getChatUserDataFromServer];
    }
    else {
        NSLog(@"local");
        [self getChatUserDataFromLocal];
    }
    
    if (![FileOperator fileExist:[AppConstants localFileChatLiaoLiaoData]]) {
        NSLog(@"server");
        [self getChatLiaoLiaoDataFromServerWithPage:_currentPage];
    }
    else {
        NSLog(@"local");
        [self getChatLiaoLiaoDataFromLocal];
    }
}

- (void)getChatADDataFromServer {/*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/topic/ad/query/list/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"page":@"1", @"pageSize":@"10"};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
            NSLog(@"success urlString 222222222222222222= %@", urlString);
            NSLog(@"Success: 22222222222222222222222222222%@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSArray *ADs = [responseObject objectForKey:@"ADs"];
                  
                  _ChatADDataDics = [[NSMutableArray alloc] init];
                  [_ChatADDataDics addObjectsFromArray:ADs];
                  
                  [AppConstants saveDicWithKey:[AppConstants localFileChatADData] andArray:_ChatADDataDics];
                  
                  [self getChatADDataFromLocal];
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

- (void)getChatADDataFromLocal {
    [_ChatADDatas removeAllObjects];
    [_ChatADDataDics removeAllObjects];
    
    NSData *data = [AppConstants loadDataWithKey:[AppConstants localFileChatADData]];
    ChatADDatas *info = [ChatADDatas modelWithJSON:data];

    [_ChatADDataDics addObjectsFromArray:info.datas];
    
    for (int i = 0; i < info.datas.count; i++) {
        ChatAdDataModel *dataModel = [[ChatAdDataModel alloc] init];
        dataModel.adType = [[info.datas objectAtIndex:i] objectForKey:@"ad_type"];
        dataModel.addtime = [[info.datas objectAtIndex:i] objectForKey:@"add_time"];
        dataModel.content = [[info.datas objectAtIndex:i] objectForKey:@"content"];
        dataModel.Id = [[info.datas objectAtIndex:i] objectForKey:@"id"];
        dataModel.imageUrl = [[info.datas objectAtIndex:i] objectForKey:@"img_url"];
        dataModel.name = [[info.datas objectAtIndex:i] objectForKey:@"name"];
        dataModel.shareUrl = [[info.datas objectAtIndex:i] objectForKey:@"share_url"];
        dataModel.topicIdFk = [[info.datas objectAtIndex:i] objectForKey:@"topic_id_fk"];

        [_ChatADDatas addObject:dataModel];
    }
    
    [self setChatAdScrollViewData];
}

- (void)getChatTopicDataFromServer {/*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/query/topic/org/list/hot/top10/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"page":@"1", @"pageSize":@"10"};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              //                  NSLog(@"success urlString = %@", urlString);
              //                  NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSArray *topics = [responseObject objectForKey:@"Topics"];
                  
                  _ChatTopicDataDics = [[NSMutableArray alloc] init];
                  [_ChatTopicDataDics addObjectsFromArray:topics];
                  
                  [AppConstants saveDicWithKey:[AppConstants localFileChatTopicData] andArray:_ChatTopicDataDics];
                  
                  [self getChatTopicDataFromLocal];
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

- (void)getChatTopicDataFromLocal {
    [_ChatTopicDatas removeAllObjects];
    [_ChatTopicDataDics removeAllObjects];
    
    NSData *data = [AppConstants loadDataWithKey:[AppConstants localFileChatTopicData]];
    ChatTopicDatas *info = [ChatTopicDatas modelWithJSON:data];
    
    [_ChatADDataDics addObjectsFromArray:info.datas];
    
    for (int i = 0; i < info.datas.count; i++) {
        ChatTopicDataModel *dataModel = [[ChatTopicDataModel alloc] init];
        dataModel.addTime = [[info.datas objectAtIndex:i] objectForKey:@"add_time"];
        dataModel.content = [[info.datas objectAtIndex:i] objectForKey:@"content"];
        dataModel.Id = [[info.datas objectAtIndex:i] objectForKey:@"id"];
        dataModel.forumPostTotal = [[info.datas objectAtIndex:i] objectForKey:@"forum_post_total"];
        dataModel.hotDegree = [[info.datas objectAtIndex:i] objectForKey:@"hot_degree"];
        dataModel.imageUrl = [[info.datas objectAtIndex:i] objectForKey:@"img_url"];
        dataModel.name = [[info.datas objectAtIndex:i] objectForKey:@"name"];
        dataModel.shareUrl = [[info.datas objectAtIndex:i] objectForKey:@"share_url"];
        
        [_ChatTopicDatas addObject:dataModel];
    }
    
    [self setChatTopicViewData];
}

- (void)getChatUserDataFromServer {/*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/interaction/users/query/exp/user/list/top10/index.ashx", [AppConstants httpHeader]];
    
//    NSDictionary *parameters = @{@"AccessToken":@""};
    
    [manager POST:urlString parameters:nil
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              //                  NSLog(@"success urlString = %@", urlString);
              //                  NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSArray *users = [responseObject objectForKey:@"users"];
                  
                  _ChatUserDataDics = [[NSMutableArray alloc] init];
                  [_ChatUserDataDics addObjectsFromArray:users];
                  
                  [AppConstants saveDicWithKey:[AppConstants localFileChatUserData] andArray:_ChatUserDataDics];
                  
                  [self getChatUserDataFromLocal];
              }
              else if ([[responseObject objectForKey:@"errno"] isEqualToString:@"4401"]) {
                  [AppConstants relogin:^(BOOL success){
                      if (success) {
                          [self getChatUserDataFromServer];
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

- (void)getChatUserDataFromLocal {
    [_ChatUserDatas removeAllObjects];
    [_ChatUserDataDics removeAllObjects];
    
    NSData *data = [AppConstants loadDataWithKey:[AppConstants localFileChatUserData]];
    ChatUserDatas *info = [ChatUserDatas modelWithJSON:data];
    
    [_ChatUserDataDics addObjectsFromArray:info.datas];
    
    for (int i = 0; i < info.datas.count; i++) {
        ChatUserDataModel *dataModel = [[ChatUserDataModel alloc] init];
        dataModel.avatar = [[info.datas objectAtIndex:i] objectForKey:@"avatar"];
        dataModel.exp = [[info.datas objectAtIndex:i] objectForKey:@"exp"];
        dataModel.Id = [[info.datas objectAtIndex:i] objectForKey:@"id"];
        dataModel.nickname = [[info.datas objectAtIndex:i] objectForKey:@"nick_name"];
        dataModel.regtime = [[info.datas objectAtIndex:i] objectForKey:@"reg_time"];
        dataModel.sex = [[info.datas objectAtIndex:i] objectForKey:@"sex"];
        dataModel.username = [[info.datas objectAtIndex:i] objectForKey:@"nick_name"];
        
        [_ChatUserDatas addObject:dataModel];
    }
    
    [self setChatUserViewData];
}

- (void)getChatLiaoLiaoDataFromServerWithPage:(NSInteger)page {/*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/post/list/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"AccessToken":[AppConstants userInfo].accessToken, @"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              NSLog(@"success urlString = %@", urlString);
              NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSArray *posts = [responseObject objectForKey:@"posts"];
                  
                  _ChatLiaoLiaoDataDics = [[NSMutableArray alloc] init];
                  [_ChatLiaoLiaoDataDics addObjectsFromArray:posts];
                  
                  [AppConstants saveDicWithKey:[AppConstants localFileChatLiaoLiaoData] andArray:_ChatLiaoLiaoDataDics];
                  
                  [self getChatLiaoLiaoDataFromLocal];
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

- (void)getChatLiaoLiaoDataFromLocal {
    [_ChatLiaoLiaoDatas removeAllObjects];
    [_ChatLiaoLiaoDataDics removeAllObjects];
    
    NSData *data = [AppConstants loadDataWithKey:[AppConstants localFileChatLiaoLiaoData]];
    ChatLiaoLiaoPostDatas *info = [ChatLiaoLiaoPostDatas modelWithJSON:data];
    
    [_ChatLiaoLiaoDataDics addObjectsFromArray:info.datas];
    
    for (int i = 0; i < info.datas.count; i++) {
        ChatLiaoLiaoPostDataModel *dataModel = [[ChatLiaoLiaoPostDataModel alloc] init];
        dataModel.addtime = [[info.datas objectAtIndex:i] objectForKey:@"add_time"];
        dataModel.clickDegree = [[info.datas objectAtIndex:i] objectForKey:@"click_degree"];
        dataModel.commentDegree = [[info.datas objectAtIndex:i] objectForKey:@"comment_degree"];
        dataModel.content = [[info.datas objectAtIndex:i] objectForKey:@"content"];
        dataModel.hotDegree = [[info.datas objectAtIndex:i] objectForKey:@"hot_degree"];
        dataModel.Id = [[info.datas objectAtIndex:i] objectForKey:@"id"];
        dataModel.avatar = [[info.datas objectAtIndex:i] objectForKey:@"avatar"];
        dataModel.thumbsupDegree = [[info.datas objectAtIndex:i] objectForKey:@"thumbsup_degree"];
        dataModel.userId = [[info.datas objectAtIndex:i] objectForKey:@"userId"];
        dataModel.userName = [[info.datas objectAtIndex:i] objectForKey:@"nickName"];
        dataModel.image1URL = [[info.datas objectAtIndex:i] objectForKey:@"image1URL"];
        dataModel.image2URL = [[info.datas objectAtIndex:i] objectForKey:@"image2URL"];
        dataModel.image3URL = [[info.datas objectAtIndex:i] objectForKey:@"image3URL"];
        dataModel.image4URL = [[info.datas objectAtIndex:i] objectForKey:@"image4URL"];
        dataModel.image5URL = [[info.datas objectAtIndex:i] objectForKey:@"image5URL"];
        dataModel.image6URL = [[info.datas objectAtIndex:i] objectForKey:@"image6URL"];
        dataModel.image7URL = [[info.datas objectAtIndex:i] objectForKey:@"image7URL"];
        dataModel.image8URL = [[info.datas objectAtIndex:i] objectForKey:@"image8URL"];
        dataModel.image9URL = [[info.datas objectAtIndex:i] objectForKey:@"image9URL"];
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
    
    [self setLiaoLiaoPostData];
}

- (void)initNavigationBar {
    self.navigationItem.title = NSLocalizedString(@"liaoliao", @"");
    
    UIImage *postButtonImage = [UIImage imageNamed:@"post"];
    postButtonImage = [postButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:postButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(postButtonPress)];
}

- (void)postButtonPress {
    
    NSLog(@"%@", [[NSLocale preferredLanguages] objectAtIndex:0]);
    
    return;
    
    if ([[AppConstants userInfo].accessToken isEqualToString:@""]) {
        
        [ProgressHUD showError:NSLocalizedString(@"dengluzailiaoliao", @"")];
        
        return;
    }
    
    _isAllowPush = YES;
    
    _localImageViewController = [[LocalImageViewController alloc] init];
    _localImageViewController.maxPhotoNumber = 9;
    _localImageViewController.delegate = self;
    _localImageViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_localImageViewController animated:YES];
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
    
    _verticalScrollView.delegate = self;
}

- (void)setupRefreshHeader
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
    //    [refreshHeader beginRefreshing];
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
        [_postContainer loadMoreWithPage:_currentPage + 1 andID:@""];
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

- (void)reloadAllData {
    [_getDataFailButton removeFromSuperview];
    
    if (_isDataShow == NO) {
        [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    }
    
//    _isDataShow = NO;
    _currentPage = 1;
    _isLoadingMore = NO;
    
    _isChatADScrollViewDataLoaded = NO;
    _isChatTopicDataLoaded = NO;
    _isChatUserDataLoaded = NO;
    _isChatLiaoLiaoDataLoaded = NO;
    
    [self getChatADDataFromServer];
    [self getChatTopicDataFromServer];
    [self getChatUserDataFromServer];
    [self getChatLiaoLiaoDataFromServerWithPage:_currentPage];
}

- (void)setChatAdScrollViewData {
//    广告轮播图
    if (_adScrollView == nil) {
        _adScrollView = [[AdScrollView alloc] init];
        _adScrollView.dataArray = _ChatADDatas;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_verticalScrollView addSubview:_adScrollView.pageControl];
            [_verticalScrollView addSubview:_adScrollView.titleView];
        });
        
    }
    else {
        _adScrollView.dataArray = _ChatADDatas;
    }
    _adScrollView.adDelegate = self;
    _isChatADScrollViewDataLoaded = YES;

    [self prepareToShowData];
}

- (void)setChatTopicViewData {
    if (_isDataShow) {
        NSArray *views = [_topicContainer subviews];
        for(UIView *view in views)
        {
            [view removeFromSuperview];
        }
    }
    
    _topicContainer = [[IntroduceContainer alloc] initWithDatas:_ChatTopicDatas andStyle:StyleTopic];
    
    _topicContainer.delegate = self;
    
    _isChatTopicDataLoaded = YES;
    
    NSLog(@"ChatTopic");
    
    [self prepareToShowData];
}

- (void)setChatUserViewData {
    if (_isDataShow) {
        NSArray *views = [_userCollectionContainer subviews];
        for(UIView *view in views)
        {
            [view removeFromSuperview];
        }
    }
    
    _userCollectionContainer = [[ChatCollectionContainer alloc] initWithDatas:_ChatUserDatas];
    _userCollectionContainer.delegate = self;
    
    _isChatUserDataLoaded = YES;
    
    NSLog(@"ChatUser");
    
    [self prepareToShowData];
}

- (void)setLiaoLiaoPostData {
    if (_isDataShow) {
        NSArray *views = [_postContainer subviews];
        for(UIView *view in views)
        {
            [view removeFromSuperview];
        }
    }

    _postContainer = [[PostContainer alloc] initWithDatas:_ChatLiaoLiaoDatas andPostType:PostNormal];
 
    _postContainer.delegate = self;
    
    _isChatLiaoLiaoDataLoaded = YES;
    
    NSLog(@"liaoliao");
    
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

- (void)prepareToShowData {
    
    if (_isChatADScrollViewDataLoaded &&
        _isChatTopicDataLoaded &&
        _isChatUserDataLoaded &&
        _isChatLiaoLiaoDataLoaded)
    {
        [[AppConstants UpdatingPlistLock] lock];
        
        [PlistEditor alterPlist:@"AppInfo" alertValue:@"YES" forKey:@"isGotChatData"];
        [AppConstants writeDic2File];
        
        [[AppConstants UpdatingPlistLock] unlock];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initViews];
        });
    }
}

- (void)initViews {
    if (_isDataShow) {
        while ([[_verticalScrollViewContainer subviews] count] > 5) {
            NSArray *views = [_verticalScrollViewContainer subviews];
            for(UIView *view in views)
            {
                [view removeFromSuperview];
            }
        }
    }
    
    [self initAdScrollView];
    [self initButtonsContainer];
    [self initTopicContainer];
    [self initUserContainer];
    [self initPostContainer];
    [self.view setNeedsUpdateConstraints];
    [_getDataFailButton removeFromSuperview];
    [ProgressHUD dismiss];
    
    /*
    if (!_isDataShow) {
        NSLog(@"add contentOffset");
        [_verticalScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    */
    _isDataShow = YES;
    
    NSLog(@"views count = %lu", (unsigned long)[[_verticalScrollViewContainer subviews] count]);
    
    if ([[_verticalScrollViewContainer subviews] count] > 5) {
        [self initViews];
    }
    
    NSLog(@"here");
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
    
    NSLog(@"_adScrollView done");
}

- (void)initButtonsContainer {
    if (_isDataShow) {
        NSArray *views = [_buttonContainer subviews];
        for(UIView *view in views)
        {
            [view removeFromSuperview];
        }
    }
    
    [_buttonContainer removeFromSuperview];
    
    _buttonContainer = [[UIView alloc] init];
    _buttonContainer.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_buttonContainer];
    
    [_buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_adScrollView.mas_bottom).with.offset(5);
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.height.equalTo(@50);
    }];
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = [UIColor lightGrayColor];
    
    [_buttonContainer addSubview:sepView];
    
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.top.equalTo(_buttonContainer).with.offset(10);
        make.bottom.equalTo(_buttonContainer).with.offset(-10);
        make.centerX.equalTo(_buttonContainer);
    }];
    
    UIButton *activityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [activityButton setTitle:NSLocalizedString(@"remenhuodong", @"") forState:UIControlStateNormal];
    [activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIImage *activityButtonImage = [UIImage imageNamed:@"liaohuo.png"];
    UIImage *activityButtonPressImage = [UIImage imageNamed:@"liaohuoPress.png"];
    [activityButton setImage:[self scaleToSize:activityButtonImage size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    [activityButton setImage:[self scaleToSize:activityButtonPressImage size:CGSizeMake(25, 25)] forState:UIControlStateHighlighted];
    
    [activityButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
//    UIEdgeInsetsMa
    
    [activityButton addTarget:self action:@selector(activityPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttonContainer addSubview:activityButton];
    
    [activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonContainer);
        make.top.equalTo(_buttonContainer);
        make.height.equalTo(_buttonContainer);
        make.width.mas_equalTo([AppConstants uiScreenWidth] / 2);
    }];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [postButton setTitle:NSLocalizedString(@"zuihuotiezi", @"") forState:UIControlStateNormal];
    [postButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIImage *postButtonImage = [UIImage imageNamed:@"liaolike.png"];
    UIImage *postButtonPressImage = [UIImage imageNamed:@"liaolikePress.png"];
    [postButton setImage:[self scaleToSize:postButtonImage size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    [postButton setImage:[self scaleToSize:postButtonPressImage size:CGSizeMake(25, 25)] forState:UIControlStateHighlighted];
    
    [postButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    [postButton addTarget:self action:@selector(postPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttonContainer addSubview:postButton];
    
    [postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([AppConstants uiScreenWidth] / 2);
        make.top.equalTo(_buttonContainer);
        make.height.equalTo(_buttonContainer);
        make.right.mas_equalTo(_buttonContainer);
    }];
    
    NSLog(@"ButtonsContainer done");
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)activityPressed {
    _chatActivityViewController = [[ChatActivityViewController alloc] init];
    
    _chatActivityViewController.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:_chatActivityViewController animated:YES];
}

- (void)postPressed {
    _chatHotPostViewController = [[ChatHotPostViewController alloc] init];
    
    _chatHotPostViewController.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:_chatHotPostViewController animated:YES];
}

- (void)initTopicContainer {
    
    _topicContainer.backgroundColor = [UIColor clearColor];
    
    [_topicContainer removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_topicContainer];
    
    [_topicContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_buttonContainer.mas_bottom).with.offset(5);
    }];
    
    NSLog(@"TopicContainer done");
}

- (void)initUserContainer {
    
    [_userCollectionContainer removeFromSuperview];
    
    _userCollectionContainer.backgroundColor = [UIColor whiteColor];
    _userCollectionContainer.delegate = self;
    
    [_verticalScrollViewContainer addSubview:_userCollectionContainer];
    
    [_userCollectionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topicContainer.mas_bottom).with.offset(5);
        make.left.and.right.equalTo(_verticalScrollViewContainer);
    }];
    
    NSLog(@"UserContainer done");
}

- (void)initPostContainer {
    _postContainer.backgroundColor = [UIColor whiteColor];
    
    [_postContainer removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_postContainer];
    
    [_postContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userCollectionContainer.mas_bottom).with.offset(5);
        make.left.and.right.equalTo(_verticalScrollViewContainer);
    }];
    
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_postContainer);
    }];
    
    NSLog(@"PostContainer done");
}

- (void)updateLocalFileChatLiaoLiaoDataWithData:(ChatLiaoLiaoPostDataModel *)data atIndex:(NSInteger)index {
    
    [_ChatLiaoLiaoDataDics removeAllObjects];
    
    NSData *localFiledata = [AppConstants loadDataWithKey:[AppConstants localFileChatLiaoLiaoData]];
    ChatLiaoLiaoPostDatas *info = [ChatLiaoLiaoPostDatas modelWithJSON:localFiledata];
    
    for (int i = 0; i < [info.datas count]; i++) {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:[info.datas objectAtIndex:i]];
        
        [_ChatLiaoLiaoDataDics addObject:mutableDic];
    }
    
//    [_ChatLiaoLiaoDataDics addObjectsFromArray:info.datas];
    [[_ChatLiaoLiaoDataDics objectAtIndex:index] setObject:data.liked forKey:@"isThumbsup"];
    [[_ChatLiaoLiaoDataDics objectAtIndex:index] setObject:data.thumbsupDegree forKey:@"thumbsup_degree"];

    [AppConstants saveDicWithKey:[AppConstants localFileChatLiaoLiaoData] andArray:_ChatLiaoLiaoDataDics];
}

#pragma mark - LocalImageViewControllerDelegate delegate
- (void)getSelectImage:(NSArray *)imageArr
{
    NSLog(@"again?");
    
    _isPush = YES;
    _selectedImages = imageArr;
    
    _localImageViewController.delegate = nil;
}

#pragma mark - PostDetailViewDelegate delegate
- (void)postDetailViewChangeWithData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index {
    if (index <= 9) {
        [self updateLocalFileChatLiaoLiaoDataWithData:data atIndex:index];
    }
    
    [_postContainer changeWithData:data atIndex:index];
}

#pragma mark - postContainer delegate
- (void)postContainerClickAtData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index {

    ChatPostDetailViewController *chatPostDetailViewController = [[ChatPostDetailViewController alloc] initWithData:data andIndex:index];
    
    chatPostDetailViewController.hidesBottomBarWhenPushed = YES;
    chatPostDetailViewController.delegate = self;
    
    [self.navigationController pushViewController:chatPostDetailViewController animated:YES];
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

#pragma mark - ChatCollectionContainerDelegate

- (void)chatCollectionContainerClickByUserID:(NSString*)userid andUserAvatar:(NSString*)Avatar andUsername:(NSString*)username {
    NSLog(@"userid = %@", userid);

    ChatQueryUserViewController *chatQueryUserViewController = [[ChatQueryUserViewController alloc] initWithUserid:userid andUserAvatar:Avatar andUsername:username];
    
    chatQueryUserViewController.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:chatQueryUserViewController animated:YES];
}

#pragma mark - introduceContainer delegate
- (void)introduceContainerClickAtData:(NSObject *)data {
    ChatTopicViewController *chatTopicViewController = [[ChatTopicViewController alloc] initWithData:(ChatTopicDataModel*)data];
    
    chatTopicViewController.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:chatTopicViewController animated:YES];
    
    chatTopicViewController = nil;
}

#pragma mark - AdScrollView delegate
- (void)AdScrollViewClicked {
    int current = _adScrollView.contentOffset.x/[AppConstants uiScreenWidth];
    
    NSLog(@"current = %d", current);
    
    ChatADViewController *chatADViewController = [[ChatADViewController alloc] initWithData:[_ChatADDatas objectAtIndex:current]];
    
    chatADViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:chatADViewController animated:YES];
    
    chatADViewController = nil;
}

#pragma mark - Refresh delegate
- (void)viewWillRefresh {
    NSLog(@"viewWillRefresh");

    _verticalScrollView.userInteractionEnabled = NO;
}

- (void)viewDidRefresh {
    NSLog(@"viewDidRefresh");
    
    _verticalScrollView.userInteractionEnabled = YES;
}
/*
-(void)dealloc{
    [_verticalScrollView removeObserver:self forKeyPath:@"contentOffset"];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
