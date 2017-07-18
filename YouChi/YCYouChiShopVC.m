//
//  YCYouChiShopVC.m
//  YouChi
//
//  Created by 李李善 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouChiShopVC.h"
@interface YCYouChiShopVCP ()

PROPERTY_STRONG_VM(YCYouChiShopVM);
@end

@implementation YCYouChiShopVCP
SYNTHESIZE_VM;

- (void)viewDidLoad
{
    WSELF;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //WSELF;
    self.title = @"友吃商城";
    
    #pragma mark - 推送消息
    [RACObserve(PUSH_MANAGER, hasNewMessage) subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [self.btnMessage showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeShake];
        } else {
            [self.btnMessage clearBadge];
        }
    }];
    
    #pragma mark - 弹窗
    [self executeSignal:self.viewModel.popWindowSignal next:^(NSArray<YCYouChiShopPopM *> *next) {
        if (next.count) {
            SSELF;
            YCYouChiShopPopVC *popVC = [[YCYouChiShopPopVC alloc]initWithFromVC:self pages:next];
            [popVC popFromVC:APP.window.rootViewController];
        }
    } error:self.errorBlock completed:nil executing:nil];
}

#pragma mark - 消息
- (IBAction)onPuMessage:(id)sender {    
    if ([self pushToLoginVCIfNotLogin]) {
        return;
    }
    
    
    [YCPushManager sharedPushManager].hasNewMessage = NO;
    
    
    [self pushTo:[YCMessageVC class]];
}

#pragma mark - 二维码
- (IBAction)onQCode:(UIBarButtonItem *)sender {
    
    YCErweimaVC *vc = [YCErweimaVC vcClass];
    [self pushToVC:vc];
}

#pragma mark - 我的菜单
- (void)onMyCart
{
    [self pushTo:[YCMyCartVC class]];
}
-(id)onCreateViewModel
{
    return [YCYouChiShopVM new];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    YCYouChiShopVC *vc = segue.destinationViewController;
    
    
    @weakify(vc);
    NSArray *titles = @[@"悬浮搜索",@"购物车",@"分类",@"悬浮电话",@"形状-1"];
    [self.floatBar setButtonImages:titles];
    self.floatBar.containerControlType = YCContainerControlTypeVertical;
    
    
    [self.floatBar.elements enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.imageView.shadowColor = [UIColor lightGrayColor];
        obj.imageView.shadowOffset = CGSizeMake(10, 10);
    }];
    
    UIButton *cart = self.floatBar.elements[1];
    [cart addTarget:self action:@selector(onMyCart) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *search = self.floatBar.elements.firstObject;
    UIButton *catolog = self.floatBar.elements[2];
    UIButton *phone = self.floatBar.elements[3];
    UIButton *goTop = self.floatBar.elements[4];
    
    goTop.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeRotation(M_PI));
    
    
    [search addTarget:vc action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
    [catolog addTarget:vc action:@selector(onCatolog:) forControlEvents:UIControlEventTouchUpInside];
    [phone addTarget:vc action:@selector(onPhone:) forControlEvents:UIControlEventTouchUpInside];
    [goTop addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(vc);
        [vc.tableView scrollToTopAnimated:YES];
    }];
    
    JSBadgeView *badge = [[JSBadgeView alloc]initWithParentView:cart alignment:JSBadgeViewAlignmentTopRight];
    badge.badgeBackgroundColor = [UIColor redColor];
    badge.transform = CGAffineTransformMakeScale(0.5, 0.5);
    badge.badgePositionAdjustment = CGPointMake(-10, 10);
    
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCAddCartItemNotification object:nil]merge:self.viewModel.getMyCartList ].deliverOnMainThread subscribeNext:^(id x) {
        dispatch_async_on_main_queue(^{
            badge.badgeText = @" ";
        });
    }];
    
    
    [cart addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton  *_Nonnull sender) {
        badge.badgeText = @"";
    }];
}
@end

@interface YCYouChiShopVC ()

{
    UIButton *_couponButton;
    
}
@property(nonatomic,assign) BOOL isLoading;
@property(nonatomic,strong)YCYouChiShopVM *viewModel;
@end

@implementation YCYouChiShopVC
@synthesize viewModel;

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self onClearMySpot];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"友吃商城";
    
    //[self _monitor];
    
    [self adjustContentIn:self.tableView];
    
    [self onUpdateSpot];
    
    /// 后台返回前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateSpot) name:YCBecomeActive object:nil];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)_monitor
{
#if DEBUG && TARGET_OS_IPHONE
    [KMCGeigerCounter sharedGeigerCounter].enabled = YES;
#endif
}


- (void)onUpdateSpot{
    /// 显示
    [self executeSignal:self.viewModel.lastCouponCreat next:nil error:self.errorBlock completed:^{
        
        YCCache *cache =  [YCCache sharedCache];
        NSNumber *orderStatueSave = [cache.dataBase objectForKey:YCOrderStatueSave];
        NSNumber *couponStatueSave = [cache.dataBase objectForKey:YCCouponStatueSave];
        
        if (couponStatueSave.intValue == 1) {
            [self onShowSpot];
        }
        if (couponStatueSave.intValue == 1 ||orderStatueSave.intValue == 1) {
            /// 有新消息时，我的红点
            RDVTabBarController *tbc = self.rdv_tabBarController;
            UIControl *item = tbc.tabBar.items[4];
            item.badgeBgColor = KBGCColor(@"f24148");
            [item showBadge];
            item.badge.frame = CGRectMake(SCREEN_WIDTH/5 - 25, 3, 8, 8);
        }
    } executing:self.executingBlock];
    
}


#pragma mark --隐藏优惠劵红点
- (void)onClearBadge{
    
    [_couponButton clearBadge];
}
#pragma mark --显示优惠劵红点
- (void)onShowSpot{
    
    _couponButton.badgeBgColor = KBGCColor(@"f24148");
    [_couponButton showBadge];
    _couponButton.badge.frame = CGRectMake(SCREEN_WIDTH/4 - 27, -2, 8, 8);
}
#pragma mark --隐藏我的红点
- (void)onClearMySpot{
    
    YCCache *cache =  [YCCache sharedCache];
    
    NSNumber *orderStatueSave = [cache.dataBase objectForKey:YCOrderStatueSave];
    NSNumber *couponStatueSave = [cache.dataBase objectForKey:YCCouponStatueSave];
    
    RDVTabBarController *tbc = self.rdv_tabBarController;
    UIControl *item = tbc.tabBar.items[4];
    
    if (couponStatueSave.intValue == 0&&orderStatueSave.intValue == 0) {
        
        [item clearBadge];
    }
    
    if (couponStatueSave.intValue == 0) {
        
        [self onClearBadge];
    }else if (couponStatueSave.intValue == 1){
        
        [self performSelector:@selector(onShowSpot) withObject:nil afterDelay:1];
    }
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    self.isLoading = YES;
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:^{
        self.isLoading = NO;
    } executing:self.executingBlock];
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    
    #pragma mark --搜索
    if (reuseIdentifier == cell7) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom]addInSuperView:view];
            
            [b addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [b setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xe4e4e4 andAlpha:1]] forState:UIControlStateNormal];
                b.cornerRadius = 10/2;
                b.masksToBounds = YES;
                [b setImage:IMAGE(@"首页-搜索") forState:UIControlStateNormal];
                [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                b.titleLabel.font = KFont(12);
                [b setTitle:@"搜索你想要的" forState:UIControlStateNormal];
                [b setTitleColor:[UIColor colorWithHex:0x363636 andAlpha:0.3] forState:UIControlStateNormal];
                
                b.imageView.tintColor = [UIColor colorWithHex:0x363636 andAlpha:0.3];
                UIEdgeInsets edge = UIEdgeInsetsMake(10, 8, 10, 8);
                [b mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view).insets(edge);
                }];
            }];
            
        }];
        
    }
    
    #pragma mark --广告
    else if (reuseIdentifier == cell8) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            YCImagePlayerView *ipv = [YCImagePlayerView newInSuperView:view];
            [ipv yc_initView];
            WSELF;
            [ipv setDidTapBlock:^(NSNumber *next) {
                SSELF;
                
                YCYouChiShopM *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
                if (!m) {
                    return ;
                }
                YCAdListM *al = m.adList[next.integerValue];
                if (!al.originalAction) {
                    return;
                }
                if (al.originalType.intValue == 1) {
                    YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:al.originalAction];
                    [self pushTo:[YCItemDetailVC class] viewModel:vm];
                    [MobClick event:shopHome_banner_click attributes:@{@"itemId":al.originalAction,}];
                } else {
                    YCWebVM *vm = [[YCWebVM alloc]initWithUrl:al.originalAction];
                    vm.title = al.title;
                    
                    [self pushTo:[YCWebVC class] viewModel:vm];
                    [MobClick event:shopHome_banner_click attributes:@{@"itemUrl":al.originalAction}];
                }
                
            }];
            
            [ipv setShopUpdateBlock];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCYouChiShopM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                ipv.dataSource = m.adList;
                ipv.autoScroll = ipv.shouldAutoScrollWhenScroll = m.adList.count>0;
                [ipv reloadImageData];
                
            }];
            
            
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                ipv.frame = frame;
            }];
        }];
        
        
    }
    
    #pragma mark --四个按钮 ＋ 实时余额
    else if (reuseIdentifier == cell9) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSString *reuseIdentifier) {
            
            WSELF;
        
            YCContainerControl *container = [[[YCContainerControl alloc]initWithElementCount:4 block:^UIView *(NSInteger idx) {
                YCCenterButton *btn = [YCCenterButton buttonWithType:UIButtonTypeCustom];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.imageView.clipsToBounds = YES;
                
                btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                if (idx == 3) {
                
                    _couponButton = btn;
                    
                    YCCache *cache =  [YCCache sharedCache];
                    
                    NSNumber *couponStatueSave = [cache.dataBase objectForKey:YCCouponStatueSave];
                    
                    if (couponStatueSave.intValue == 1) {
                        
                        [self performSelector:@selector(onShowSpot) withObject:nil afterDelay:2];
                    }
                }
                
                [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * _Nonnull sender) {
                    
                    SSELF;
                    NSIndexPath *idp = [self indexPathForCell:sender.findTableViewCell];
                    YCYouChiShopM *m = [self.viewModel modelForItemAtIndexPath:idp];
                    YCChannelList *list = m.channelList[idx];
                    YCChannelIdType channelId = list.channelId.intValue;

                    UIViewController *vc = nil;
                    
                    if (channelId == YCChannelIdTypeGroupPurchase ) {    // 团拼
                        vc = [YCGroupPurchaseVCP vcClass];
                    }

                    if (channelId == YCChannelIdTypeAllItem) {    // 全部商品  即将添加
                        
                        vc = [YCShopCategoryNameVC vcClass];
                        YCShopCategoryNameVM *vm = [YCShopCategoryNameVM new];
                        vm.requsetType = selsectRequsetTypeShop;
                        vm.title = @"全部商品";
                        vc.viewModel = vm;
                        
                    }

                    if (channelId == YCChannelIdTypeMoneyCard) {          // 充值卡
                        vc = [YCMyMoneyVC vcClass];
                    }
                    
                    if (channelId == YCChannelIdTypeItemCatolog) {   // 商品分类
                        vc = [YCShopCategoryVC vcClass];
                        
                    }

                    if (channelId == YCChannelIdTypeMiExchange) {   // 友米兑换
                        vc = [YCYouMiExchangeVC vcClass];
                        
                    }

                    if (channelId == YCChannelIdTypeCoupon) {   // 优惠劵
                        vc = [YCMyCouponVC vcClass];
                    }

                    if (vc) {
                        vc.title = list.channelName;
                        [self pushToVC:vc];
                    }
                    
                    if (list.channelId) {
                        NSDictionary *attr = @{@"channelId":@(channelId).stringValue,@"channelName":list.channelName};
                        [MobClick event:shopHome_banner_click attributes:attr];
                    }
                    
                }];
                 
                
                return btn;
            }] addInSuperView:view];
            
            container.edge = UIEdgeInsetsMake(15, 10, 10, 10);
            container.gap =  20;
            
            NSArray *btns = container.elements;
            
            YYLabel *news = [YYLabel newInSuperView:view];
            news.numberOfLines = 0;
            
            UIButton *close = [UIButton newInSuperView:news];
            close.size = CGSizeMake(60, 60);
            [close addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                SSELF;
                [self.tableView updateWithBlock:^(UITableView * _Nonnull tableView) {
                    self.viewModel.newsTextLayout = nil;
                }];
                news.hidden = YES;
                
            }];
            
            [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCYouChiShopNewsTapNotification object:nil]subscribeNext:^(NSNotification *x) {
                SSELF;
                YCYouChiShopM *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
                if (m.shopFunds.explainUrl) {
                    YCWebVC *vc = [[YCWebVC alloc]initWithUrlString:m.shopFunds.explainUrl];
                    [self pushToVC:vc];
                }
            }];
            
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
                [close setNormalImage:IMAGE(@"清除历史")];
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCYouChiShopM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                
                [btns enumerateObjectsUsingBlock:^(UIButton *_Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
                    YCChannelList  *cl = m.channelList[idx];
                    [btn setImageWithURL:IMAGE_HOST_SHOP(cl.channelImagePath) forState:UIControlStateNormal options:YYWebImageOptionSetImageWithFadeAnimation];
                    [btn setTitle:cl.channelName forState:UIControlStateNormal];
                }];

                news.hidden = NO;
                news.textLayout = self.viewModel.newsTextLayout;
            }];
            
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                if (!self.viewModel.newsTextLayout) {
                    container.frame = frame;
                } else {
                    container.frame = news.frame = frame;
                    news.height = news.textLayout.textBoundingSize.height;
                    container.height =  frame.size.height - news.height;
                    news.top = container.bottom;
                    
                    //close.top = news.top;
                    close.right = frame.size.width;
                }
                
                
                
            }];
        }];
    }
    
    
    #pragma mark --图片
    else  {
        NSInteger count = [reuseIdentifier substringFromIndex:1].integerValue;
        cell.backgroundColor = cell.contentView.backgroundColor = self.tableView.backgroundColor;
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSString *reuseIdentifier) {
            
            WSELF;
            NSMutableArray *imageViews = [NSMutableArray new];
            for (int n = 0; n<count; n++) {
                UIImageView *iv = [UIImageView newInSuperView:view];
                iv.contentMode = UIViewContentModeScaleAspectFill;
                iv.clipsToBounds = YES;
                iv.backgroundColor = [UIColor clearColor];
                [imageViews addObject:iv];
                
                iv.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
                [iv addGestureRecognizer:tap];
                
                [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer *x) {
                    SSELF;
                    NSInteger idx = [imageViews indexOfObject:x.view];
                    NSIndexPath *idp = [self indexPathForCell:cell];
                    YCYouChiShopM *m =[self.viewModel modelForItemAtIndexPath:idp];
                    YCShopRecommendSubitems *srs = m.shopRecommendSubitems[idx];
                    
                    NSString *action = srs.originalAction;
                    if (!action) {
                        return ;
                    }
                    YCShopOriginalType type = srs.originalType.intValue ;
                    if (type == YCShopOriginalTypeUrl) {
                        YCWebVM *vm = [[YCWebVM alloc]initWithUrl:action];
                        [self pushTo:[YCWebVC class] viewModel:vm];
                        
                    }
                    
                    if (type == YCShopOriginalTypeItem) {
                        YCItemDetailVC *vc = [YCItemDetailVC vcClass];
                        YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:action];
                        vc.viewModel = vm;
                        [self pushToVC:vc];
                        
                    }
                    
                    if (type == YCShopOriginalTypeSearch) {
                        YCSearchVC *vc = [YCSearchVC vcClass];
                        vc.searchType = isSearchTypeShop;
                        [self pushToVC:vc];
                        
                    }
                    
                    if (type == YCShopOriginalTypeCatolog) {
                        YCShopCategoryNameVM *vmm = [YCShopCategoryNameVM new];
                        vmm.Id = @(action.intValue);
                        vmm.requsetType = selsectRequsetTypeSub;
                        
                        YCShopCategoryNameVC *vc = [YCShopCategoryNameVC vcClass];
                        [self pushToVC:vc viewModel:vmm];
                    }
                    
                    [MobClick event:shopHome_item_click attributes:@{@"type":@(type).stringValue,@"originalAction":action}];
                    
                }];
                
                
            }
            
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCYouChiShopM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if (![cell checkIsHasSetData:m]) {
                    [imageViews enumerateObjectsUsingBlock:^(UIImageView *_Nonnull iv, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        YCShopRecommendSubitems *srs = m.shopRecommendSubitems[idx];
                        
                        [iv yc_setImageWithURL:IMAGE_HOST_SHOP(srs.recommendSubitemImagePath) placeholder:[UIImage imageNamed:@"loading中"]];

                    }];
                }
                
                
            }];
            
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(1, 0, 1, 0));
                if (count == 4) {
                    SSELF;
                    NSIndexPath *indexPath = [self indexPathForCell:cell];
                    if (!indexPath) {
                        return ;
                    }
                    YCYouChiShopM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                    YCShopRecommendSubitems *srs0 = m.shopRecommendSubitems.firstObject;
                    YCShopRecommendSubitems *srs1 = m.shopRecommendSubitems[1];
                    YCShopRecommendSubitems *srs3 = m.shopRecommendSubitems.lastObject;
                    float sum = srs1.width+srs3.width;
                    float w = DAMAI_RATIO_2(SCREEN_WIDTH, sum, srs3.width);
                    UIView *v1 = imageViews[0],*v2 = imageViews[1],*v3 = imageViews[2],*v4 = imageViews[3];
                    
                    v1.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, 0,CGRectGetHeight(frame) - DAMAI_RATIO_2(SCREEN_WIDTH, srs0.width, srs0.height), 0));
                    
                    CGRect bottom = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(v1.frame.size.height, 0, 0, 0));
                    
                    CGRect leftBottom  = UIEdgeInsetsInsetRect(bottom, UIEdgeInsetsMake(0, 0, 0, w));
                    [@[v2,v3] layoutByType:YCContainerControlTypeVertical edge:UIEdgeInsetsMake(0, 0, 0, 0) gap:0 inFrame:leftBottom];
                    
                    v4.frame = UIEdgeInsetsInsetRect(bottom, UIEdgeInsetsMake(0, leftBottom.size.width, 0, 0));
                } else {
                    [imageViews layoutByType:YCContainerControlTypeHorizion edge:UIEdgeInsetsMake(0, 0, 0, 0) gap:0 inFrame:frame];
                }
            }];
        }];
        
    }
    
}

#pragma mark - 搜索
- (void)onSearch:(UIButton *)sender
{
    YCSearchVC *vc = [YCSearchVC vcClass];
    ///根据什么不同的类型跳转不同的二级界面
    vc.searchType = isSearchTypeShop;
    [self pushToVC:vc];
}

#pragma mark - 分类
- (void)onCatolog:(UIButton *)sender
{
     // 商品分类
    [self pushTo:[YCShopCategoryVC class]];
}

#pragma mark - 打客服电话
-(void)onPhone:(UIButton *)sender{
    [ACETelPrompt callPhoneNumber:CustomerService call:^(NSTimeInterval duration) {
        
    } cancel:^{
        ;
    }];
}

- (void)onSetupRefreshControl
{
    [super onSetupRefreshControl];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
    
}

- (void)onInsertItemsIntoBack:(NSInteger)itemCount
{
    [self onInsertSectionsIntoBack:itemCount];
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


@implementation YCYouChiShopPopVC
- (instancetype)initWithFromVC:(UIViewController *)fromVC pages:(NSArray<YCYouChiShopPopM *> *)pages
{
    _fromVC = fromVC;
    _pages = pages;
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WSELF;
    self.yc_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    YCPhotosView *pv = [[[YCPhotosView alloc]initWithFrame:CGRectZero collectionViewLayout:layout]addInSuperView:self.yc_view];
    
    [pv setSizeBlock:^CGSize(CGSize size) {
        return size;
    }];
    [pv setUpdateBlock:^(UICollectionViewCell *cell, YCYouChiShopPopM *model) {
        [cell.contentView ycShop_setImageWithURL:model.cpmImage placeholder:nil];
        [cell.contentView setCornerRadius:2];
        [cell.contentView setBorderColor:[UIColor whiteColor]];
        [cell.contentView setBorderWidth:2];
    }];
    [pv setSelectBlock:^(NSIndexPath *indexPath, YCYouChiShopPopM *model) {
        SSELF;
        if (model.originalAction) {
            [self onDismiss];
            switch (model.originalType) {
                case YCPopOriginalTypeURL:{
                    YCWebVC *web = [[YCWebVC alloc]initWithUrlString:model.originalAction];
                    [self.fromVC pushToVC:web];
                }
                    break;
                case YCPopOriginalTypeItem:{
                    YCItemDetailVC *vc = [YCItemDetailVC vcClass];
                    YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:model.originalAction];
                    [self.fromVC pushToVC:vc viewModel:vm];
                }
                    break;
                case YCPopOriginalTypeCoupon:{
                    [self.fromVC pushToVC:[YCMyCouponVC vcClass]];
                }
                    break;
                default:
                    break;
            }
            
        }
        
    }];
    
    
    
    pv.photos = self.pages;
    [pv reloadData];
    
    UIPageControl *pc = [UIPageControl newInSuperView:self.yc_view];
    UIButton *close = [UIButton newInSuperView:self.yc_view];
    pc.hidesForSinglePage = YES;
    pc.numberOfPages = self.pages.count;
    
    [pv setPageBlock:^(NSIndexPath *indexPath, id model) {
        pc.currentPage = indexPath.row;
    }];
    
    [close setNormalImage:IMAGE(@"清除历史")];
    close.tintColor = color_btnGold;
    close.transform = CGAffineTransformMakeScale(2, 2);
    [close sizeToFit];
    [close addTarget:self action:@selector(onDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self.yc_view setLayoutBlock:^(YCView *__weak view, CGRect frame) {
        pv.frame = frame;
        pv.height = frame.size.height/2;
        pv.centerY = frame.size.height/2;
        
        pc.centerX = pv.centerX;
        pc.top = pv.bottom + 10;
        
        close.centerX = pc.centerX;
        close.top = pc.bottom + 10;
        
    }];
    
}

- (void)onDismiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)popFromVC:(UIViewController *)vc
{
    vc.definesPresentationContext = YES ;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }else{
        
        vc.modalPresentationStyle=UIModalPresentationCurrentContext;
        
    }
    [vc presentViewController:self animated:NO completion:nil];
}
@end
