//
//  YCFixOrderVC.m
//  YouChi
//
//  Created by 李李善 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCWebVC.h"
#import "YCRecipientAddressVC.h"
#import "YCFixOrderVC.h"
#import "YCFixOrderVM.h"
#import "YCMuchPrice.h"
#import "YCWeixinAndZhiFuCell.h"
#import "YCCommodityCell.h"
#import "YCItemDetailVC.h"
#import "YCSelectCouponVC.h"
#import "YCAddressManageVC.h"
#import "YCMyOrderVC.h"
#import "YCPriceCell.h"
#import "YCTradingRulesCell.h"
#import "YCOrderDetailGroupAddCell.h"


@interface YCFixOrderVC ()

///viewModle
PROPERTY_STRONG_VM(YCFixOrderVM);

@end

@implementation YCFixOrderVC
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:^(NSError *error) {
        self.errorBlock(error);
        [self onReturn];
    } completed:nil executing:self.executingBlock];
}

-(void)onSetupCell
{
    if (self.viewModel.orderType == YCOrderTypeCommodity) {
        ///收货地址信息  addressNotifi
        [self onRegisterNibName:@"YCRecipientAddressCell" Identifier:cell0];
        
    }
    
    if (self.viewModel.orderType == YCOrderTypeGroup) {
        // 团拼收货地址
        [self onRegisterNibName:@"YCOrderDetailGroupAddCell" Identifier:cell0];
    }
    
    //标题
    [self.tableView registerClass:[YCTableVIewCell class] forCellReuseIdentifier:cell1_0];
    
    ///空格单元格
    [self.tableView registerClass:[YCTableVIewCell class] forCellReuseIdentifier:cellInset];
    
    ///商品单元格
    [self onRegisterNibName:@"YCCommodityCell" Identifier:cell3];
    ///详细价格单元格
    [self onRegisterNibName:@"YCPriceCell" Identifier:cell6];
    ///合计单元格
    [self onRegisterNibName:@"YCTotalPriceCell" Identifier:cell7];
    
    // 查看交易明细
    [self onRegisterNibName:@"YCTradingRulesCell" Identifier:cell8];
    
    //备注
    [self.tableView registerClass:[YCTableVIewCell class] forCellReuseIdentifier:cell18];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (void)onConfigureCell:(__kindof YCTableVIewCell *__weak)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    if (reuseIdentifier == cellInset) {
        cell.contentView.backgroundColor = self.tableView.backgroundColor;
        
    }
    
    #pragma mark - 描述标题
    if (reuseIdentifier == cell1_0) {
        cell.contentView.hasTopLine = YES;
        cell.textLabel.font = KFont(15);
        [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            cell.textLabel.text = [self.viewModel modelForItemAtIndexPath:indexPath];
        }];
        [cell setLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
            cell.textLabel.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(2, 8, 2, 2));
        }];
        return;
    }
    
    #pragma mark - 地址
    if (reuseIdentifier == cell0) {
        
        // 团拼时
        if ([cell isKindOfClass:[YCOrderDetailGroupAddCell class]]) {
            
            [cell setUpdateBlock:^(__kindof YCOrderDetailGroupAddCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                [cell.addressView updateRecipientAddress:m];
            }];
            
        }
        
        // 普通商品时
        if ([cell isKindOfClass:[YCRecipientAddressCell class]]) {
            [cell setUpdateBlock:^(__kindof YCRecipientAddressCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                cell.isArrow = YES;
                cell.isHiddenMsg = YES;
                [cell update:m atIndexPath:indexPath];
            }];
            
            [cell setSelectBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
                /// 地址
                YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if (m) {
                    YCRecipientAddressVM *vm = [YCRecipientAddressVM new];
                    YCRecipientAddressVC *vc =[YCRecipientAddressVC vcClass];
                    WSELF;
                    [vm.addressChangedSignal.deliverOnMainThread subscribeNext:^(YCRecipientAddressM *x) {
                        SSELF;
                        self.viewModel.address = x;
                        [self.tableView reloadData];
                        [self onMainSignalExecute:nil];
                    }];
                    [self pushToVC:vc viewModel:vm];
                }
                
                else {
                    YCEditAddressVM *vm = [YCEditAddressVM new];
                    YCEditAddressVC *vc =[YCEditAddressVC vcClass];
                    
                    WSELF;
                    [vm.addressDidUpdateSignal.deliverOnMainThread subscribeNext:^(YCRecipientAddressM *x) {
                        SSELF;
                        self.viewModel.address = x;
                        [self.tableView reloadData];
                        [self onMainSignalExecute:nil];
                    }];
                    [self pushToVC:vc viewModel:vm];

                }
                
            }];
        }
        
        return;
    }
    
    #pragma mark - 支付
    if ([cell isKindOfClass:[YCWeixinAndZhiFuCell class]]) {
        NSArray *payTypes = @[cell1_1,cell1_2];
        self.viewModel.payType = YCPayTypeWeixin - 1;
        [cell setUpdateBlock:^(__kindof YCWeixinAndZhiFuCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            BOOL tick = (self.viewModel.payType == [payTypes indexOfObject:reuseIdentifier]);
            [cell onTick:tick];
        }];
        
        [cell setSelectBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            self.viewModel.payType = [payTypes indexOfObject:reuseIdentifier];
            [self.tableView reloadData];
        }];
        
        return;
    }
    
    #pragma mark - 商品
    if ([cell isKindOfClass:[YCCommodityCell class]]) {
        [cell setUpdateBlock:^(__kindof YCCommodityCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            cell.vGoodsName.ycOrderStateTypeCell = YCOrderStateOrderDetailCll;
            [cell update:m atIndexPath:indexPath];
            
        }];
        
        return;
    }
    
    #pragma mark - 备注
    if (reuseIdentifier == cell18) {
        cell.contentView.hasBottomLine = cell.contentView.hasTopLine = YES;
        [cell setInitBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSString *reuseIdentifier) {
            UITextField *tf = [UITextField newInSuperView:view];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.returnKeyType = UIReturnKeyDone;
            tf.placeholder = @"备注";
            [tf addBlockForControlEvents:UIControlEventEditingDidEndOnExit block:^(id  _Nonnull sender) {
                SSELF;
                [self.view endEditing:YES];
            }];
            RAC(self.viewModel, descriptions) = tf.rac_textSignal;
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
                tf.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(2, 2, 2, 2));
            }];
        }];
        
        
        return;
    }
    
    #pragma mark - 商品
    if (reuseIdentifier == cell3) {
        [cell setSelectBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            YCItemDetailVC *vc = [YCItemDetailVC vcClass];
            YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:m.shopProduct.productId];
            vc.viewModel = vm;
            [self pushToVC:vc];
        }];
        return;
    }
    
    #pragma mark - 优惠券图片
    if (reuseIdentifier == cell4) {
        [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCShopCategoryM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            UIImageView *imageview =[cell viewByTag:1];
            [imageview ycShop_setImageWithURL:m.couponImagePath placeholder:PLACE_HOLDER];
        }];
        return;
    }
    
    #pragma mark - 优惠券按钮
    if (reuseIdentifier == cell5) {
        [cell setSelectBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            YCSelectCouponVM  *vm = [[YCSelectCouponVM alloc]initWithCartIdArray:self.viewModel.cartIdArray];
            [vm.selectCouponSignal subscribeNext:^(YCShopCategoryM * x){
                SSELF;
                self.viewModel.shopCategory = x;
                [self onMainSignalExecute:nil];
            }];
            YCSelectCouponVC *vc = [YCSelectCouponVC vcClass];
            
            [self pushToVC:vc viewModel:vm];

        }];
        return;
    }
    
    #pragma mark - 规则
    if (reuseIdentifier == cell8) {
        [cell setSelectBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCWebVC *web = [[YCWebVC alloc]initWithUrlString:@"http://api1-2.youchi365.com/shop/youmi/团拼.html"];
            [self pushToVC:web];;
        }];
        return;
    }
    
    #pragma mark - 商品总额
    [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
        SSELF;
        id m = [self.viewModel modelForItemAtIndexPath:indexPath];
        [cell update:m atIndexPath:indexPath];
    }];
}




#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
}

- (void)onSetupActivityIndicatorView
{
}

- (void)onSetupFooter
{
}

- (void)onSetupEmptyView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end

@interface YCFixOrderVCP ()

///vc
@property(nonatomic,weak) YCFixOrderVC  *fixOrderVC;

@property (weak, nonatomic) IBOutlet UILabel *price;
///viewModle
@property(nonatomic,strong) YCFixOrderVM  *viewModel;
@end

@implementation YCFixOrderVCP
@synthesize viewModel;
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}



- (void)viewDidLoad
{
    WSELF;
    [super viewDidLoad];
    self.title  = self.viewModel.title;
    
    [RACObserve(self.viewModel, model).deliverOnMainThread subscribeNext:^(YCAboutGoodsM *x) {
        SSELF;
        self.price.text = [NSString stringWithFormat:@"%.2f",x.actualityPayTotal.floatValue];
    }];
    
}

///actualityPayTotal 实付的总价


#pragma mark - 提交并支付
-(IBAction)onConfirmOrder:(UIButton *)sender{
    if (!self.viewModel.address) {
        [self showMessage:@"请完善收货信息"];
        return;
    }
    
    if (self.viewModel.isPresell) {
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message:@"预售商品支付后不能取消订单,是否继续付款?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"购买", nil];
        WSELF;
        [[alertView.rac_buttonClickedSignal ignore:@(alertView.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
            SSELF;
            [self onPayOrder:sender];
        }];
        
        
        [alertView show];
    }
    
    else{
        [self onPayOrder:sender];
    }
    
}

///发起付款
-(void)onPayOrder:(UIButton *)sender
{
    
    [sender executeActivitySignal:[self.viewModel onConfirmOrderSignal] next:^(id next) {
        [self showMessage:@"支付成功"];
        
        ///成功会跳到我的订单，不要乱改
        [self onReturnToBefore];
        
        /// 通知购物车列表刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:YCUpdataMyCarList object:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:YCPayOrderSucessNotification object:nil];
    } error:^(NSError *error) {
        self.errorBlock(error);
        //付款失败，如取消付款
        if (error.domain == error_domain_weixin || error.domain == error_domain_aliplay) {
            [self onReturnToBefore];
        }
        //订单已提交，为空
        if (!(error.domain == kApiVersion && error.code == 800)) {
            [self onReturnToBefore];
        }
    } completed:nil executing:^(BOOL isExecuting) {
        if (isExecuting) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
}

- (void)onReturnToBefore
{
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    YCMyOrderVC *vc = [YCMyOrderVC vcClass];
    [vcs removeLastObject];
    [vcs appendObject:vc];
    [self.navigationController setViewControllers:vcs animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.fixOrderVC = segue.destinationViewController;
    [self.fixOrderVC setViewModel:self.viewModel];
}


@end



