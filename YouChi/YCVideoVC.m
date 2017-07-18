//
//  YCVideoVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCVideoVC.h"

#import "YCSwitchTabControl.h"
#import "YCVideosDetailVC.h"
#import "AppDelegate.h"
#import "YCVideoM.h"
#import "YCVideoCell1.h"
#import "YCVideoCell.h"
#import "YCRecipeDetailVC.h"


#import "YCVideoCell.h"



@interface YCVideoVCP ()
@property(nonatomic,strong)YCVideoVC *videoVC;

@end

@implementation YCVideoVCP

- (void)dealloc{
    
    // OK
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabControl.backgroundColor = [UIColor whiteColor];
}

-(void)onCreachTabViewControl{
    NSArray *titles = @[@{@"推荐":apiGetRecommendList},@{@"最新":apiGetLatestVideoList}];
    NSMutableArray *vcs = [NSMutableArray new];
    
    [titles enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tabControl insertSegmentWithTitle:dict.allKeys.firstObject image:nil];
        
        YCVideoVC *vc = [YCVideoVC vcClass:[YCDiscoverVC class]vcId:@"YCVideoVC"];
        vc.viewModel  = [[YCVideoVM alloc]initWithURL:dict.allValues.lastObject];
        [vcs addObject:vc];
    }];
    self.tabControl.hasBottomLine = YES;
    self.tabControl.normalColor = KBGCColor(@"#535353");
    self.tabControl.selectedColor = KBGCColor(@"#535353");
    
    [self.tabVC setViewControllers:vcs animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end






@interface YCVideoVC ()
@property(strong,nonatomic)YCVideoVM *viewModel;
@property(nonatomic,strong) NSArray *viewModels;

@end
@implementation YCVideoVC
@synthesize viewModel;
- (void)dealloc{

// OK
}
#pragma mark --生命周期



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 0;
    [self adjustContentIn:self.tableView];
    
}
- (void)onSetupCell
{
    [self onRegisterNibName:@"YCVideoCell1" Identifier:cell1];
    [self onRegisterNibName:@"YCVideoCell" Identifier:cell2];
    
}



#pragma mark-------刷新推荐
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
}


#pragma mark --数据
- (void)onUpdateCell:(UITableViewCell *)cell model:(YCVideoM *)model atIndexPath:(NSIndexPath *)indexPath{
    [cell update:model atIndexPath:indexPath];
    
    if (indexPath.row > 0) {
        if (model) {
           NSArray *array = (NSArray *)model;
            YCVideoCell *videoCell = (id)cell;
            videoCell.videRightView.hidden = YES;
            videoCell.videLeftView.hidden = YES;
            for (int i = 0; i<array.count; i++)
            {
                YCVideoM *m = array[i];
                YCVideoView *  videView = [cell viewByTag:1+i];
                [videView onUpdataBtnImage:IMAGE_HOST_NOT_SHOP_(m.imagePath) content:m.title];
                [videView addTarget:self action:@selector(onVideoDetail:) forControlEvents:UIControlEventTouchUpInside];
                
                videView.hidden = NO;
                
            }
        }
    }
    
    
}
#pragma mark --选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YCVideoM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
       [self onPushToModel:m];
    }
}

-(void)onVideoDetail:(YCVideoView *)sender
{
    UITableViewCell *cell = [sender findTableViewCell];
    NSIndexPath *indexPath =[self indexPathForCell:cell];
    NSInteger num = sender.tag == 1 ? 2*indexPath.row - 1 : 2*indexPath.row;
    YCVideoM *m = self.viewModel.modelsProxy[num];
    [self onPushToModel:m];
}

-(void)onPushToModel:(id)model
{
    YCVideosDetailVM *vm = [[YCVideosDetailVM alloc]initWithModel:model recommends:self.viewModel.modelsProxy];
    vm.isUpdate = NO;
    vm.previousModel = model;
    vm.urlString = self.viewModel.urlString;
    [self pushTo:[YCVideosDetailVC class] viewModel:vm hideTabBar:YES];
}

////下拉刷新
- (void)onSetupRefreshControl
{
    [super onSetupRefreshControl];
}
- (void)onSetupActivityIndicatorView{
}

- (void)onSetupFooter{
    [super onSetupFooter];
}
- (void)onSetupEmptyView{
    [super onSetupEmptyView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self onScrollToBottom:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
