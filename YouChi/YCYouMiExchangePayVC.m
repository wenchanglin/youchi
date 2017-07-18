//
//  YCYouMiExchangePayVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouMiExchangePayVC.h"
#import "YCRecipientAddressCell.h"
#import "YCYouMiExchangePayCell.h"

#import "YCRecipientAddressVC.h"
#import "YCCommodity.h"
@interface YCYouMiExchangePayVCP ()
@property (weak, nonatomic) IBOutlet UILabel *lPayMuch;
///多少友米
@property (weak, nonatomic) IBOutlet UILabel *lMuch;
PROPERTY_STRONG_VM(YCYouMiExchangePayVM);
@end

@implementation YCYouMiExchangePayVCP
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    
    [RACObserve(self.viewModel,shopSpecsModel).deliverOnMainThread subscribeNext:^(YCShopSpecM *m) {
    self.lPayMuch.text =[NSString stringWithFormat:@"%.1f",[m.specMoneyPrice floatValue]];
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///立即兑换
- (IBAction)onPayMuchYouMi:(id)sender {
    CHECK(self.viewModel.AddressModel.address == nil, @"请先添加地址");
    [self executeSignal:self.viewModel.mainSignal next:^(id next) {
        [self showMessage:@"兑换成功"];
        [self onReturn];
    }
      error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];

}


 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     [[segue destinationViewController] setViewModel:self.viewModel];
     
 }


@end


@interface YCYouMiExchangePayVC ()
PROPERTY_STRONG_VM(YCYouMiExchangePayVM);
@end

@implementation YCYouMiExchangePayVC
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)onSetupCell{
    ///商品
    [self onRegisterNibName:@"YCRecipientAddressCell" Identifier:cell0];
    
}

#pragma mark --数据
- (void)onUpdateCell:(id)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            YCRecipientAddressCell *cell0 = (id)cell;
            YCAboutGoodsM *m = model;
            cell0.isHiddenMsg = YES;
            cell0.isArrow = YES;
            [cell0 update:m.address atIndexPath:indexPath];
        }
    }
    else {
        YCYouMiExchangePayCell *cell1 = (id)cell;
        [cell1 update:self.viewModel.shopSpecsModel atIndexPath:indexPath];
    }
  
   
}



#pragma mark-------单元格的选择
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /// 地址
    if (indexPath.section == 0) {
        YCRecipientAddressVM *vm = [YCRecipientAddressVM new];
        YCRecipientAddressVC *vc =[YCRecipientAddressVC vcClass];
        vc.viewModel = vm;
        WSELF;
        [vm.addressChangedSignal.deliverOnMainThread subscribeNext:^(id x) {
            SSELF;
                self.viewModel.AddressModel.address= x;
                NSIndexSet *indexSet =[NSIndexSet indexSetWithIndex:0];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
         
        }];
        [self pushToVC:vc];
    }
    
    
    
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
