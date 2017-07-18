//
//  YCMyCartVC.m
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
/**
 TODO: + 说明：
 如果代码中有该标识，说明在标识处有功能代码待编写，待实现的功能在说明中会简略说明。
 
 FIXME: + 说明：
 如果代码中有该标识，说明标识处代码需要修正，甚至代码是错误的，不能工作，需要修复，如何修正会在说明中简略说明。
 
 MARK: + 说明：
 如果代码中有该标识，说明标识处代码虽然实现了功能，但是实现的方法有待商榷，希望将来能改进，要改进的地方会在说明中简略说明。
 */

#import "YCMyCartVC.h"
#import "YCCommodity.h"
#import "YCCategoryDelete.h"
#import "YCMuchPrice.h"
#import "YCFixOrderVC.h"
#import "YCMyCartCell.h"
#import "YCItemDetailVC.h"
@interface YCMyCartVCP ()
PROPERTY_STRONG_VM(YCMyCartVM);
@property (weak, nonatomic) IBOutlet UIView *actionBar;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmitOrder;  // 结算按钮
@property (weak, nonatomic) IBOutlet UILabel *totoalPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnAllSelected;  // 全选按钮

@property(nonatomic,strong)YCMyCartVC *vc;
@end

@implementation YCMyCartVCP
SYNTHESIZE_VM;
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    
    WSELF;
    [RACObserve(self.viewModel, totalPrice).deliverOnMainThread subscribeNext:^(id x) {
        SSELF;
        self.totoalPrice.text = x;
    }];
    
    // 所有商品都打钩时，全选的状态
    [RACObserve(self.viewModel, isAllSelected).deliverOnMainThread subscribeNext:^(NSNumber *x) {
        SSELF;
        self.btnAllSelected.selected =!x.boolValue ;
        
    }];
    
    
    /// 未支付时的通知，刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdate) name:YCUpdataMyCarList object:nil];
    
}

- (id)onCreateViewModel{
    
    return [YCMyCartVM new];
}
#pragma mark - 加载
- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    self.actionBar.userInteractionEnabled = NO;
    [self executeSignal:self.viewModel.mainSignal next:^(id next) {
        self.actionBar.userInteractionEnabled = YES;
        [self.vc onReloadItems:0];
        [self.vc onSetupEmptyView];
    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

#pragma mark --全选
- (IBAction)allSelected:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    NSNotification * notice = [NSNotification notificationWithName:@"notAllSeletecd" object:nil userInfo:@{@"isSelected":@(sender.selected)}];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    self.viewModel.isAllGoodsSelected = sender.selected;
    
    if (sender.selected) {
        ///全反选的时候，将全部商品id移除
        [self.viewModel.CartIds removeAllObjects];
        self.viewModel.totalPrice = @"0.00";
        self.vc.totoalPrice = nil;
        
    }else{
        ///全选的时候，将全部商品id添加到数组中
        float total = 0.0;
        
        for (YCAboutGoodsM *m in self.viewModel.modelsProxy) {
            
            [self.viewModel.CartIds addObject:m.cartId];
            total += m.productPrice.floatValue * m.qty.floatValue;
        }
        
        self.btnSubmitOrder.enabled = YES;
        self.viewModel.totalPrice = [NSString stringWithFormat:@"%.2f",total];
    }
    
}


#pragma mark --结算
- (IBAction)settlement:(UIButton *)sender {
    
    ///当没有商品的时候
    CHECKMidMessage([self.viewModel numberOfItemsInSection:0]==0, @"你没有商品结算");
    ///当有商品的时候
    CHECKMidMessage([self.totoalPrice.text isEqualToString:@"0.00"]||self.totoalPrice.text == nil, @"没有选择商品!!!");
    
    YCFixOrderVM *vm = [[YCFixOrderVM alloc]initWithCartIdArray:self.viewModel.CartIds];
    YCFixOrderVC *vc =[YCFixOrderVC vcClass];
    vc.viewModel = vm;
    
    [self pushToVC:vc];
}

- (void)onUpdate{
    
    [self onMainSignalExecute:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.vc =segue.destinationViewController;
    [self.vc setValue:self.viewModel forKey:KP(self.viewModel)];
}


@end

@interface YCMyCartVC ()
@property (nonatomic,strong)YCMyCartVM *viewModel;
// 用于不全选之后重新打钩的判断
@property (nonatomic,assign)BOOL isBiganWithZero;

@end

@implementation YCMyCartVC
@synthesize viewModel;
-(void)onSetupCell{
    [self onRegisterNibName:@"YCMyCartCell" Identifier:cell0];
}

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 全选按钮变化时，打钩按钮变化
    WSELF;
    [RACObserve(self.viewModel, isAllGoodsSelected).deliverOnMainThread subscribeNext:^(NSNumber *x) {
        SSELF;
        
        self.isBiganWithZero = x.boolValue;
        
        for (YCAboutGoodsM *m in self.viewModel.modelsProxy) {
            m.isSelected = !x.boolValue;
        }
        [self onReloadItems:0];
    }];
    
    [self.emptyView updateConstraintsImage:@"无购物车状态" title:nil];
    
}





- (void)onUpdateCell:(UITableViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    
    YCMyCartCell *cell0 = (id)cell;
    [cell0.vGoodsName.btnDelete addTarget:self action:@selector(deleOrder:) forControlEvents:UIControlEventTouchUpInside];
    [cell0.vGoodsName.btnSelect addTarget:self action:@selector(selectedAllGoods:) forControlEvents:UIControlEventTouchUpInside];
    [cell0.vTotalPrice.btnAdd addTarget:self action:@selector(addCount:) forControlEvents:UIControlEventTouchUpInside];
    [cell0.vTotalPrice.btnReduce addTarget:self action:@selector(addCount:) forControlEvents:UIControlEventTouchUpInside];
    [cell0 update:model atIndexPath:indexPath];
}

#pragma mark --删除商品
- (void)deleOrder:(UIButton *)sender{
    
    YCMyCartCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:index];
    
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除这个商品吗 ？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
        SSELF;
        [sender executeActivitySignal:[self.viewModel deletetById:m.cartId type:YCCheatsTypeGoods] next:^(id next) {
            SSELF;
            @try {
                
                if ([self.viewModel.CartIds containsObject:m.cartId]) {
                    [self.viewModel.CartIds removeObject:m.cartId];
                }
                
                [self.viewModel.modelsProxy removeObjectAtIndex:index.row];
                
                float total = 0.0;
                
                for (YCAboutGoodsM *m in self.viewModel.modelsProxy) {
                    
                    total += m.productPrice.floatValue * m.qty.floatValue;
                }
                self.viewModel.totalPrice  = [NSString stringWithFormat:@"%.2f",total];
                
                if ([self isAllSelected]) {
                    
                    self.viewModel.isAllSelected = [self isAllSelected];
                }
                [self onSetupEmptyView];
                [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            @catch (NSException *exception) {
                return ;
            }
            @finally {
                ;
            }
            [self showMessage:@"已经删除了"];
        } error:self.errorBlock completed:nil executing:nil];
    }];
    
    [av show];
}

#pragma mark --选中该商品打钩
- (void)selectedAllGoods:(UIButton *)sender{
    
    YCMyCartCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:index];
    
    m.isSelected = !sender.selected;
    
    sender.selected = !sender.selected;
    if (sender.selected==YES)
        [self.viewModel.CartIds addObject:m.cartId];
    else
        [self.viewModel.CartIds removeObject:m.cartId];
    int i = sender.selected?1:-1;
    
    self.viewModel.totalPrice  = [NSString stringWithFormat:@"%.2f",self.viewModel.totalPrice.floatValue + i * cell.eachGoodsPirce] ;
    
    // 当不全选商品，重新打钩时， 重新计算总价钱
    if (self.isBiganWithZero && sender.selected) {
        
        self.totoalPrice  = [NSString stringWithFormat:@"%.2f",self.totoalPrice.floatValue + cell.eachGoodsPirce] ;
        self.viewModel.totalPrice = self.totoalPrice;
    }else if(self.isBiganWithZero && !sender.selected){
        
        self.totoalPrice = [NSString stringWithFormat:@"%.2f",self.totoalPrice.floatValue - cell.eachGoodsPirce];
        self.viewModel.totalPrice = self.totoalPrice;
    }
    
    BOOL isAllSelected = [self isAllSelected];
    
    // 当有一个cell 不打钩时 全选按钮不选中
    self.viewModel.isAllSelected = isAllSelected;
    
    
}

#pragma mark --用于检查cell是否全部打钩
- (BOOL)isAllSelected{
    
    int i = 0 ;
    for (YCAboutGoodsM *m in self.viewModel.modelsProxy) {
        
        BOOL isSelected = m.isSelected;
        
        i = i + isSelected;
        
    }
    if (i == self.viewModel.modelsProxy.count) {
        
        return YES;
        
    }else
        return NO;
}


#pragma mark --加 减
- (void)addCount:(UIButton *)sender{
    
    YCMyCartCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:index];
    
    // 如果选中了该商品，才能操作加减
    if (cell.vGoodsName.btnSelect.selected) {
        
        int i = m.qty.intValue;
        
        if (sender.tag == 10) {
            CHECKMidMessage(1 == i, @"至少要买一个");
            i = MAX(--i, 1);
        }
        if (sender.tag == 20) {
            i = MIN(++i, m.shopSpec.specQty.intValue);
            CHECKMidMessage(i>m.shopSpec.specQty.intValue, @"库存没有那么多了");
        }
        
        WSELF;
        [sender executeActivitySignal:[self.viewModel updateMyCartWithProductId:m.shopProduct.productId productSpecId:m.shopSpec.specId count:@(i)] next:^(  id next) {
            SSELF;
            
            self.viewModel.totalPrice  = [NSString stringWithFormat:@"%.2f",self.viewModel.totalPrice.floatValue + ((i - m.qty.intValue) * m.productPrice.floatValue )];
            
            m.qty = @(i);
            
            [cell update:m atIndexPath:index];
            
        } error:self.errorBlock completed:nil executing:nil];
        
    }else{
        
        [self showMessage:@"请先选择该商品"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:m.shopProduct.productId];
    YCItemDetailVC *vc = [YCItemDetailVC vcClass:[YCItemDetailVC class]];
    vc.viewModel = vm;
    [self pushToVC:vc];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}


- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        self.tableView.backgroundView = self.emptyView;
    }
}

#pragma mark-------下拉刷新
- (void)onSetupRefreshControl{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
