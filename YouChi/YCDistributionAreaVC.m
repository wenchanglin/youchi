//
//  YCDistributionAreaVC.m
//  YouChi
//
//  Created by sam on 16/3/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCDistributionAreaVC.h"
#import "YCItemDetailM.h"
@interface YCDistributionAreaVC ()

@end

@implementation YCDistributionAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    if (reuseIdentifier == cell0) {
        cell.textLabel.font = KFont(12);
        [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCShopSpecs *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            cell.textLabel.text = m.shippingProvinceName;
        }];
        [cell setSelectBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            cell.selected = NO;
        }];
    }
}

- (void)onSetupActivityIndicatorView
{
    
}

- (void)onSetupRefreshControl
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController.
    // Pass the selected object to the new view controller.
}
*/

@end


@interface YCPostagePolicyVC ()

@end

@implementation YCPostagePolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    if (reuseIdentifier == cell0) {
        cell.textLabel.font = KFont(12);
        UILabel *detail = [UILabel new];
        detail.font = KFont(12);
        cell.accessoryView = detail;
        [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            shopPostagePolicySub *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            if ([cell checkIsHasSetData:m]) {
                return ;
            }
            cell.textLabel.text = m.name;
            detail.text = [@(m.postage).stringValue stringByAppendingString:@"元"];
            [detail sizeToFit];
        }];
        [cell setSelectBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
            cell.selected = NO;
        }];
    }
}

- (void)onSetupActivityIndicatorView
{
    
}

- (void)onSetupRefreshControl
{
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

@end
