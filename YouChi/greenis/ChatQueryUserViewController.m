//
//  ChatQueryUserViewController.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/16.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "ChatQueryUserViewController.h"

#import "ProgressHUD.h"
#import "Masonry.h"
#import "SDRefresh.h"
#import "AppConstants.h"
#import "FileOperator.h"

#import "UIImageView+YYWebImage.h"
#import "PostContainer.h"
#import "PostPhotoBrowserViewController.h"
#import "ChatPostDetailViewController.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@interface ChatQueryUserViewController () <RefreshDelegate, PostContainerDelegate, PostDetailViewDelegate>

@property (strong, nonatomic) NSString                              *userid;
@property (strong, nonatomic) NSString                              *avatar;
@property (strong, nonatomic) NSString                              *username;

@property (strong, nonatomic) UIButton                              *getDataFailButton;
@property (strong, nonatomic) UIScrollView                          *verticalScrollView;
@property (strong, nonatomic) UIView                                *verticalScrollViewContainer;
@property (strong, nonatomic) UIView                                *headerView;
@property (strong, nonatomic) PostContainer                         *postContainer;

@property (nonatomic) BOOL                                          isDataShow;
@property (nonatomic) BOOL                                          isChatQueryUserDataLoaded;

@property (nonatomic) NSInteger                                     currentPage;

@property (strong, nonatomic) NSMutableArray                        *ChatLiaoLiaoDataDics;
@property (strong, nonatomic) NSMutableArray                        *ChatLiaoLiaoDatas;

@end

@implementation ChatQueryUserViewController

- (instancetype)initWithUserid:(NSString*)userid andUserAvatar:(NSString*)avatar andUsername:(NSString*)username {
    self = [super init];
    if (self) {
        _userid = userid;
        _avatar = avatar;
        _username = username;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPage = 1;
    
    [self initNavigationBar];
    [self initVerticalScrollView];
//    [self setupRefreshHeader];
    [self initStatus];
    
    [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    
    [self getChatLiaoLiaoDataFromServerWithPage:_currentPage];
}

- (void)getChatLiaoLiaoDataFromServerWithPage:(NSInteger)page {/*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/post/list/byuserid/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"AccessToken":[AppConstants userInfo].accessToken, @"UserId":_userid, @"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              NSLog(@"success urlString = %@", urlString);
              NSLog(@"Success: %@", responseObject);
              
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
                  
                  [self setData];
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

- (void)setData {
    _postContainer = [[PostContainer alloc] initWithDatas:_ChatLiaoLiaoDatas andPostType:PostQueryByUserid];
    
    _postContainer.delegate = self;
    
    _isChatQueryUserDataLoaded = YES;
    
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

- (void)initNavigationBar {
    self.navigationItem.title = _username;
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
        [_postContainer loadMoreWithPage:_currentPage + 1 andID:_userid];
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
    _currentPage = 1;
    
    if (!_isDataShow) {
        [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    }
    
    [self getChatLiaoLiaoDataFromServerWithPage:_currentPage];
}

- (void)initStatus {
    _isDataShow = NO;
}

- (void)prepareToShowData {
    if (_isChatQueryUserDataLoaded) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initViews];
        });
    }
}

- (void)initViews {
    [self initHeaderView];
    [self initPostContainer];
    
    if ([_ChatLiaoLiaoDatas count] >= 3) {
        [self setupFooter];
    }
    
    _isDataShow = YES;
    
    [_getDataFailButton removeFromSuperview];
    
    [ProgressHUD dismiss];
}

- (void)initHeaderView {
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [_verticalScrollViewContainer addSubview:_headerView];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verticalScrollViewContainer).with.offset(5);
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.height.mas_equalTo([AppConstants uiScreenHeight] / 4 + 10);
    }];
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    
    if ([_avatar hasPrefix:@"http:"]) {
        [userImageView setImageWithURL:[NSURL URLWithString:_avatar] placeholder:[UIImage imageNamed:@"placeholder.png"]];
    }
    else {
        [userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], _avatar]] placeholder:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    [_headerView addSubview:userImageView];
    
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.cornerRadius = ([AppConstants uiScreenHeight] / 4 - 25) / 2;
    
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView).with.offset(5);
        make.centerX.equalTo(_headerView);
        make.bottom.equalTo(_headerView).with.offset(-30);
        make.width.equalTo(userImageView.mas_height);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _username;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor blackColor];
    
    [_headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userImageView.mas_bottom).with.offset(5);
        make.centerX.equalTo(userImageView);
    }];
}

- (void)initPostContainer {
    NSLog(@"initPostContainer");
    
    _postContainer.backgroundColor = [UIColor whiteColor];
    
    [_postContainer removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_postContainer];
    
    [_postContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom).with.offset(5);
        make.left.and.right.equalTo(_verticalScrollViewContainer);
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
- (void)postContainerClickAtData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index{
    ChatPostDetailViewController *chatPostDetailViewController = [[ChatPostDetailViewController alloc] initWithData:data andIndex:index];
    
    chatPostDetailViewController.delegate = self;
    
    [self.navigationController pushViewController:chatPostDetailViewController animated:YES];
}

- (void)postContainerLikeByPostid:(NSString*)postid {
    
}

- (void)postContainerHeadImageViewClickByUserid:(NSString*)userid andUsername:(NSString*)username andUserAvatar:(NSString*)Avatar {
    NSLog(@"userid = %@", userid);
    /*
    ChatQueryUserViewController *chatQueryUserViewController = [[ChatQueryUserViewController alloc] initWithUserid:userid andUserAvatar:Avatar andUsername:username];
    
    chatQueryUserViewController.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:chatQueryUserViewController animated:YES];*/
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

@end
