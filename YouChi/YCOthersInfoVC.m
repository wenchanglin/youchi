
//
//  YCOthersInfoVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/14.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCOthersInfoVC.h"
#import "YCViewModel+Logic.h"
#import <Masonry/Masonry.h>
#import "YCFollowsVMAndFansVC.h"
#import "YCFollowsM.h"
#import "YCFollowsVM.h"


#import "YCRecipeDetailVM.h"
#import "YCRecipeDetailVC.h"
#import "YCYouChiDetailVM.h"
#import "YCYouChiDetailVC.h"
#import "YCOthersInfoVM.h"
#import "YCChihuoyingM.h"
#import "YCWebVM.h"
#import "YCWebVC.h"
#import "YCProfileView.h"
#import "YCChihuoyingCell.h"
#import "YCChihuoNubmerCell.h"

#import "YCSwitchTabControl.h"

#import "YCProfileView.h"
#import "YCPhotoBrowser.h"

@interface YCOthersInfoVC ()
@property (nonatomic,strong) YCProfileView *profile;

@property(nonatomic,strong) YCSwitchTabControl *option;
PROPERTY_STRONG_VM(YCOthersInfoVM);
@end

@implementation YCOthersInfoVC
SYNTHESIZE_VM;


- (void)dealloc{
    //OK
}

- (void)showTabbar
{
    ;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    RAC(self, title) = RACObserve(self.viewModel, title).deliverOnMainThread;

   [self creatSpecialTab];
    
    self.profile = ({
        YCProfileView *header = [YCProfileView viewByClass:[YCProfileView class]];
        header.profileButtonsView.profileButtonsCount = 3;
        NSArray *btns = header.profileButtonsView.profileButtons;

        [btns[0] addTarget:self action:@selector(onFollowAndFansClick:) forControlEvents:UIControlEventTouchUpInside];
        [btns[1] addTarget:self action:@selector(onFollowAndFansClick:) forControlEvents:UIControlEventTouchUpInside];

        
        [header.edit addTarget:self action:@selector(onAttentionOthers:) forControlEvents:UIControlEventTouchUpInside];
        UIView *view = self.tableView.tableHeaderView;
        [view addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        header;
    });
    
    
    
    
    YCOthersInfoVM *vm = self.viewModel;
    WSELF;
    [[RACObserve(vm, appUser) deliverOnMainThread] subscribeNext:^(YCLoginUserM *user) {
        SSELF;
        
        [self.profile.infoAvatar updateAvatarControlWith:user.imagePath name:user.nickName sign:user.signature sex:user.sex];
        NSArray *btns = self.profile.profileButtonsView.profileButtons;
        [btns[0] setTitle:[[NSString alloc]initWithFormat:@"%d\n关注",user.followerCount.intValue] forState:UIControlStateNormal];
        [btns[1] setTitle:[[NSString alloc]initWithFormat:@"%d\n粉丝",user.fansCount.intValue] forState:UIControlStateNormal];
        [btns[2] setTitle:[[NSString alloc]initWithFormat:@"%d\n分享",user.shareCount.intValue] forState:UIControlStateNormal];
        self.profile.rank.desc.text = user.levelId?[[NSString alloc]initWithFormat:@" Level %d",user.levelId.intValue]:nil;
        [self.profile.edit setTitle:KSELTile(user.isFollow.boolValue) forState:UIControlStateNormal];
        self.profile.edit.backgroundColor = KSelected(user.isFollow.boolValue);
        [self.profile.edit setTitle:user.isFollow.boolValue?@"已关注":@"关注" forState:UIControlStateNormal];
        [self.profile.edit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.profile.edit setTitleColor:color_d09356 forState:UIControlStateSelected];
        if (user) {
            [self.profile.infoAvatar addTarget:self action:@selector(onMyAvatar:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [self.profile.infoAvatar removeTarget:self action:@selector(onMyAvatar:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    } error:self.errorBlock];
    
}

#pragma mark - 头像
- (void)onMyAvatar:(id)sender
{
    YCBaseImageModel *m = [YCBaseImageModel new];
    m.imagePath = self.viewModel.appUser.imagePath;
    YCPhotoBrowser *browser = [[YCPhotoBrowser alloc]initWithPageModels:@[m] selectedIndex:0];
    [self pushToVC:browser];
}



#pragma mark - 加载
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    WSELF;
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:^{
        SSELF;

        if ([self.viewModel numberOfItemsInSection:0] == 0) {
            self.tableView.tableFooterView = nil;
            self.tableView.backgroundView = self.emptyView;
            self.emptyView.emptyLabel.text = @"这家伙的作品空空如也,什么都没有...";
        } else {
            self.tableView.tableFooterView = self.loadControl;
            self.tableView.backgroundView = nil;
        }
    } executing:self.executingBlock];
    
}


#pragma mark --数据
- (void)onUpdateCell:(YCChihuoyingCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    [super onUpdateCell:cell model:model atIndexPath:indexPath];
}


#pragma mark --选中行
- (void )onFollowAndFansClick:(UIButton *)sender {
    
    if ([self pushToLoginVCIfNotLogin]) {
        return ;
    }
    YCFollowsVMAndFansVC *followsVMAndFansVC = [YCFollowsVMAndFansVC vcClass:[YCFollowsVMAndFansVC class]];
    
    NSInteger idx = [self.profile.profileButtonsView.profileButtons indexOfObject:sender];
    id Id = self.viewModel.Id;
    if (idx == 0){
        followsVMAndFansVC.viewModel = [[YCFollowsVM alloc]initWithId:Id];
    }
    else if(idx == 1){
        followsVMAndFansVC.viewModel = [[YCFansVM alloc]initWithId:Id];
    }

    [self.navigationController pushViewController:followsVMAndFansVC animated:YES];
}

#pragma mark --关注
- (IBAction)onAttentionOthers:(UIButton *)sender {
    
    YCLoginUserM *appUser =self.viewModel.appUser;
    BOOL isFollow =!appUser.isFollow.boolValue;
    int fansCounts = appUser.fansCount.intValue;
    fansCounts = isFollow?fansCounts+1:fansCounts-1;
    [sender executeActivitySignal:[self.viewModel followUserById:appUser.Id isFollow:isFollow]  next:^(id x) {
        appUser.isFollow = @(isFollow);
        [sender setTitle:KSELTile(isFollow) forState:UIControlStateNormal];
        appUser.fansCount = @(fansCounts);
        
        NSArray *btns = self.profile.profileButtonsView.profileButtons;
        [btns[1] setTitle:[[NSString alloc]initWithFormat:@"%d\n粉丝",fansCounts] forState:UIControlStateNormal];
        sender.backgroundColor = KSelected(isFollow);
    } error:self.errorBlock completed:nil executing:nil];
}

#pragma mark --用户详细信息
- (IBAction)onAvatar:(YCAvatarControl *)sender {
    [self showMessage:[[NSString alloc] initWithFormat:@"您正在看是%@的主页",self.viewModel.appUser.nickName]];
}

#pragma mark --表头
- (void)onConfigureHeader:(YCTableViewHeaderFooterView *)header reuseIdentifier:(NSString *)reuseIdentifier
{
    if (reuseIdentifier == headerC) {
        WSELF;
        [header addSubview:self.option];
        [header setLayoutBlock:^(YCTableViewHeaderFooterView *headerFooter, UIView *view, CGRect frame) {
            SSELF;
            self.option.frame = frame;
        }];
    }
}





#pragma mark --切换 <随后拍和秘籍>
- (void)onYouChiAndRecipe:(YCSwitchTabControl *)sender{
    [sender segmentLineScrollToIndex:sender.selectedSegmentIndex animate:YES];
    [self.viewModel onSelectWithInteger:sender.selectedSegmentIndex];
    [self onMainSignalExecute:nil];
}

-(void)creatSpecialTab{
    
    YCSwitchTabControl *specialTabControl = [[YCSwitchTabControl alloc] init];
    specialTabControl.backgroundColor = KBGCColor(@"#EBEBEB");
    specialTabControl.frame = CGRectMake(0, 0,SCREEN_WIDTH ,44 );
    [specialTabControl insertSegmentWithTitle:@"随手拍" image:nil];
    [specialTabControl insertSegmentWithTitle:@"秘籍" image:nil];
    [specialTabControl onCreachSpecialWithSelColor:nil normalColor:nil font:16];
    specialTabControl.hasBottomLine = YES;
    [specialTabControl addTarget:self action:@selector(onYouChiAndRecipe:) forControlEvents:UIControlEventValueChanged];
   _option = specialTabControl;
}


#pragma mark ------上拉加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
}

//下拉刷新
- (void)onSetupRefreshControl
{
    ;
}

///网络加载
- (void)onSetupActivityIndicatorView{
    [super onSetupActivityIndicatorView];
}

- (void)onSetupFooter{
    [super onSetupFooter];
}
- (void)onSetupEmptyView{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end



