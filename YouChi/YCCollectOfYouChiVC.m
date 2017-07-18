//
//  YCCollectOfYouChiVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfYouChiVC.h"
#import "YCCollectOfYouChiVM.h"


#import "YCChihuoyingCell.h"
#import "YCChihuoPhotoCell.h"
#import "YCChihuoNubmerCell.h"
#import "YCYouChiDetailVM.h"
#import "YCRecipeDetailVM.h"
#import "YCRecipeDetailVC.h"
#import "YCYouChiDetailVC.h"



@interface YCCollectOfYouChiVC ()

@property(nonatomic, strong)YCCollectOfYouChiVM *viewModel;

@end

@implementation YCCollectOfYouChiVC
@synthesize viewModel;

- (void)dealloc{
//    OK
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showTabbar
{

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (id)onCreateViewModel{
    
    return [YCCollectOfYouChiVM new];
}

#pragma mark - 加载
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    [super onMainSignalExecute:sender];

}

- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        [self.emptyView updateConstraintsImage:@"当前没有收藏随手拍" title:@"当前没有收藏随手拍"];
        self.tableView.backgroundView = self.emptyView;
    }
}

#pragma mark --数据
- (void)onUpdateCell:(YCChihuoyingCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    cell.actions.ButtonType = YCButtonTypeYouChi;
    [super onUpdateCell:cell model:model atIndexPath:indexPath];
    
}


#pragma mark --选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark --点赞
- (void)onFavorite:(UIButton *)sender model:(YCChihuoyingM_1_2 *)m indexPath:(NSIndexPath *)indexPath
{
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定不再收藏这个随手拍吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {

        SSELF;
        [sender executeActivitySignal:[self.viewModel  favoriteById:m.Id isFavorite:NO type:YCCheatsTypeYouChi] next:^(id next) {
            SSELF;
            @try {
                [self.viewModel.modelsProxy removeObjectAtIndex:indexPath.row];

                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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


#pragma mark-------- 上拉加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
}

#pragma mark-------- 下拉刷新
- (void)onSetupRefreshControl
{
    ;
}

#pragma mark-------- 网络加载
- (void)onSetupActivityIndicatorView
{
    [super onSetupActivityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
