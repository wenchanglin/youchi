//
//  YCPurchaseQrCodeVC.m
//  YouChi
//
//  Created by 朱国林 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCOthersInfoVC.h"
#import "YCGroupAddressView.h"
#import "YCCreateGroupPurchaseVM.h"
#import "Masonry.h"
#import "YCPurchaseQrCodeVC.h"
#import "YCTableViewController.h"
@interface YCPurchaseQrCodeVC ()

@end

@implementation YCPurchaseQrCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    
    self.title = @"参与扫码";
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"请使用友吃App扫一扫参与团拼" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
}


- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
}


- (void)onConfigureCell:(__kindof YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier{
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    WSELF;
    if (reuseIdentifier == cell0) {
        
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YCPurchaseInfoView *purchaseInfoView = [YCPurchaseInfoView newInSuperView:view];
            
            
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                view.hasBottomLine = YES;
                [purchaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 14, 0, 14));
                }];
                view.backgroundColor = [UIColor whiteColor];
                
                [purchaseInfoView yc_initView];
                
#pragma mark --点击头像
                purchaseInfoView.numberOfPurchaseView.photosView.selectBlock = ^(NSIndexPath *indexPath,YCshopGroupBuySubsM *model) {
                    SSELF;
                    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:model.appUser.Id];
                    
                    [self pushTo:[YCOthersInfoVC class] viewModel:vm];
                };
            }];
            
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCGroupQrCodeM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [purchaseInfoView updateWithItem:m];
            }];
        }];
        return;
    }
    
    
    if (reuseIdentifier == cell1) {
        
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            view.hasBottomLine = YES;
        }];
        
        return;
    }
    
    
    if(reuseIdentifier == cell2){
        
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIImageView *QrCode = [UIImageView newInSuperView:view];
            UILabel *l = [UILabel newInSuperView:view];
            
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCGroupQrCodeM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [QrCode ycShop_setImageWithURL:m.qrcodePath placeholder:AVATAR];
                l.text = @"请使用友吃App扫一扫参与团拼 不是微信扫一扫";
            }];
            
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                QrCode.contentMode = UIViewContentModeScaleAspectFit;
                l.font = [UIFont systemFontOfSize:14];
                l.textColor = [UIColor colorWithHexString:@"333333"];
                view.hasTopLine = YES;
                
                [QrCode mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(view).offset(12);
                    make.height.equalTo(@(165));
                    make.width.equalTo(@(167));
                    make.centerX.equalTo(view);
                }];
                
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(QrCode.mas_bottom).offset(15);
                    make.centerX.equalTo(QrCode);
                }];
            }];
            
        }];
        
        return;
    }
    
    
    /// 地址
    if (reuseIdentifier == cell3) {
    
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YCGroupAddressView *v = [YCGroupAddressView newInSuperView:view];
            cell.backgroundColor = view.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                
                 SSELF;
                YCGroupQrCodeM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [v onUpdataName:m.shopUserAddress.receiverName phone:m.shopUserAddress.receiverPhone address:m.addStr];
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                v.frame = UIEdgeInsetsInsetRect(view.bounds,UIEdgeInsetsMake(0,8,0,8));
            }];
            
        }];
        
        return;
    }    
}


- (void)onSetupRefreshControl
{
    
}

- (void)onSetupFooter
{
    
}

- (void)onSetupActivityIndicatorView
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
