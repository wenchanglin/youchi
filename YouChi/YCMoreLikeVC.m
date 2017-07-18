//
//  YCVideoMoreLikeVC.m
//  YouChi
//
//  Created by 朱国林 on 15/9/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMoreLikeVC.h"
#import "YCMoreLikeVM.h"
#import "YCChihuoyingM.h"
#import "YCFollowsM.h"
#import "YCOthersInfoVM.h"
#import "YCOthersInfoVC.h"
#import "YCMoreLikeM.h"

@interface YCMoreLikeVC ()
PROPERTY_STRONG_VM(YCMoreLikeVM);


@end

@implementation YCMoreLikeVC
@synthesize viewModel;
- (void)dealloc{
    //    OK
}

- (void)viewDidLoad {
    [super viewDidLoad];

    RAC(self,title) = RACObserve(self.viewModel, title).deliverOnMainThread;
}

- (id)onCreateViewModel{
    
    return [YCMoreLikeVM new];
}


///下拉刷新
- (void)onSetupRefreshControl
{
    ;
}
///网络加载
- (void)onSetupActivityIndicatorView
{
    [super onSetupActivityIndicatorView];
}

//上拉加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self onScrollToBottom:scrollView];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
}

#pragma mark --数据
- (void)onUpdateCell:(UITableViewCell *)cell model:(YCMoreLikeM *)m atIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView *icon = [cell viewByTag:1];
    UILabel *name = [cell viewByTag:2];
    UILabel *time = [cell viewByTag:3];

    [icon ycNotShop_setImageWithURL:m.userImage?:m.userImagePath placeholder:AVATAR_LITTLE];

    name.text = m.userName;
    time.text = m.createdDate;
}


#pragma mark --选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCMoreLikeM *m = [self.viewModel modelForItemAtIndexPath:indexPath];

    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc] initWithId:m.userId];
    
    [self pushTo:[YCOthersInfoVC class] viewModel:vm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
