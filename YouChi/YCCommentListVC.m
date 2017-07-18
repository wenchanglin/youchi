//
//  YCCommentListVC.m
//  YouChi
//
//  Created by 李李善 on 15/9/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCChihuoCommentCell.h"
#import "YCCommentListVC.h"
#import "YCOthersInfoVC.h"
#import "YCDetailControlVCP.h"
#import "YCInputVC.h"

@interface YCCommentListVC ()
PROPERTY_STRONG_VM(YCCommentListVM);
@end

@implementation YCCommentListVC
SYNTHESIZE_VM;
- (void)dealloc{
    //    OK
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论列表";
}

-(void)onSetupCell
{   UINib *bib =[UINib nibWithNibName:@"YCChihuoCommentCell" bundle:nil];
    [self.tableView registerNib:bib forCellReuseIdentifier:cell0];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
}

-(void)onUpdateCell:(YCChihuoCommentCell *)cell model:(YCCommentM *)model atIndexPath:(NSIndexPath *)indexPath{
    [cell updateComment:model];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.avatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCCommentM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"删除", nil];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WSELF;
    [[actionSheet.rac_buttonClickedSignal ignore:@(actionSheet.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
        SSELF;
        
        NSInteger buttonIndex = x.integerValue;
        
        if (buttonIndex == 0) {
            ///回复评论
            YCInputVM *vm = [YCInputVM new];
            vm.title = @"评论";
            vm.viewModel = self.viewModel;
            
            self.viewModel.selectedModel = m;
            [self pushTo:[YCInputVC class] viewModel:vm];
        }
        
        else if (buttonIndex == 1) {
            
            
            [[self.viewModel deleteCommentById:m.Id type:self.viewModel.type].deliverOnMainThread subscribeNext:^(id x) {
                SSELF;
                ///删除评论
                @try {
                    [self.viewModel.modelsProxy removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }
                @catch (NSException *exception) {
                    return ;
                }
                @finally {
                    ;
                }
                [self showMessage:@"删除成功"];
                
            } error:self.errorBlock completed:self.completeBlock];
        }
    }];
    [actionSheet showInView:cell];
}

#pragma mark -头像
- (void)onAvatar:(YCAvatar *)sender
{
    UITableViewCell *cell = sender.findTableViewCell;
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:m.userId];
    [self pushTo:[YCOthersInfoVC class] viewModel:vm];
}

/////网络加载
- (void)onSetupActivityIndicatorView{
    [super onSetupActivityIndicatorView];
}
- (void)onSetupRefreshControl{
    ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
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
