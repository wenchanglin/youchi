//
//  YCMySecretBookVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCWorksRecipeVC.h"
#import "YCWorksRecipeVM.h"

#import "YCChihuoyingCell.h"
#import "YCCommentControl.h"

#import "YCYouChiDetailVM.h"
#import "YCYouChiDetailVC.h"
#import "YCRecipeDetailVC.h"
#import "YCMaterialVC.h"
#import "YCRecipeStepListVC.h"

#import "YCCommentControl.h"
@interface YCWorksRecipeVC ()
@property(nonatomic,strong)YCWorksRecipeVM *viewModel;

@end

@implementation YCWorksRecipeVC
@synthesize viewModel;
-(void)dealloc{
    //    ok
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)showTabbar
{
    
}

- (void)onSetupCell
{
    [super onSetupCell];
}

- (id)onCreateViewModel{
    
    return [YCWorksRecipeVM new];
}


-(void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [super onMainSignalExecute:sender];
}

- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        [self.emptyView updateConstraintsImage:@"当前没有收藏秘籍" title:@"您还没有发布过自己的美食哟"];
        self.tableView.backgroundView = self.emptyView;
    }
}


- (void)onUpdateCell:(YCChihuoyingCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    
    cell.actions.ButtonType = YCButtonTypeMore;
    [super onUpdateCell:cell model:model atIndexPath:indexPath];
    cell.actions.favorite.selected = NO;
}




#pragma mark --赞、评论、更多
- (void)onFavorite:(UIButton *)sender model:(YCChihuoyingM_1_2 *)m indexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑秘籍",@"删除秘籍", nil];
    WSELF;
    [[actionSheet.rac_buttonClickedSignal ignore:@(actionSheet.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
        SSELF;
        switch (x.intValue) {
            case 0:
            {
                /// 未完成
                YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:m.Id];
                [self executeSignal:vm.mainSignal next:^(id next) {
                    YCMaterialVM *mvm = [[YCMaterialVM alloc] initWithId:m.Id];
                    mvm.isEditMode = YES;
                    mvm.editRecipeDetailVM = vm;
                    [mvm updateMyData:next];

                    [self pushTo:[YCMaterialVC class] viewModel:mvm];
                } error:self.errorBlock completed:nil executing:^(BOOL isExecuting) {
                    if (isExecuting) {
                        [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
                    } else {
                        [SVProgressHUD dismiss];
                    }
                }];

                break;
            }
            case 1:
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除这个秘籍吗？" delegate:nil cancelButtonTitle:@"下次再删" otherButtonTitles:@"残忍删除", nil];
                
                [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
                    
                    [self executeSignal:[self.viewModel deletetById:m.Id type:YCCheatsTypeRecipe] next:^(id next) {
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
                        
                    } error:self.errorBlock completed:nil executing:self.executingBlock];
                    
                }];
                
                [av show];
            }
                break;
        }
    }];
    [actionSheet showInView:self.view];



}


#pragma mark -选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc] initWithId:m.Id];
    [self pushTo:[YCRecipeDetailVC class] viewModel:vm];
    
}

//上拉加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}
//下拉刷新
- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupActivityIndicatorView
{
    [super onSetupActivityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
