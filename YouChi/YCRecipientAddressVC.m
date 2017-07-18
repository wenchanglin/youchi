//
//  YCRecipientAddressVC.m
//  YouChi
//
//  Created by 朱国林 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCAddressManageVC.h"
#import "YCRecipientAddressVC.h"
#import "YCRecipientAddressCell.h"

@interface YCRecipientAddressVC ()

@end

@implementation YCRecipientAddressVC
SYNTHESIZE_VM;
-(void)onSetupCell{
    ///商品
    [self onRegisterNibName:@"YCRecipientAddressCell" Identifier:cell1];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址列表";
}

- (id)onCreateViewModel{
    return [YCRecipientAddressVM new];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

#pragma mark --管理收货地址
- (IBAction)onAddressManage:(UIBarButtonItem *)sender {
    
  [self pushTo:[YCAddressManageVC class] viewModel:self.viewModel];
}


- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    if (reuseIdentifier == cell1) {
        [cell setInitBlock:^(__kindof YCRecipientAddressCell *__weak cell, UIView *view, NSString *reuseIdentifier) {
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                [cell update:m atIndexPath:indexPath];
            }];
        }];
    }
}

#pragma mark - 选择地址－这里改变为默认地址 ，刷新表格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    WSELF;
    [[self.viewModel setDefaultAddress:m.userAddressId].deliverOnMainThread subscribeNext:^(id x) {
        SSELF;
        
        [self.viewModel.addressChangedSignal sendNext:m];
        
        [self onReturn];
        
    } error:self.errorBlock completed:self.completeBlock];
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

- (void)onSetupActivityIndicatorView
{
    
}

#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
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
