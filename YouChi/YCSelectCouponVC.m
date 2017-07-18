//
//  YCSelectCouponVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSelectCouponVC.h"

#import "YCMyCouponCell.h"
#import "YCWebVC.h"
@interface YCSelectCouponVC ()
PROPERTY_STRONG_VM(YCSelectCouponVM);
@end

@implementation YCSelectCouponVC
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = self.viewModel.title;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"使用规则" style:UIBarButtonItemStylePlain target:self action:@selector(onCouponRule:)];
}


-(void)onSetupCell
{
     [self onRegisterNibName:@"YCMyCouponCell" Identifier:cell0];
}


-(void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:^{
    
        [self onSetupEmptyView];
    } executing:self.executingBlock];
}

- (void)onConfigureCell:(__kindof YCMyCouponCell *__weak)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    cell.btnType = buttonTypeCouponNewCoupon;
    cell.isCoupon = YES;
    
    [cell.btnChoose addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        SSELF;
        YCShopCategoryM *m = [self.viewModel modelForItemAtIndexPath:[self.tableView indexPathForCell:cell]];
        [self.viewModel.selectCouponSignal sendNext:m];
        [self.viewModel.selectCouponSignal sendCompleted];
        [self onReturn];
    }];
    
    [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
        SSELF;
        YCShopCategoryM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        [cell update:m atIndexPath:indexPath];
    }];
}


#pragma mark --使用规则
- (void)onCouponRule:(UIBarButtonItem *)sender {
    
    YCWebVM *vm = [[YCWebVM alloc] init];
    vm.url = [NSString stringWithFormat:@"%@shop/kuaiyi/rule/index.html",host];
    [self pushTo:[YCWebVC class] viewModel:vm hideTabBar:YES];
    
}

- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        [self.emptyView updateConstraintsImage:@"暂无最新优惠券" title:nil];
        self.tableView.backgroundView = self.emptyView;
    }
}

#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    //    [super onSetupRefreshControl];
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
