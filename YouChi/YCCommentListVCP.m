//
//  YCCommentListVC.m
//  YouChi
//
//  Created by ZhiMin Deng on 15/6/14.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommentListVCP.h"
#import "YCCommentM.h"
//#import "YCCommentListVM.h"
//#import "YCAvatarControl.h"

@interface YCCommentListVCP ()
@end

@implementation YCCommentListVCP

#pragma mark -
- (void)dealloc{
    //ok
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论列表";
    
  
}



- (IBAction) menuItem1Pressed:(id)sender{
//    txtInputLabel.text = @"01";
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
//- (id)onCreateViewModel
//{
//    return  [YCCommentListVM new];
//}

#pragma mark -
- (void)onSetupRefreshControl
{
    ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
      [cell becomeFirstResponder];
    UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"Flag"action:@selector(flag:)];
    UIMenuItem *approve = [[UIMenuItem alloc] initWithTitle:@"Approve"action:@selector(approve:)];
    UIMenuItem *deny = [[UIMenuItem alloc] initWithTitle:@"Deny"action:@selector(deny:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:[NSArray arrayWithObjects:flag, approve, deny, nil]];
    
    [menu setTargetRect:cell.frame inView:cell.superview];
    
    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    NSLog(@">>>%@",cell.superview);
    NSLog(@"%@",cell.superview.subviews);
       [menu setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}
//这么重要的一句话没有加，OK，下面就是你所要使用的方法了
- (void)flag:(id)sender {
    
    NSLog(@"Cell was flagged");
    
}
- (void)approve:(id)sender {
    
    NSLog(@"Cell was approved");
}

- (void)deny:(id)sender {
    
    NSLog(@"Cell was denied");
    
}

//- (void)onMainSignalExecute:(UIRefreshControl *)sender
//{
//    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
//}

//- (void)onUpdateCell:(UITableViewCell *)cell model:(YCCommentM *)model atIndexPath:(NSIndexPath *)indexPath
//{
//    YCAvatarControl *touxiang = [cell viewByTag:1];
//    UILabel *miaoshu = [cell viewByTag:2];
//    [touxiang updateComment:model];
//    miaoshu.text = model.comment;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self onScrollToBottom:scrollView];
//}

/*
- (IBAction)onTapAvatar:(YCAvatarControl *)sender {
  
    UITableViewCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCCommentM *m = [self.viewModel modelForItemAtIndexPath:index];
    [sender executeSignal:[self.viewModel getUserInfo:m.userId] next:^(id next) {
        self.userInfoVC.viewModel.user = next;
    } error:self.errorBlock completed:nil executing:self.executingBlock];
    [self.userInfoVC showSlideMenuFrom:UIPopoverArrowDirectionDown];

}
 */



///回复
- (IBAction)onRevert:(id)sender {

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
