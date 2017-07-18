//
//  YCMyNewsOfCVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfNewsVC.h"
#import "YCCollectOfNewsVM.h"

#import "YCNewsM.h"
#import "YCNewsCell.h"
#import "YCWebVC.h"


@interface YCCollectOfNewsVC ()

@property(nonatomic,strong)YCCollectOfNewsVM *viewModel;

@end

@implementation YCCollectOfNewsVC
@synthesize viewModel;
- (void)dealloc{
    //    OK
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)onSetupCell
{
    [super onSetupCell];
}

- (id)onCreateViewModel {
    return [YCCollectOfNewsVM new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .2;
}

#pragma mark --设置表头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

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
         [self.emptyView updateConstraintsImage:@"当前没有咨询" title:@"当前没有收藏资讯"];
        self.tableView.backgroundView = self.emptyView;
    }
}

#pragma mark --收藏按钮;
- (void)attention:(UIButton *)sender
{

    YCNewsCell *cell = (id)sender.findTableViewCell;
    
    NSIndexPath *index = [self indexPathForCell:cell];
    
    YCNewsList *m = [self.viewModel modelForItemAtIndexPath:index];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定不再收藏这个资讯了吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    NSInteger idx = av.cancelButtonIndex;

    WSELF;
    [[av.rac_buttonClickedSignal ignore:@(idx)]subscribeNext:^(id x) {
        SSELF;
        
        UITableViewCell *cell = sender.findTableViewCell;
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        
        [sender executeActivitySignal:[self.viewModel favoriteById:m.Id  isFavorite:NO type:YCCheatsTypeNews] next:^(id next) {
            
            
            @try {
                [self.viewModel.modelsProxy removeObjectAtIndex:indexPath.row];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
