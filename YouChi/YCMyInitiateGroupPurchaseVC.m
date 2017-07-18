//
//  YCMyInitiateGroupPurchaseVC.m
//  YouChi
//
//  Created by 朱国林 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCPayGroupPurchaseVC.h"
#import "YCPurchaseQrCodeVC.h"
#import "YCMyInitiateGroupPurchaseVC.h"
#import "YCGroupPurchaseMainVC.h"

@interface YCMyInitiateGroupPurchaseVC ()

@end

@implementation YCMyInitiateGroupPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    self.title = @"正在加载中";
}

- (void)dealloc{

}


- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
}

#pragma mark - 我发起的团拼 - cell0
- (void)onConfigureCell:(__kindof YCTableVIewCell *__weak)cell reuseIdentifier:(NSString *)reuseIdentifier
{

    WSELF;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    
    #pragma mark --还差。。。人才能结算 扫扫二维码
    if (reuseIdentifier == cell0) {
        
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
                        
            YCMyGroupView *v = [YCMyGroupView newInSuperView:view];
            
            [cell setSelectBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                SSELF;
                YCMyInitiateGroupM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                YCPayGroupPurchaseVM *vm = [[YCPayGroupPurchaseVM alloc]initWithParameters:@{
                                                                                        @"groupBuyId":m.groupBuyId,
                                                                                    }];
                
                [self pushTo:[YCPayGroupPurchaseVC class] viewModel:vm];
               
            }];
            

            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
                [v yc_initView];
                
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view).insets(UIEdgeInsetsMake(8,8,0,8));
                }];
                
            }];
            
            [v.bQrCode addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *x) {
                SSELF;
                NSIndexPath *idp = [self indexPathForCell:cell];
                YCMyInitiateGroupM *m = [self.viewModel modelForItemAtIndexPath:idp];
                YCPurchaseQrCodeVC *vc = [YCPurchaseQrCodeVC vcClass];
                vc.viewModel = [[YCPurchaseQrCodeVM alloc] initWithId:m.groupBuyId];
                
                [self pushToVC:vc];
                
            }];
            
#pragma mark --发起买单
            [v.bInitiatePay addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *x) {
                SSELF;
                NSIndexPath *idp = [self indexPathForCell:cell];
                
                
                YCMyInitiateGroupM *m = [self.viewModel modelForItemAtIndexPath:idp];
                YCFixOrderVM *vm = [[YCFixOrderVM alloc]initWithId:m.groupBuyId];
                
                vm.orderType = YCOrderTypeGroup;
                [self pushTo:[YCFixOrderVC class] viewModel:vm];
                
            }];

            
            #pragma mark - update
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCMyInitiateGroupM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                [v updateWithLastestGroupon:m];
            }];
            
        }];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


- (void)onSetupRefreshControl
{
    [super onSetupRefreshControl];
}


- (void)didReceiveMemoryWarnin·g {
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
