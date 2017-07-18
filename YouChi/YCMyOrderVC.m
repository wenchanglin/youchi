//
//  YCMyOrderVC.m
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <YYKit/YYKit.h>
#import <NSDate+YYAdd.h>
#import "YCItemDetailM.h"
#import "YCOrderDetailedVC.h"
#import "YCMyOrderVC.h"
#import "YCOrderNumView.h"
#import "YCMyOrderCell.h"
#import "YCMyOrderCell1.h"
#import "YCMyOrderCell2.h"
#import "YCAboutGoodsM.h"
#import "YCOrderJudgeVC.h"
#import "YCFixOrderVC.h"
#import "YCCancelOrderVC.h"


NSString *YCMyOrderNotification = @"YCMyOrderNotification";
@interface YCMyOrderVCP ()
@end

@implementation YCMyOrderVCP
SYNTHESIZE_VM;
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabbar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";

}

-(void)onCreachTabViewControl{
    NSArray *titles = @[@"全部订单",@"待付款订单",@"待评价订单"];
    NSMutableArray *vcs =[NSMutableArray new];
    [titles enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tabControl insertSegmentWithTitle:obj image:nil];
        self.tabControl.hasBottomLine = YES;
        self.tabControl.normalColor = KBGCColor(@"#535353");
        self.tabControl.backgroundColor = KBGCColor(@"ebebeb");
        YCMyOrderVC *vc = [YCMyOrderVC new];
        vc.viewModel = [[YCMyOrderVM alloc]initWithIdx:idx];
        
        [vcs addObject:vc];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCMyOrderNotification object:nil]subscribeNext:^(id x) {
        for (YCMyOrderVC *vc in vcs) {
            [vc onMainSignalExecute:nil];
        }
    }];
    
    [self.tabVC setViewControllers:vcs animated:YES];
}
                   

@end



@interface YCMyOrderVC ()
PROPERTY_STRONG_VM(YCMyOrderVM);
@end

@implementation YCMyOrderVC
@synthesize viewModel;

-(void)onSetupCell
{
    [self onRegisterNibName:@"YCMyOrderCell" Identifier:cell0];
    [self onRegisterNibName:@"YCMyOrderCell1" Identifier:cell1];
    [self onRegisterNibName:@"YCMyOrderCell2" Identifier:cell2];
}

#pragma mark-------网络请求
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

- (instancetype)init{

    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    BOOL isHasNewOrder = NO;
    
    for (YCMyOrderM *m in self.viewModel.modelsProxy) {
        
        if (m.payStatus.intValue == 0 && m.orderStatus.intValue == 0) {
            isHasNewOrder = YES;
        }
    }
    
    
    NSNumber *statue = isHasNewOrder?@(1):@(0);
    
    /// 标记已经进这个界面了，用于红点显示
    
    YCCache *cache =  [YCCache sharedCache];
    [cache.dataBase setObject:statue forKey:YCOrderStatueSave];
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    if ([cell isKindOfClass:[YCMyOrderCell2 class]]){
        
        YCMyOrderCell2 *cell2 = (id)cell;
        [cell2.vOrderPayView.bPayOrder addTarget:self action:@selector(onConfirmthegoods:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.vOrderPayView.bCancelOrder addTarget:self action:@selector(onCanceltheorder:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.vOrderPayView.bAcceptOrder addTarget:self action:@selector(onAccepttheorder:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.vOrderPayView.bReFundOrder addTarget:self action:@selector(onReFundtheorder:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.vOrderPayView.bDeleteOrder addTarget:self action:@selector(onDeleteOrder:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
        SSELF;
        YCBaseModel *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        [cell update:m atIndexPath:indexPath];
    }];
}


#pragma mark-------单元格点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSELF;
    //选顶部信息
    YCMyOrderM *m = [self.viewModel modelForItemAtIndex:indexPath.section];
    YCOrderDetailedVC *vc = [YCOrderDetailedVC vcClass];
    YCOrderDetailedVM *vm = [[YCOrderDetailedVM alloc] initWithId:m.orderId];
    
    
    [vm.orderDetaileUpdateSignal subscribeNext:^(id x) {
        SSELF;
        [self onMainSignalExecute:nil];
    }];
    [self pushToVC:vc viewModel:vm];
}

#pragma mark --，马上支付
- (void) onConfirmthegoods:(UIButton *)sender{
    WSELF;
    YCMyOrderCell2 *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCMyOrderM *m = [self.viewModel modelForItemAtIndexPath:index];
    
    [sender executeActivitySignal:[self.viewModel payItNow:m.orderId] next:^(id next) {
        SSELF;
        [self showMessage:@"支付成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:YCMyOrderNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:YCPayOrderSucessNotification object:nil];
    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    
    

}

#pragma mark --取消订单
- (void) onCanceltheorder:(UIButton *)sender{
    
    
    YCMyOrderCell2 *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCMyOrderM *m = [self.viewModel modelForItemAtIndexPath:index];
    
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要取消这个订单吗 ？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
        SSELF;
        [sender executeActivitySignal:[self.viewModel cancelOrder:m.orderId] next:^(id next) {
            m.orderStatus = @(YCOrderStateHadCancel);
            [self.tableView reloadSection:index.section withRowAnimation:UITableViewRowAnimationAutomatic];
            [self showMessage:@"订单已取消"];
            [[NSNotificationCenter defaultCenter]postNotificationName:YCMyOrderNotification object:nil];
        } error:self.errorBlock completed:nil executing:nil];
    }];
    
    [av show];
    
}

#pragma mark --确认收货
- (void)onAccepttheorder:(UIButton *)sender{

    YCMyOrderCell2 *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCMyOrderM *m = [self.viewModel modelForItemAtIndexPath:index];
    
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您确定已经收到货物了吗 ？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
        SSELF;
        [sender executeActivitySignal:[self.viewModel confirmOrder:m.orderId] next:^(id next) {
            SSELF;
            m.orderStatus = @(YCOrderStateFinish);
            m.shippingStatus = @(YCGoodsStateHadAccept);
            [self.tableView reloadSection:index.section withRowAnimation:UITableViewRowAnimationAutomatic];
            [self showMessage:@"收货成功啦，可以通过晒单来支持我们哦~"];
            [[NSNotificationCenter defaultCenter]postNotificationName:YCMyOrderNotification object:nil];
        } error:self.errorBlock completed:nil executing:nil];
    }];
    
    [av show];
}

#pragma mark --申请退货
- (void)onReFundtheorder:(UIButton *)sender{
    
    YCMyOrderCell2 *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCMyOrderM *m = [self.viewModel modelForItemAtIndexPath:index];
    
    CHECKMidMessage(!m.isMoneyPay.boolValue, @"兑换商品不能退款");
    CHECKMidMessage(m.isPresell.boolValue, @"预售商品不支持退款，请联系客服");
    
    YCCancelOrderVC *vc = [YCCancelOrderVC vcClass:[YCCancelOrderVC class]];
    YCCancelOrderVM *vm = [[YCCancelOrderVM alloc] initWithModel:m];
    WSELF;
    [vm.cancelOrderUpdateSignal subscribeNext:^(id x) {
        
        SSELF
        [self onMainSignalExecute:nil];
    }];
    vc.viewModel = vm;
    [self pushToVC:vc];
}

#pragma mark --删除订单
- (void)onDeleteOrder:(UIButton *)sender{

    YCMyOrderCell2 *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCMyOrderM *m = [self.viewModel modelForItemAtIndexPath:index];
    
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你要删除这个订单吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
        SSELF;
        [sender executeActivitySignal:[self.viewModel deletOrder:m.orderId] next:^(id next) {
            
            [self.tableView beginUpdates];
            [self.viewModel removeModelAtIndex:index.section];
            [self.tableView deleteSection:index.section withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:YCMyOrderNotification object:nil];
        
        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock ];
    }];
    
    [av show];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return .1;
    }
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
}

- (void)onInsertItemsIntoBack:(NSInteger)itemCount
{
    [self onInsertSectionsIntoBack:itemCount];
}

#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSetupEmptyView
{
    
    if ([self.viewModel numberOfSections]==0) {
        self.tableView.backgroundView = self.emptyView;
        self.tableView.tableFooterView = nil;
        if (self.viewModel.integer == 0 ) {
            [self.emptyView updateConstraintsImage:@"付款订单" title:@"没有订单"];
        }else if (self.viewModel.integer == 1){
            [self.emptyView updateConstraintsImage:@"付款订单" title:@"没有待付款订单"];
        }else if (self.viewModel.integer == 2){
            [self.emptyView updateConstraintsImage:@"待评价订单" title:@"没有待评价订单"];
        }
        
    } else {
        self.tableView.backgroundView = nil;
    }
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
