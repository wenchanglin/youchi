//
//  ChatActivityViewController.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/10.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "ChatActivityViewController.h"
#import "AppConstants.h"
#import "Masonry.h"
#import "ProgressHUD.h"
#import "PlistEditor.h"
#import "SDRefresh.h"
#import "ChatActivityDataModel.h"
#import "IntroduceContainer.h"
#import "ChatActivityDetailViewController.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@interface ChatActivityViewController () <RefreshDelegate, IntroduceContainerDelegate>

@property (nonatomic) BOOL                                      isDataShow;
@property (strong, nonatomic) UIScrollView                      *verticalScrollView;
@property (strong, nonatomic) UIView                            *verticalScrollViewContainer;
@property (strong, nonatomic) IntroduceContainer                *activityContainer;

@property (nonatomic) BOOL                                      isChatActivityDataLoaded;

@property (nonatomic) NSInteger                                 currentPage;

@property (strong, nonatomic) NSMutableArray                    *ChatActivityDataDics;
@property (strong, nonatomic) NSMutableArray                    *ChatActivityDatas;

@end

@implementation ChatActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    _isDataShow = NO;
    _currentPage = 1;
    
    [self initNavigationBar];
    [self initVerticalScrollView];
//    [self setupRefreshHeader];
    [self initStatus];
    
    [ProgressHUD show:NSLocalizedString(@"loading", @"")];

    [self getActivityDataFromServer];
}

- (void)getActivityDataFromServer {/*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/query/topic/list/activity/list/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"page" :@"1", @"pageSize" : @"10"};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              //                    NSLog(@"success urlString = %@", urlString);
              //                    NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSArray *topics = [responseObject objectForKey:@"Topics"];
                  
                  _ChatActivityDataDics = [[NSMutableArray alloc] init];
                  [_ChatActivityDataDics addObjectsFromArray:topics];
                  
                  _ChatActivityDatas = [[NSMutableArray alloc] init];
                  
                  for (int i = 0; i < _ChatActivityDataDics.count; i++) {
                      ChatActivityDataModel *dataModel = [[ChatActivityDataModel alloc] init];
                      dataModel.addTime = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"add_time"];
                      dataModel.content = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"content"];
                      dataModel.forumPostTotal = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"forum_post_total"];
                      dataModel.hotDegree = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"hot_degree"];
                      dataModel.Id = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"id"];
                      dataModel.imageUrl = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"img_url"];
                      dataModel.name = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"name"];
                      
                      [_ChatActivityDatas addObject:dataModel];
                  }

                  [self setChatActivityViewData];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

- (void)initNavigationBar {
    self.navigationItem.title = NSLocalizedString(@"remenhuodong", @"");
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
        [_activityContainer loadMoreWithPage:_currentPage + 1 andID:@""];
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

- (void)initStatus {
    _isDataShow = NO;
}

- (void)setChatActivityViewData {

    _activityContainer = [[IntroduceContainer alloc] initWithDatas:_ChatActivityDatas andStyle:StyleActivity];

    _activityContainer.delegate = self;
    
    _isChatActivityDataLoaded = YES;
    
    [self prepareToShowData];
}

- (void)getDataFail {
    
}

- (void)reloadAllData {
    
}

- (void)prepareToShowData {
    
    if (_isChatActivityDataLoaded)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initViews];
        });
    }
}

- (void)initViews {
    [self initActivityContainer];
    
    if ([_ChatActivityDatas count] >= 8) {
        [self setupFooter];
    }
    
    [ProgressHUD dismiss];
}

- (void)initActivityContainer {
    _activityContainer.backgroundColor = [UIColor clearColor];
    
    [_activityContainer removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_activityContainer];
    
    [_activityContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(_verticalScrollViewContainer);
    }];
    
    if (_activityContainer.totalCount < 5) {
        [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([AppConstants uiScreenHeight] - [AppConstants uiNavigationBarHeight] + 1);
        }];
    }
    else {
        [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_activityContainer);
        }];
    }
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

#pragma mark - introduceContainer delegate
- (void)introduceContainerClickAtData:(NSObject *)data {
    ChatActivityDetailViewController *chatActivityDetailViewController = [[ChatActivityDetailViewController alloc] initWithData:(ChatActivityDataModel*)data];
    
    [self.navigationController pushViewController:chatActivityDetailViewController animated:YES];
    
    chatActivityDetailViewController = nil;
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
