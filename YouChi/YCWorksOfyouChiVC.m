//
//  YCMyTakePicturesVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCWorksOfyouChiVC.h"
#import "YCWorksOfyouChiVM.h"
#import "YCChihuoyingCell.h"
#import "YCChihuoPhotoCell.h"
#import "YCChihuoNubmerCell.h"
#import "YCYouChiDetailVM.h"
#import "YCRecipeDetailVM.h"
#import "YCRecipeDetailVC.h"
#import "YCYouChiDetailVC.h"

@interface YCWorksOfyouChiVC ()


@property(nonatomic, strong)YCWorksOfyouChiVM *viewModel;
@end

@implementation YCWorksOfyouChiVC
@synthesize viewModel;



- (void)dealloc{
//ok
}

- (void)onUpdateCell:(YCChihuoyingCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    
    cell.actions.ButtonType = YCButtonTypeDelete;
    [super onUpdateCell:cell model:model atIndexPath:indexPath];
}

#pragma mark --点赞
- (void)onFavorite:(UIButton *)sender model:(YCChihuoyingM_1_2 *)m indexPath:(NSIndexPath *)indexPath
{
    // 删除随手拍

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除这个随手拍吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    WSELF;
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {

        SSELF;
        [sender executeActivitySignal:[self.viewModel deletetById:m.Id type:YCCheatsTypeYouChi] next:^(id next) {

            SSELF;
            @try {
                [self.viewModel.modelsProxy removeObject:m];

                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

            }
            @catch (NSException *exception) {
                return ;
            }
            @finally {
                ;
            }
            [self showMessage:@"成功啦"];
            [self onSetupEmptyView];
        } error:self.errorBlock completed:nil executing:nil];
    }];

    [av show];
}

- (void)showTabbar
{
    
}


#pragma mark-------下拉刷新方法

- (void)onSetupCell
{
    [super onSetupCell];
}

- (id)onCreateViewModel{
    
    return [YCWorksOfyouChiVM new];
}

- (void)onSetupRefreshControl
{
    
}

-(void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [super onMainSignalExecute:sender];
}

- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        [self.emptyView updateConstraintsImage:@"当前没有收藏随手拍" title:@"您还没有发布过随手拍哦"];
        self.tableView.backgroundView = self.emptyView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
