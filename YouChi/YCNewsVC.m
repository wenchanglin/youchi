//
//  YCRecommendMsgVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNewsVC.h"
#import "YCSwitchTabControl.h"
#import "YCNewsM.h"
#import "YCNewsCell.h"
#import "YCWebVC.h"


@interface YCNewsVCP ()
{
    ///咨询纪录
    NSInteger _newSelsect;
    
}
@property(nonatomic,strong)YCNewsVC *newsVC;

@end

@implementation YCNewsVCP

- (void)dealloc{
    //    OK
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabControl.backgroundColor = [UIColor whiteColor];
    
}

-(void)onCreachTabViewControl{
    NSArray *titles = @[@{@"推荐":apiGetRecommendNewsList},@{@"最新":apiGetLatestNewsList}];
    NSMutableArray *vcs = [NSMutableArray new];
    
    [titles enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tabControl insertSegmentWithTitle:dict.allKeys.firstObject image:nil];
        
        YCNewsVC *vc = [YCNewsVC new];
        vc.viewModel  = [[YCNewsVM alloc]initWithURL:dict.allValues.lastObject];
        [vcs addObject:vc];
    }];
    self.tabControl.hasBottomLine = YES;
    self.tabControl.normalColor = KBGCColor(@"#535353");
    self.tabControl.selectedColor = KBGCColor(@"#d09356");
    [self.tabVC setViewControllers:vcs animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end







@interface YCNewsVC ()
@property(nonatomic,strong) YCNewsVM *viewModel;
@property(nonatomic,strong) NSArray *viewModels;
@property(nonatomic,assign) NSInteger currentIndex;
@end

@implementation YCNewsVC
@synthesize viewModel;

- (void)dealloc{    //    OK
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = 0;
    [self adjustContentIn:self.tableView];
}

-(void)onSetupCell
{
    [self onRegisterNibName:@"YCNewsCell" Identifier:cell0];
}


#pragma mark-------网络请求
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

#pragma mark --数据
- (void)onUpdateCell:(YCNewsCell *)cell model:(YCNewsList *)model atIndexPath:(NSIndexPath *)indexPath{
    
    [cell update:model atIndexPath:indexPath];
    [cell.bFavorite addTarget:self action:@selector(onFavorite:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --收藏按钮;
- (void)onFavorite:(UIButton *)sender{
    
    YCNewsCell *cell = sender.findTableViewCell;
    
    NSIndexPath *index = [self indexPathForCell:cell];
    
    YCNewsList *m = [self.viewModel modelForItemAtIndexPath:index];
    
    BOOL isFavorite = !m.isFavorite.boolValue;
    
    [sender  executeActivitySignal:[self.viewModel favoriteById:m.Id  isFavorite:isFavorite type:YCCheatsTypeNews] next:^(NSNumber *next) {
        //  当收藏数是 0 时 显示 收藏， 当收藏数>0时显示 已收藏（999）；
        NSString *btnTitle;
        btnTitle = !isFavorite?@"收藏":@"已收藏";
        
        btnTitle = next.intValue ==0 ?@"收藏":[NSString stringWithFormat:@"%@(%@)",btnTitle,next];
        [sender setTitle:btnTitle forState:UIControlStateNormal];
        m.isFavorite = @(isFavorite);
        m.moreFavoriteCount = [next integerValue]>9999?@"9999+":[NSString stringWithFormat:@"%@",next];
        
    } error:self.errorBlock completed:nil executing:nil];
}

#pragma mark-------点就单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCNewsList *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    NSString *url = [NSString stringWithFormat:@"%@informaction.html?id=%@",html_share,m.Id];
    YCWebVM *vm = [[YCWebVM alloc]initWithUrl:url];
    vm.shareUrl =  [NSURL URLWithString:url];
    vm.shareImageUrl = m.imagePath;
    
    [self pushTo:[YCWebVC class] viewModel:vm hideTabBar:YES];
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}


#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    [super onSetupRefreshControl];
}
- (void)onSetupActivityIndicatorView
{
    [super onSetupActivityIndicatorView];
}

- (void)onSetupFooter
{
    [super onSetupFooter];
}

- (void)onSetupEmptyView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self onScrollToBottom:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
