//
//  YCAttantionAndFansVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/13.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFollowsVMAndFansVC.h"
#import "YCFollowsVM.h"
#import "YCViewModel+Logic.h"
#import "YCFollowsM.h"
#import "YCFansCell.h"
#import "YCLoginVM.h"


@interface YCFollowsVMAndFansVC ()
@property (nonatomic,strong) YCFollowsVM *viewModel;
@end

@implementation YCFollowsVMAndFansVC
@synthesize viewModel;

-(void)dealloc{
    //OK
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark - 生命周期
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.isTabBarHidden) {
        [self hideTabbar];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    
}

#pragma mark -
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
}


#pragma mark -关注，取消关注
- (IBAction)onFollow:(UIButton *)sender {
    
    UITableViewCell *cell = sender.findTableViewCell;
    NSIndexPath * IndexPath =[self indexPathForCell:cell];
    
    NSNumber *userId;
    
    YCFollowUserListM *m = [self.viewModel modelForItemAtIndexPath:IndexPath];
    
    
    if (self.viewModel.isFans==NO) {
        userId = m.followUserId;
    }else {
       
        YCFansUserListM *m = [self.viewModel modelForItemAtIndexPath:IndexPath];
        userId = m.fansId;
    }
    
    BOOL isFollow = ![m.isFollow boolValue];
    
    [sender executeActivitySignal:[self.viewModel followUserById:userId isFollow:isFollow]  next:^(id x) {
        
        sender.selected = isFollow;
        m.isFollow  = @(isFollow);
        
    } error:self.errorBlock completed:self.completeBlock executing:nil];
}


#pragma mark - 选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id m = [self.viewModel modelForItemAtIndexPath:indexPath];
    YCOthersInfoVM *vm = nil;
    if ([m isKindOfClass:[YCFollowUserListM class]]) {
        
        vm = [[YCOthersInfoVM alloc]initWithId:[m followUserId]];
    }

    else if ([m isKindOfClass:[YCFansUserListM class]]) {
        
        vm = [[YCOthersInfoVM alloc]initWithId:[m fansId]];
    }
    [self pushTo:[YCOthersInfoVC class] viewModel:vm ];
    
}

//上拉加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self onScrollToBottom:scrollView];
}
//下拉刷新
- (void)onSetupRefreshControl{
    ;
}
///网络加载
- (void)onSetupActivityIndicatorView{
//    [super onSetupActivityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
