//
//  YCNotificationVC.m
//  YouChi
//
//  Created by 李李善 on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNotificationVC.h"
#import "YCNotificationVM.h"
#import "YCNotificationCell.h"

#import "NSString+MJ.h"

#import "YCNotificationM.h"
#import "YCWebVC.h"

@interface YCNotificationVC ()
PROPERTY_STRONG_VM(YCNotificationVM);
@end

@implementation YCNotificationVC
SYNTHESIZE_VM;
-(void)dealloc{
    //    ok
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(id)onCreateViewModel
{
    return [YCNotificationVM new];
}


- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    YCNotificationM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
//    YCWebVM *vm = [YCWebVM new];
//    vm.url = [NSURL URLWithString:m.originalAction];
//    [self pushTo:[YCWebVC class] viewModel:vm];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    
}


#pragma mark------下拉刷新，上拉加载
- (void)onSetupRefreshControl
{
    ;
}
- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0]==0) {
        self.tableView.backgroundView = self.emptyView;
        self.emptyView.emptyLabel.text = @"没有通知";
    } else {
        self.tableView.backgroundView = nil;
        
    }
}

- (void)onSetupActivityIndicatorView
{
    [super onSetupActivityIndicatorView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
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
