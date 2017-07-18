//
//  YCCommentVC.m
//  YouChi
//
//  Created by sam on 15/5/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommentVC.h"
#import "YCCommentVM.h"
#import "YCWebVC.h"
#import "YCOthersInfoVC.h"
#import "YCRecipeDetailVC.h"
#import "YCYouChiDetailVC.h"
#import "YCNewsVC.h"

#import "YCVideosDetailVC.h"


#import "YCInputVC.h"
#import "YCCommentCell.h"

@interface YCCommentVC()
PROPERTY_STRONG_VM(YCCommentVM);
@end


@implementation YCCommentVC
SYNTHESIZE_VM;
- (void)dealloc{
    //ok
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
  
}
-(id)onCreateViewModel
{
    return [YCCommentVM new];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0]==0) {
        self.tableView.backgroundView = self.emptyView;
        self.emptyView.emptyLabel.text = @"没有评论";
    } else {
        self.tableView.backgroundView = nil;
        
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YCUserCommentM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    NSNumber *targetId = m.targetBody.Id;
    YCOriginalType type = m.originalType.intValue;
    
    switch (type) {
        case YCOriginalTypeUrl:
        {
            YCWebVM *vm = [[YCWebVM alloc]initWithUrl:m.url];
            
            [self pushTo:[YCWebVC class] viewModel:vm];
        }
            break;
        case YCOriginalTypeUser:
        {
            YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:targetId];
            [self pushTo:[YCOthersInfoVC class] viewModel:vm];
        }
            break;
        case YCOriginalTypeRecipe:
        {
            YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:targetId];
            [self pushTo:[YCRecipeDetailVC class] viewModel:vm];
        }
            break;
        case YCOriginalTypeMaterial:
        {
            YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:targetId];
            [self pushTo:[YCRecipeDetailVC class] viewModel:vm];
        }
            break;
        case YCOriginalTypeItem:
        {
            YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:targetId];
            [self pushTo:[YCRecipeDetailVC class] viewModel:vm];
        }
            break;
        case YCOriginalTypeYouChi:
        {
            YCYouChiDetailVM *vm = [[YCYouChiDetailVM alloc]initWithYouChiId:targetId];
            [self pushTo:[YCYouChiDetailVC class] viewModel:vm];
        }
            break;
        case YCOriginalTypeNews:
        {
            YCNewsVM *vm = [[YCNewsVM alloc]initWithId:targetId];
            [self pushTo:[YCNewsVC class] viewModel:vm];
        }
            break;
        case YCOriginalTypeVideo:
        {
            YCVideosDetailVM *vm = [[YCVideosDetailVM alloc]initWithId:targetId];
            [self pushTo:[YCVideosDetailVC class] viewModel:vm];
        }
            break;
        default:
            break;
    }
    
}

- (void)onUpdateCell:(YCCommentCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    [cell update:model atIndexPath:indexPath];
    [cell.avatarControl addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
}


- (IBAction)onRevert:(UIButton *)sender {
    UITableViewCell *cell = sender.findTableViewCell;
    NSIndexPath *indePath = [self indexPathForCell:cell];
    id m = [self.viewModel modelForItemAtIndexPath:indePath];
    YCInputVM *vm = [YCInputVM new];
    vm.title = @"评论";
    
    self.viewModel.selectedModel = m;
    vm.viewModel = self.viewModel;
    
    [self pushTo:[YCInputVC class] viewModel:vm];
}

#pragma mark -头像
- (void)onAvatar:(YCAvatarControl *)sender
{
    UITableViewCell *cell = sender.findTableViewCell;
    YCUserCommentM *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:m.pushUserId];
    [self pushTo:[YCOthersInfoVC class] viewModel:vm];
}

- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupActivityIndicatorView
{
    [super onSetupActivityIndicatorView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    
}


 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     [segue.destinationViewController setValue:self.viewModel forKey:KP(self.viewModel)];
 }
 



@end





