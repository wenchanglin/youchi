//
//  YCMyVideoOfCVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfVideoVC.h"
#import "YCCollectOfVideoVM.h"
#import "YCAvatarControl.h"

#import "YCVideoM.h"
#import "AppDelegate.h"
#import "YCVideosDetailVM.h"
#import "YCMyVidieoCell.h"
#import "YCVideosDetailVC.h"

@interface YCCollectOfVideoVC ()
@end

@implementation YCCollectOfVideoVC
- (void)dealloc{
    //    OK
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)showTabbar
{
    
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
}

- (void)onSetupCell
{
    UINib *nib0 = [UINib nibWithNibName:@"YCMyVidieoCell" bundle:nil];
    [self.tableView registerNib:nib0 forCellReuseIdentifier:cell0];
}

- (id)onCreateViewModel{
    
    return [YCCollectOfVideoVM new];
}


#pragma mark - 加载
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    WSELF;
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:^{
        SSELF;
        [self onSetupEmptyView];
        
    } executing:self.executingBlock];
    
}

- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        [self.emptyView updateConstraintsImage:@"当前没有视频" title:@"当前没有收藏视频"];
        self.tableView.backgroundView = self.emptyView;
    }
}

- (void)onUpdateCell:(YCMyVidieoCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    [cell update:model atIndexPath:indexPath];
    [cell.btnAttention addTarget:self action:@selector(onFavorite:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    cell.view.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .2;
}

#pragma mark --设置表头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

#pragma mark --收藏
- (void)onFavorite:(UIButton *)sender
{

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定不再收藏这个视频了吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    NSInteger idx = av.cancelButtonIndex;

    WSELF;
    [[av.rac_buttonClickedSignal ignore:@(idx)]subscribeNext:^(id x) {

        SSELF;
        UITableViewCell *cell = sender.findTableViewCell;
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        
        YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        
        [sender executeActivitySignal:[self.viewModel favoriteById:m.Id isFavorite:NO type:YCCheatsTypeVideo] next:^(id next) {
            

            SSELF;
            @try {
                [self.viewModel.modelsProxy removeObjectAtIndex:indexPath.row];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCVideoM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    YCVideosDetailVM *vm = [[YCVideosDetailVM alloc]initWithModel:m recommends:nil];
    vm.urlString =apiGetRecommendList;
    vm.isUpdate = YES;
    [self pushTo:[YCVideosDetailVC class] viewModel:vm hideTabBar:YES];
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

- (void)onSetupFooter
{
    self.tableView.tableFooterView = self.loadControl;
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
