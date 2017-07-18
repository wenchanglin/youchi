//
//  YCMyParticipationGroupPurchaseVC.m
//  YouChi
//
//  Created by 朱国林 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCPurchaseQrCodeVC.h"
#import "YCMyParticipationGroupPurchaseVC.h"
#import "YCNumberOfPurchaseView.h"
#import "YCGroupPurchaseMainVC.h"
#import "YCOthersInfoVC.h"
#import "YCNewstGroupPurchaseView.h"
@interface YCMyParticipationGroupPurchaseVC ()

@end

@implementation YCMyParticipationGroupPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
}

- (id)onCreateViewModel{
    
    return [YCMyParticipationGroupPurchaseVM new];
}


- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}


- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier{
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    WSELF;
    [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSString *reuseIdentifier) {
        
        YCMyParticipationGroupView *v = [YCMyParticipationGroupView newInSuperView:view];
#pragma mark - 退出団拼
        [v.bInitiatePay addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出团拼？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
                SSELF;
                NSIndexPath *idp = [self indexPathForCell:cell];
                YCMyInitiateGroupM *m = [self.viewModel modelForItemAtIndexPath:idp];
                [sender executeActivitySignal:[self.viewModel cancelGroupByGroupBuyId:m.groupBuyId] next:^(id next) {
                    @try {
                        [self.viewModel removeModelAtIndexPath:idp];
                        [self.tableView deleteRowAtIndexPath:idp withRowAnimation:UITableViewRowAnimationFade];
                    }
                    @catch (NSException *exception) {
                        return ;
                    }
                    @finally {
                        ;
                    }
                    [self showMessage:@"成功"];
                } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                
            }];
            
            [av show];
        }];
        
#pragma mark - 扫扫二维码
        [[v.bQrCode rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
            SSELF;
            NSIndexPath *idp = [self indexPathForCell:cell];
            YCMyInitiateGroupM *m = [self.viewModel modelForItemAtIndexPath:idp];
            YCPurchaseQrCodeVC *vc = [YCPurchaseQrCodeVC vcClass];
            vc.viewModel = [[YCPurchaseQrCodeVM alloc] initWithId:m.groupBuyId];
            
            [self pushToVC:vc];
        }];
        
        [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
            
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view).insets(UIEdgeInsetsMake(8,8,0,8));
            }];
            [v yc_initView];
            
            v.numberOfPurchase.photosView.contentInset = UIEdgeInsetsMake(0, 8, 0, 8);
            
#pragma mark --点击头像
            v.numberOfPurchase.photosView.selectBlock = ^(NSIndexPath *indexPath, YCshopGroupBuySubsM *model) {
                SSELF;
                YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:model.appUser.Id];
                
                [self pushTo:[YCOthersInfoVC class] viewModel:vm];
                
            };
            
        }];
        
        [cell setSelectBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            
            
            YCMyInitiateGroupM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            YCGroupPurchaseMainVM *vm = [[YCGroupPurchaseMainVM alloc]initWithParameters:@{@"groupBuyId":m.groupBuyId}];
            vm.isSponsor = NO;
            YCGroupPurchaseMainVC *vc =[YCGroupPurchaseMainVC vcClass];
            vc.viewModel = vm;
            [self pushToVC:vc];
        }];
        
        [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCMyInitiateGroupM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            [v updateWithLastestGroupon:m];
            
            //            groupPurchaseView.isMyJoin = YES;
            //            [groupPurchaseView onUpdataInitiateGroup:m];
            //            [groupPurchaseView.bInitiatePay setTitle:@"退出团拼" forState:UIControlStateNormal];
            //            groupPurchaseView.bInitiatePay.enabled = YES;
            //            [groupNumberView onUpdataAvatar:m.shopGroupBuySubs];
            //            groupPurchaseView.bInitiatePay.userInteractionEnabled = YES;
            
        }];
        
        
        
        
    }];
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
}


- (void)onSetupRefreshControl{
    [super onSetupRefreshControl];
    
}

@end
