//
//  YCPersonalProfileVC.m
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCGoodsCommentVC.h"
#import "YCMyCartVC.h"
#import "YCPersonalProfileVC.h"
#import "YCRecipientAddressVC.h"
#import "YCOrderJudgeVC.h"
#import <YQBadgeCategory/UIView+WZLBadge.h>
#import "YCSettingVC.h"
#import "YCFollowsVMAndFansVC.h"
#import "YCFollowsVM.h"

#import "YCMessageVC.h"
#import "YCMeMessageVC.h"
#import "YCRankView.h"
#import <Masonry/Masonry.h>
#import "YCPrivateBookingVC.h"
#import "YCAvatarControl.h"
#import "YCProfileView.h"
#import "YCPhotoBrowser.h"
#import "YCWebVC.h"
#import "YCSignInView.h"
#import "YCMyOrderVC.h"
#import "YCPhotoBrowser.h"
#import "YCWebVC.h"
#import "YCPushManager.h"
@interface YCPersonalProfileVCP ()<UITableViewDelegate>
{
    
    
}

/// 个人信息 等级 关注粉丝 view
@property (weak, nonatomic) IBOutlet UIView *SectionView;
@property (nonatomic,strong) YCProfileView *profile;
PROPERTY_STRONG_VM(YCPersonalProfileVM);
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;


@end

@implementation YCPersonalProfileVCP
@synthesize viewModel;

- (void)dealloc{
    // 不ok
}

#pragma mark - 生命周期
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    WSELF;
    
    self.title = @"我的主页";
    
    self.profile = ({
        YCProfileView *header = [YCProfileView viewByClass:[YCProfileView class]];
        UIView *view = self.SectionView;
        [view addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];

        header.profileButtonsView.profileButtonsCount = 4;
        NSArray *btns = header.profileButtonsView.profileButtons;
        [btns[0] addTarget:self action:@selector(onFollowAndFansClick:) forControlEvents:UIControlEventTouchUpInside];
        [btns[1] addTarget:self action:@selector(onFollowAndFansClick:) forControlEvents:UIControlEventTouchUpInside];

        [header.edit addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];


        header;
    });
    
    [RACObserve(self.viewModel,appUser).deliverOnMainThread subscribeNext:^(YCLoginUserM *user) {
        SSELF;
        
        NSString *userName = user.nickName?:@"未登录";
        NSString *userSign = user.signature?:@"用户签名...";
        
        
        [self.profile.infoAvatar updateAvatarControlWith:user.imagePath name:userName sign:userSign sex:user.sex];
        NSArray *btns = self.profile.profileButtonsView.profileButtons;
        [btns[0] setTitle:[[NSString alloc]initWithFormat:@"%d\n关注",user.followerCount.intValue] forState:UIControlStateNormal];
        [btns[1] setTitle:[[NSString alloc]initWithFormat:@"%d\n粉丝",user.fansCount.intValue] forState:UIControlStateNormal];
        [btns[2] setTitle:[[NSString alloc]initWithFormat:@"%d\n分享",user.shareCount.intValue] forState:UIControlStateNormal];
        [btns[3] setTitle:[[NSString alloc]initWithFormat:@"%d\n友米",user.antCoin.intValue] forState:UIControlStateNormal];


    
        self.profile.rank.desc.text = user.levelId?[[NSString alloc]initWithFormat:@" Level %d",user.levelId.intValue]:nil;
        
//        if (user) {
            [self.profile.infoAvatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
//        } else {
//            [self.profile.infoAvatar removeTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
//        }
    }];
    
    [RACObserve(PUSH_MANAGER, hasNewMessage) subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [self.btnMessage showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeShake];
        } else {
            [self.btnMessage clearBadge];
        }
    }];
}



- (id)onCreateViewModel{
    return [YCPersonalProfileVM new];
}

- (IBAction)onPuMessage:(id)sender {
    if ([self pushToLoginVCIfNotLogin]) {
        return;
    }
    [YCPushManager sharedPushManager].hasNewMessage = NO;
    [self.btnMessage clearBadge];
    
    [self pushTo:[YCMessageVC class]];
}

#pragma mark --tab的红点
- (void)hiddenTabbrSpot{
    
    UICKeyChainStore *kcs = [UICKeyChainStore keyChainStore];
    NSString *firstTimeOpenOrder = [kcs stringForKey:YCOrderStatueSave];
    NSString *firstTimeOpen = [kcs stringForKey:YCCouponStatueSave];
    
    
    if (firstTimeOpen.intValue == 0&&firstTimeOpenOrder.intValue == 0) {
        
        RDVTabBarController *tbc = self.rdv_tabBarController;
        
        UIControl *item = tbc.tabBar.items[4];
        
        [item clearBadge];
    }
}

#pragma mark --点击头像大图
- (void)onAvatar:(YCAvatarControl *)sender{
    
    if ([self pushToLoginVCIfNotLogin]) {
        return ;
    }
    
    YCBaseImageModel *m = [YCBaseImageModel new];
    m.imagePath = self.viewModel.appUser.imagePath;
    YCPhotoBrowser *browser = [[YCPhotoBrowser alloc]initWithPageModels:@[m] selectedIndex:0];
    [self pushToVC:browser];
}

#pragma mark - 个人编辑
- (IBAction)onEdit:(id)sender {
    
    if ([self pushToLoginVCIfNotLogin]) {
        return ;
    }
    
    [self pushTo:[YCMeMessageVC class]];
    

}
#pragma mark --设置
- (IBAction)onSheZhi:(UIButton *)sender {
    
    if ([self pushToLoginVCIfNotLogin]) {
        return ;
    }
    YCSettingVM *vm = [[YCSettingVM alloc]initWithViewModel:self.viewModel];
    [self pushTo:[YCSettingVC class] viewModel:vm hideTabBar:YES];
    
}


#pragma mark -- 关注，粉丝，分享 有米
- (void )onFollowAndFansClick:(UIButton *)sender {

    if ([self pushToLoginVCIfNotLogin]) {
        return ;
    }
    YCFollowsVMAndFansVC *attantionAndFansVC = [YCFollowsVMAndFansVC vcClass:[YCFollowsVMAndFansVC class]];
    NSInteger idx = [self.profile.profileButtonsView.profileButtons indexOfObject:sender];
    if (idx == 0){
        attantionAndFansVC.viewModel = [[YCFollowsVM alloc]initWithId:[YCUserDefault currentId]];

    }

    else if(idx == 1){
        attantionAndFansVC.viewModel = [[YCFansVM alloc]initWithId:[YCUserDefault currentId]];
    }
    
    [self.navigationController pushViewController:attantionAndFansVC animated:YES];


}

#pragma mark -
- (void)updateUM:(int)count
{
    NSArray *btns = self.profile.profileButtonsView.profileButtons;
    int sum = self.viewModel.appUser.antCoin.intValue + count;
    [YCUserDefault currentUser].appUser.antCoin = self.viewModel.appUser.antCoin = @(sum);
    [btns[3] setTitle:[[NSString alloc]initWithFormat:@"%d\n友米",sum] forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.viewModel = [segue.destinationViewController viewModel];
}

@end

#pragma mark -- 列表
@interface YCPersonalProfileVC ()
@property (nonatomic,strong) YCPersonalProfileVM *viewModel;
@end

@implementation YCPersonalProfileVC
@synthesize viewModel;

-(void)dealloc{
    //    ok
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self hiddenTabbrSpot];
    [self showOrderSpot];
    [self showCouponSpot];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = nil;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 50, 0);
    self.tableView.sectionFooterHeight  = 0;

}


#pragma mark --优惠劵显示
- (void)showCouponSpot{
    
    YCCache *cache =  [YCCache sharedCache];
    NSNumber *CouponStatueSave = [cache.dataBase objectForKey:YCCouponStatueSave];
    
    NSIndexPath *path=[NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    UIImageView *l = (id)[cell.contentView viewByTag:1002];
    
    if (CouponStatueSave.intValue == 1) {
        
        l.badgeBgColor = KBGCColor(@"f24148");
        [l showBadge];
        l.badge.frame = CGRectMake(78, -2, 7, 7);
        
    }else if (CouponStatueSave.intValue == 0){
        
        [l clearBadge];
    }
    
}
#pragma mark --订单是否显示红点
- (void)showOrderSpot{
    
    YCCache *cache =  [YCCache sharedCache];
    NSNumber *orderStatueSave = [cache.dataBase objectForKey:YCOrderStatueSave];
    
    NSIndexPath *path=[NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    UILabel *l = (id)[cell.contentView viewByTag:1002];
    
    if (orderStatueSave.intValue == 1) {
        
        l.badgeBgColor = KBGCColor(@"f24148");
        [l showBadge];
        l.badge.frame = CGRectMake(63, -2, 7, 7);
        
    }else if (orderStatueSave.intValue == 0){
        
        [l clearBadge];
    }
}

#pragma mark --tab的红点
- (void)hiddenTabbrSpot{
    
    YCCache *cache =  [YCCache sharedCache];
    
    NSNumber *orderStatueSave = [cache.dataBase objectForKey:YCOrderStatueSave];
    NSNumber *couponStatueSave = [cache.dataBase objectForKey:YCCouponStatueSave];
    
    RDVTabBarController *tbc = self.rdv_tabBarController;
    
    UIControl *item = tbc.tabBar.items[4];
    
    if (orderStatueSave.intValue == 0&&couponStatueSave.intValue == 0) {
        
        [item clearBadge];
        
    }else if (couponStatueSave.intValue == 1||orderStatueSave.intValue == 1){
    
        item.badgeBgColor = KBGCColor(@"f24148");
        [item showBadge];
        item.badge.frame = CGRectMake(SCREEN_WIDTH/5 - 25, 3, 8, 8);
    }
}

- (id)onCreateViewModel{
    return [YCPersonalProfileVM new];
}


#pragma mark -
- (void)onUpdateCell:(UITableViewCell *)cell model:(YCPersonalProfileM *)model atIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *iv = (id)[cell.contentView viewByTag:1];
    UILabel *l = (id)[cell.contentView viewByTag:1002];

    iv.image = [UIImage imageNamed:model.image];
    l.text = model.title;
    cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    
    
    if (indexPath.row == 1 ||indexPath.row == 2) {
        
        if (indexPath.row==1) {
            
            // 第一次显
            YCCache *cache =  [YCCache sharedCache];
            NSNumber *OrderStatueSave = [cache.dataBase objectForKey:YCOrderStatueSave];
            
            if (OrderStatueSave.intValue == 1) {
                
                l.badgeBgColor = KBGCColor(@"f24148");
                [l showBadge];
                l.badge.frame = CGRectMake(63, -2, 7, 7);
            }
            
        }else
            
            if (indexPath.row == 2) {
                
                YCCache *cache =  [YCCache sharedCache];
                NSNumber *CouponStatueSave = [cache.dataBase objectForKey:YCCouponStatueSave];;
                
                if (CouponStatueSave.intValue == 1) {
                    
                    l.badgeBgColor = KBGCColor(@"f24148");
                    [l showBadge];
                    l.badge.frame = CGRectMake(78, -2, 7, 7);
                }
            }
    }
    
    else{
        
        [l clearBadge];
    }
}


#pragma mark --选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self pushToLoginVCIfNotLogin]) {
        return ;
    }
    
    
    YCPersonalProfileM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    
    if ([m.title isEqualToString:@"签到"]) {
        [self executeSignal:self.viewModel.signalSignup next:^(NSNumber *next) {
            if ([next respondsToSelector:@selector(intValue)]) {
                [YCSignInView showSignInView:tableView action:@"签到" count:next.intValue];
                YCPersonalProfileVCP *vcp = (id)self.parentViewController;
                [vcp updateUM:next.intValue];
            }
        } error:self.errorBlock completed:nil executing:^(BOOL isExecuting) {
            if (isExecuting) {
                [SVProgressHUD show];
            } else {
                [SVProgressHUD dismiss];
            }
        }];
        return;
    }
    
    if (!m.pushClass) {
        return;
    }
    UIViewController *vc = [UIViewController vcClass:m.pushClass];
    
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc topViewController];
    }
    
    if (m.pushClass == [YCMyOrderVC class]) {
        vc.viewModel = [YCMyOrderVM new];
    }
    
    if ([vc isKindOfClass:[YCWebVC class]]) {
        
        if (indexPath.row == 7) {
            YCWebVM *vm = [YCWebVM new];
            vm.url = [NSString stringWithFormat:@"%@shop/kuaiyi/rule/index.html",host];
            vm.shareUrl = vm.url;
            vc.viewModel = vm;
        }
        
        else if (indexPath.row == 9) {
            YCWebVM *vm = [YCWebVM new];
            vm.url = [NSString stringWithFormat:@"%@shop/youmi/inviteFriend.html",host];
            vm.shareUrl = vm.url;
            vc.viewModel = vm;
            
        }
    }
    if (vc) {
        vc.title = m.title;
        [self pushToVC:vc];
    }
    
    
}


#pragma mark-------区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}


#pragma mark-------下拉刷新，下拉刷新
- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupActivityIndicatorView
{
    
}

- (void)onSetupFooter{
    ;
}

- (void)onSetupEmptyView{
    ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


