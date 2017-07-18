//
//  YCOrderDetailedVC.m
//  YouChi
//
//  Created by 李李善 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCOrderDetailGroupAddCell.h"
#import "YCRecipientAddressM.h"
#import "YCApplyForRefundVC.h"
#import "YCOrderJudgeVC.h"
#import "YCOrderDetailedVC.h"
#import "YCOrderDetailedVM.h"
#import "YCCommodityManifestCell.h"
#import "YCRecipientAddressCell.h"
#import "YCDeliveredlocationCell.h"
#import <ACETelPrompt/ACETelPrompt.h>
#import "YCMyOrderCell1.h"
#import "YCJoinGroupNumCell.h"
#import "YCApplyForRefundVC.h"
#import "YCOrderJudgeVC.h"
#import "YCGroupSettlementHeadView.h"

#import "YCItemDetailVC.h"
#import "YCLogisticsDetailsVC.h"

#import "YCLogisticsCell.h"


#import "YCRefundConditionVC.h"

#import "YCWebVC.h"
@interface YCOrderDetailedVCP ()
@property (weak, nonatomic) IBOutlet UIButton *orderStatue;
@property(nonatomic,strong)YCOrderDetailedVC *vc;
PROPERTY_STRONG_VM(YCOrderDetailedVM);
@property (nonatomic,assign) YCOrderState YCOrderState;
@end
@implementation YCOrderDetailedVCP
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    WSELF;
    [RACObserve(self.viewModel, orderSendingState).deliverOnMainThread subscribeNext:^(NSNumber* x) {
        SSELF;
        
        self.YCOrderState = x.intValue;
        
        NSString *title;
        BOOL isHidden;
        if (x.intValue == YCGoodsStateHadSend && self.viewModel.model.orderStatus.intValue!=5){  // 已发货才收货
            
            title = @"确认收货";
            isHidden = NO;
            
        }
        
        else{
            
            isHidden = YES;
        }
        
        [self.orderStatue setTitle:title forState:UIControlStateNormal];
        self.orderStatue.hidden = isHidden;
    }];
    
}


-(id)onCreateViewModel
{
    return [YCOrderDetailedVM new];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    
}



#pragma mark --联系客服
- (IBAction)callServicer:(UIButton *)sender {
    
    [ACETelPrompt callPhoneNumber:CustomerService call:^(NSTimeInterval duration) {
        ;
    } cancel:^{
        ;
    }];
}

#pragma mark --收货状态 <确认收货？已收货>
- (IBAction)goodsState:(UIButton *)sender {
    
    if (self.viewModel.model == nil) {
        [self showMessage:@"连接错误"];
        return;
    }
    
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您确定已经收到货物了吗 ？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
        SSELF;
        [sender executeActivitySignal:[self.viewModel confirmOrder:self.viewModel.model.orderId] next:^(id next){
            
            [self onMainSignalExecute:nil];
            [self.viewModel.orderDetaileUpdateSignal sendNext:nil];
        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
        
    }];
    
    [av show];
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.vc =segue.destinationViewController;
    [self.vc setValue:self.viewModel forKey:KP(self.viewModel)];
}


@end

@interface YCOrderDetailedVC ()
@property (nonatomic,strong) YCOrderDetailedVM *viewModel;
@end

@implementation YCOrderDetailedVC
@synthesize viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


-(void)onSetupCell{
    
    
    ///收货地址信息
    [self onRegisterNibName:@"YCDeliveredlocationCell" Identifier:cell1];
    
    ///  团拼收货地址信息
    [self onRegisterNibName:@"YCOrderDetailGroupAddCell" Identifier:cell3];
    
    ///物流单元格
    [self onRegisterNibName:@"YCLogisticsCell" Identifier:cell2];
    
    ///商品清单单元格
    [self onRegisterNibName:@"YCCommodityManifestCell" Identifier:cell4];
    
    ///空格单元格
    [self.tableView registerClass:[YCTableVIewCell class] forCellReuseIdentifier:cell00];
    
    //?
    [self.tableView registerClass:[YCTableVIewCell class] forCellReuseIdentifier:cell4_1];
    
    //留言描述
    [self.tableView registerClass:[YCTableVIewCell class] forCellReuseIdentifier:cell13];
    
    ///团拼参与人
    [self onRegisterNibName:@"YCJoinGroupNumCell" Identifier:cell5];
    
    ///详细价格单元格
    [self onRegisterNibName:@"YCPriceCell" Identifier:cell6];
    
    ///合计单元格
    [self onRegisterNibName:@"YCTotalPriceCell" Identifier:cell8];
    
    /// 交易规则
    [self onRegisterNibName:@"YCTradingRulesCell" Identifier:cell9];
    
    /// 订单号
    [self onRegisterNibName:@"YCMyOrderCell1" Identifier:cell0];
    
    /// 退货
    [self onRegisterNibName:@"YCReturnedMoneyCell" Identifier:cell10];
    
    /// 商品已经发货
    [self onRegisterNibName:@"YCGroupOrderNumViewCell" Identifier:cell12];
    
}

-(void)onSetupHeaderFooter{
    [self onRegisterNibName:@"YCOrderDetailedHead" HeaderFooterViewIdentifier:headerC3];
    [self onRegisterNibName:@"YCOrderDetailedNumberHead" HeaderFooterViewIdentifier:headerC4];
    [self onRegisterNibName:@"YCOrderGroupDetailedHead" HeaderFooterViewIdentifier:headerC5];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock   error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (void)onConfigureCell:(__kindof YCTableVIewCell *__weak)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    if (reuseIdentifier == cell00) {
        cell.backgroundColor = self.tableView.backgroundColor;
    }
    if (reuseIdentifier == cell2) {
        YCLogisticsCell *cell2 = cell;
        [cell2.btnWuLiu addTarget:self action:@selector(onLookAtWuLiu:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (reuseIdentifier == cell4) {
        YCCommodityManifestCell *cell3 = cell;
        
        ///加入购物车
        [cell3.orderStatueView.bAddToCart addTarget:self action:@selector(onAddToCart:) forControlEvents:UIControlEventTouchUpInside];
        ///申请退货
        [cell3.orderStatueView.bApplyRefund addTarget:self action:@selector(onRefund:) forControlEvents:UIControlEventTouchUpInside];
        ///晒单评价
        [cell3.orderStatueView.bComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
        ///查看退货
        [cell3.orderStatueView.bViewTheReturn addTarget:self action:@selector(onViewTheReturnOf:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (reuseIdentifier == cell5) {
        YCJoinGroupNumCell *cell5 = cell;
        // 团拼支付
        [cell5.joinGroupNumVoew.bPay addTarget:self action:@selector(onPayOfGroup:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (reuseIdentifier == cell13) {
        //用户信息
        
        [cell setInitBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSString *reuseIdentifier) {
            view.hasBottomLine = YES;
            
            YYLabel *l = [YYLabel newInSuperView:view];
            
            l.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 8);
            l.font = KFont(14);
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                NSString *text = self.viewModel.model.desc;
                l.text = [NSString stringWithFormat:@"备注：%@",text?:@""];
            }];
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
                l.frame = frame;
            }];
        }];
        return;
    }
    
    [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
        SSELF;
        YCBaseModel *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        [cell update:m atIndexPath:indexPath];
    }];
}

-(void)onUpdateCell:(UITableViewCell *)cell model:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==3){
        YCLogisticsCell *cell2 = (id)cell;
        [cell2.btnWuLiu addTarget:self action:@selector(onLookAtWuLiu:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (indexPath.section==4) {
        if (indexPath.row != self.viewModel.model.shopOrderProducts.count ){
            YCCommodityManifestCell *cell3 = (id)cell;
            
            ///加入购物车
            [cell3.orderStatueView.bAddToCart addTarget:self action:@selector(onAddToCart:) forControlEvents:UIControlEventTouchUpInside];
            ///申请退货
            [cell3.orderStatueView.bApplyRefund addTarget:self action:@selector(onRefund:) forControlEvents:UIControlEventTouchUpInside];
            ///晒单评价
            [cell3.orderStatueView.bComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
            ///查看退货
            [cell3.orderStatueView.bViewTheReturn addTarget:self action:@selector(onViewTheReturnOf:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    else if (indexPath.section == 5){
        
        if (indexPath.row != self.viewModel.model.shopGroupBuySubs.count) {
            
            YCJoinGroupNumCell *cell5 = (id)cell;
            // 团拼支付
            [cell5.joinGroupNumVoew.bPay addTarget:self action:@selector(onPayOfGroup:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
}

#pragma mark-------单元格点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 4) {
        
        YCShopOrderProductM *m = self.viewModel.model.shopOrderProducts[indexPath.row ];
        YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:m.shopProduct.productId];
        if (!m.isMoneyPay.boolValue) {
            vm.youMiModel = m;
        }
        YCItemDetailVC *vc = [YCItemDetailVC vcClass:[YCItemDetailVC class]];
        vc.viewModel = vm;
        [self pushToVC:vc];
    }
    else if (indexPath.section==6){
        YCWebVC *web = [[YCWebVC alloc]initWithUrlString: @"http://api1-2.youchi365.com/shop/youmi/团拼.html"];
        [self pushToVC:web];
    }
    
}

#pragma mark --查看物流
-(void)onLookAtWuLiu:(UIButton *)btn{
    
    UITableViewCell *cell =[btn findTableViewCell];
    NSIndexPath *indx = [self indexPathForCell:cell];
    YCShopWuliuInfoM *model = [self.viewModel modelForItemAtIndexPath:indx];
    
    if (!model.wuliuJson.count) {
        [self showMessage:@"暂时没有物流信息"];
        return;
    }
    
    YCLogisticsDetailsVC *vc =[ YCLogisticsDetailsVC vcClass:[YCLogisticsDetailsVC class]];
    YCLogisticsDetailsVM *vm = [[YCLogisticsDetailsVM alloc]initWithId:model.wuliuInfoId];
    
    vm.isYouMi = self.viewModel.model.isMoneyPay.boolValue;
    vc.viewModel = vm;
    [self pushToVC:vc];
}




#pragma mark-- 申请退货
- (void)onRefund:(UIButton *)sender{
    WSELF;
    YCCommodityManifestCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCShopOrderProductM *m = self.viewModel.model.shopOrderProducts[index.row ];
    
    YCApplyForRefundVM *vm =[[YCApplyForRefundVM alloc]initWithModel:m];
    YCApplyForRefundVCP * vc = [YCApplyForRefundVCP vcClass:[YCApplyForRefundVC class]];
    vc.viewModel = vm;
    [vm.applyForRefundSignal subscribeNext:^(id x) {
        SSELF;
        @try {
            m.isRefund =@(YES);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:4];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    [self pushToVC:vc];
    
}

#pragma mark--- 晒单评价
- (void)onComment:(UIButton *)sender{
    
    YCCommodityManifestCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCShopOrderProductM *m = self.viewModel.model.shopOrderProducts[index.row ];
    
    YCShopProductM *model = m.shopProduct;
    YCOrderJudgeVM *vm = [[YCOrderJudgeVM alloc]initWithModel:m];
    vm.orderId = self.viewModel.model.orderId.intValue;//1
    vm.orderProductId = m.orderProductId.intValue;//1
    vm.productId = model.productId.intValue;
    [self pushTo:[YCOrderJudgeVC class] viewModel:vm];
}

#pragma mark --加入购物车
- (void)onAddToCart:(UIButton *)sender{
    
    YCCommodityManifestCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCShopOrderProductM *m = self.viewModel.model.shopOrderProducts[index.row];
    
    CHECK(self.viewModel.model.isTeamOrder.boolValue, @"团拼商品需要前往团拼处购买");
    CHECK(!m.isMoneyPay.boolValue, @"友米兑换的商品不能加入购物车,请点击详情页购买");
    CHECK(m.shopProduct.isPresell.boolValue, @"预售商品不能加入购物车,请点击详情页购买");
    
    [sender executeActivitySignal:[self.viewModel addToCart:m.shopProduct.productId  productSpecId:@(0) count:@(1)] next:^(id next) {
        
        [self showMessage:@"已经添加到了购物车"];
        
    } error:self.errorBlock completed:nil executing:nil];
}


#pragma mark --查看退货
- (void)onViewTheReturnOf:(UIButton *)sender{
    
    YCCommodityManifestCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCShopOrderProductM *m = self.viewModel.model.shopOrderProducts[index.row];
    
    YCRefundConditionVM *vm = [[YCRefundConditionVM alloc]initWithModel:m];
    vm.Id =m.orderProductId;
    vm.isYouMi = m.isMoneyPay.boolValue;
    [self pushTo:[YCRefundConditionVC class] viewModel:vm];
}

#pragma mark --团拼催支付
- (void)onPayOfGroup:(UIButton *)sender{
    
    YCJoinGroupNumCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCShopOrderGroupBuySubs *m = self.viewModel.model.shopGroupBuySubs[index.row];
    
    if (m.isPay.boolValue) {
        
        return;
    }else{
        
        if (m.isMe.boolValue) {// 自身未付款
            
            [sender executeActivitySignal:[self.viewModel payItNow:self.viewModel.Id] next:^(id next) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
            
            
        }
        
        else { // 团员未付款
            
            [self executeSignal:[self.viewModel onUrgePay:m.appUser.Id groupBuyId:m.shopGroupBuy.groupBuyId] next:^(id next) {
                
                sender.enabled = NO;
                [sender backColor:KBGCColor(@"a9a9a9")];
                
                [self showMessage:@"催款成功!"];
            } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
            
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section==4){
        return 35.f;
    }
    
    if (section==5) {
        if (!self.viewModel.model.isTeamOrder.boolValue) {
            return 0.f;
        }
        return 35.f;
    }
    
    if (section==6) {
        if (!self.viewModel.model.isMoneyPay.boolValue) {
            return 0.f;
        }
        return 35.f;
    }
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==4) {
        UITableViewHeaderFooterView *view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerC3];
        if (!view) {
            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerC3];
        }
        view.hasBottomLine = YES;
        view.hasTopLine = YES;
        view.backgroundView = [UIView viewByWhiteBackgroundColor];
        return view;
    }else if(section==5){
        UITableViewHeaderFooterView *view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerC5];
        if (!view) {
            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerC5];
        }
        view.hasBottomLine = YES;
        view.hasTopLine = YES;
        view.contentView.backgroundColor = [UIColor whiteColor];
        YCGroupSettlementHeadView *headV = [view viewByTag:1234];
        
        [headV.bShipmentsRules addTarget:self action:@selector(onGotoRule) forControlEvents: UIControlEventTouchUpInside];
        
        return view;
    }
    else if(section==6){
        UITableViewHeaderFooterView *view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerC4];
        if (!view) {
            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerC4];
            view.hasTopLine = YES;
            view.backgroundView = [UIView viewByWhiteBackgroundColor];
        }
        
        return view;
    }
    
    return nil;
}

- (void)onGotoRule
{
    YCWebVC *web = [[YCWebVC alloc]initWithUrlString:@"http://api1-2.youchi365.com/shop/youmi/团拼.html"];
    [self pushToVC:web];
}

#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    //    [super onSetupRefreshControl];
}
- (void)onSetupActivityIndicatorView
{
    //    [super onSetupActivityIndicatorView];
}

- (void)onSetupFooter
{
    //    [super onSetupFooter];
}

- (void)onSetupEmptyView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [self onScrollToBottom:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [segue.destinationViewController setViewModel:self.viewModel];
}


@end
