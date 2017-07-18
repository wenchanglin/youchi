//
//  YCCancelOrderVC.m
//  YouChi
//
//  Created by 朱国林 on 16/2/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCCancelOrderComdityCell.h"
#import "YCCancelOrderVC.h"
#import "YCCancelOrderVM.h"
#import "YCCancelOrderCell.h"
#import "YCCommodityCell.h"
#import <IQTextView.h>
@interface YCCancelOrderVC ()
@property(strong,nonatomic)IQTextView *textView;
@property (weak, nonatomic)UITextField *lPhone;
PROPERTY_STRONG_VM(YCCancelOrderVM);
@end

@implementation YCCancelOrderVC
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"取消订单";
}

-(void)onSetupCell{
    
    
    // 订单号
    [self onRegisterNibName:@"YCMyOrderCell1" Identifier:cell0];
    
    ///商品单元格 
    [self onRegisterNibName:@"YCCancelOrderComdityCell" Identifier:cell1];
    
    ///退货原因
    [self onRegisterNibName:@"YCCancelOrderCell" Identifier:cell2];

}

- (id)onCreateViewModel{

    return [YCCancelOrderVM new];
}

#pragma mark --确认取消
- (IBAction)onSureCancel:(UIBarButtonItem *)sender {
    
    
    CHECK(self.textView.text.length == 0, @"请填写原因...");
    
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要取消这个订单吗 ？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
        SSELF;
        
        [sender executeSignal:[self.viewModel cancelOrder:self.viewModel.orderId phone:self.lPhone.text refundRemark:self.textView.text] next:^(id next) {
            
            [self.viewModel.cancelOrderUpdateSignal sendNext:nil];
            [self.viewModel.cancelOrderUpdateSignal sendCompleted];
            
            [self onReturn];
            
        } error:self.errorBlock completed:self.completeBlock executing:nil];
    }];
    
    [av show];
}

- (void)onUpdateCell:(UITableViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell isKindOfClass:[YCCancelOrderComdityCell class]]){
        
        
    }else if ([cell isKindOfClass:[YCCancelOrderCell class]]){
    
        YCCancelOrderCell *cell3 = (id)cell;
        
        self.textView = cell3.lReason;
    }
    
    if (indexPath.section == 3) {
        
        UITextField *text = (id)[cell viewByTag:1010];
        self.lPhone = text;
    }
    
    [cell update:model atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 2) {
        return .1f;
    }
    
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1f;
}


#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    //    [super onSetupRefreshControl];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
