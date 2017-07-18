//
//  YCAddressManageVC.m
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCEditAddressVC.h"
#import "YCAddressManageVC.h"
#import "YCEditAddressVC.h"
#import "YCRecipientAddressVM.h"
#import "YCRecipientAddressM.h"

@interface YCAddressManageVCP ()
PROPERTY_STRONG_VM(YCRecipientAddressVM);


@end

@implementation YCAddressManageVCP
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理收货地址";
    
}
#pragma mark --添加新地址
- (IBAction)onCreateNewAddress:(UIButton *)sender {
    YCEditAddressVM *vm = [[YCEditAddressVM alloc]init];
    [self pushTo:[YCEditAddressVC class] viewModel:vm];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setViewModel:self.viewModel];
}


- (void)onSetupActivityIndicatorView
{
    
}

@end

@interface YCAddressManageVC ()
PROPERTY_STRONG_VM(YCRecipientAddressVM);
@end

@implementation YCAddressManageVC
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    
}

- (void)onConfigureCell:(YCRecipientAddressCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    cell.isArrow = YES;
    [super onConfigureCell:cell reuseIdentifier:reuseIdentifier];
}


#pragma mark - 修改地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    YCEditAddressVM *vm = [[YCEditAddressVM alloc]initWithModel:m];
    WSELF;
    [vm.addressDidUpdateSignal.deliverOnMainThread subscribeNext:^(id x) {
        SSELF;
        @try {
            [self.viewModel.modelsProxy replaceObjectAtIndex:indexPath.row withObject:x];
            [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }
    }];
    [self pushTo:[YCEditAddressVC class] viewModel:vm];
    
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCRecipientAddressM *m = [self.viewModel modelForItemAtIndex:indexPath.section];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除这个地址吗" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        WSELF;
        [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
            SSELF;
            [[self.viewModel deletetById:m.userAddressId type:YCCheatsTypeAddress].deliverOnMainThread subscribeNext:^(id x) {
                
                SSELF;
                @try {
                    
                    [self.tableView beginUpdates];
                    [self.viewModel removeModelAtIndex:indexPath.section];
                    [self.tableView deleteSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                    
                }
                @catch (NSException *exception) {
                    return ;
                }
                @finally {
                    ;
                }
                
            } error:self.errorBlock completed:self.completeBlock];
            
        }];
        
        [av show];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
