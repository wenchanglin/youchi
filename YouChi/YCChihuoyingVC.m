  //
//  YCChihuoyingVC.m
//  YouChi
//
//  Created by sam on 15/5/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCChihuoyingVC.h"

#import "YCYouChiDetailVC.h"
#import <Masonry/Masonry.h>
#import "YCPhotosView.h"
#import "YCRandomPicturesVC.h"

#import "YCCommentControl.h"
#import "YCWebVC.h"

#import "YCChihuoyingCell.h"

#import "YCFindChihuoCell.h"

///详细界面
#import "YCYouChiDetailVC.h"
#import "YCRecipeDetailVC.h"

#import "UIViewController+Action.h"
#import "YCProfileView.h"
#import "YCPersonalProfileVC.h"
#import "YCChihuoPhotoCell.h"
#import "YCChihuoNubmerCell.h"
#import "YCOthersInfoVC.h"

///搜索
#import "YCSearchDetailVC.h"

#import "YCMessageVC.h"
#import <YQBadgeCategory/UIView+WZLBadge.h>
#import "YCSignInView.h"



#import "YCPushManager.h"
#import "WXApi.h"
#import "ApiXml.h"

#import "YCCellManager.h"
#import "YCCellManagerFrame.h"
@interface YCChihuoyingVCP ()
{
    UITabBarController *_tbc;
}
@property (weak, nonatomic) IBOutlet YCSwitchTabControl *tabControl;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@end

@implementation YCChihuoyingVCP
- (void)dealloc{
    //ok
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    WSELF;
    [self _onSetupTab];
    
    NSArray *urls = @[apiCGetRecommendPageList,apiCGetFollowUserYouchi];
    
    for (int n = 0; n<urls.count; n++) {
        YCChihuoyingVCP *vc = _tbc.viewControllers[n];
        YCChihuoyingVM *vm = [[YCChihuoyingVM alloc]initWithURL:urls[n]];
        vc.viewModel = vm;
    }
    
    
    ///登录刷新
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCUserDefaultUpdate object:nil].deliverOnMainThread subscribeNext:^(id x) {
        SSELF;
        if (self.tabControl.selectedSegmentIndex!=0) {
            [self.tabControl segmentLineScrollToIndex:0 animate:NO];
            [self onSwitchController:self.tabControl];
        }
        
    }];

    
    [RACObserve(PUSH_MANAGER, hasNewMessage) subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [self.btnMessage showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeShake];
        } else {
            [self.btnMessage clearBadge];
        }
    }];
    
    
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITabBarController *tbc = segue.destinationViewController;
    tbc.tabBar.hidden = YES;
    _tbc = tbc;
}

-(void)_onSetupTab{
    [self.tabControl insertSegmentWithTitle:@"推荐" image:nil];
    [self.tabControl insertSegmentWithTitle:@"关注" image:nil];
    UIColor *golden = [UIColor colorWithHexString:@"#be8f59"];
    self.tabControl.segmentLineColor = golden;
    [self.tabControl setSelectedColor:golden];
    [self.tabControl addTarget:self action:@selector(onSwitchController:) forControlEvents:UIControlEventValueChanged];
}

- (void)onSwitchController:(YCSwitchTabControl *)sender{
  
    if ((sender.selectedSegmentIndex == 1) && [self pushToLoginVCIfNotLogin]) {
        [sender segmentLineScrollToIndex:0 animate:NO];
        return;
    }
    [sender segmentLineScrollToIndex:sender.selectedSegmentIndex animate:YES];
    _tbc.selectedIndex =sender.selectedSegmentIndex;
    
}


#pragma mark - 搜索
- (IBAction)onSearch:(id)sender {
    [self hideTabbar];
    
    YCSearchVC *vc = [YCSearchVC vcClass:[YCSearchVC class]];
    ///根据什么不同的类型跳转不同的二级界面
    vc.searchType = isSearchTypeOther;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 消息
- (IBAction)message:(id)sender {
    if ([self pushToLoginVCIfNotLogin]) {
        return;
    }
    
    PUSH_MANAGER.hasNewMessage = NO;
    
    
    
    [self pushTo:[YCMessageVC class]];

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


@interface YCChihuoyingVC ()
@property (nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,strong) YCChihuoyingVM *viewModel;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) AFNetworkReachabilityStatus netState;
@end


@implementation YCChihuoyingVC
@synthesize viewModel;

#pragma mark - 生命周期

- (void)dealloc
{
//    ok
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.scrollsToTop = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.scrollsToTop = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WSELF;
    ///登录刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReload:) name:YCUserDefaultUpdate object:nil];

    
    
    
    ///点赞收藏更新
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCClickNotification object:nil] subscribeNext:^(NSNotification *x) {
        SSELF;
        id m = x.object;
    
        if (m && [self.viewModel.modelsProxy containsObject:m]) {
            NSIndexPath *index = [self.viewModel indexPathOfModel:m];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
            [cell update:m atIndexPath:index];
        }
    }];
    
    [self adjustContentIn:self.tableView];
 }
 


- (void)onSetupCell{
    UINib *nib1 = [UINib nibWithNibName:@"YCChihuoNubmerCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:cell1];
    
    UINib *nib0 = [UINib nibWithNibName:@"YCChihuoPhotoCell" bundle:nil];
    [self.tableView registerNib:nib0 forCellReuseIdentifier:cell2];
    
}


- (void)onConfigureCell:(YCChihuoyingCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{

    if ([cell isKindOfClass:[YCChihuoyingCell class]]) {

        [cell.actions addTarget:self action:@selector(onLikeOrShare:) forControlEvents:UIControlEventValueChanged];
    }
    
    if([cell isKindOfClass:[YCChihuoPhotoCell class]]){
        YCChihuoPhotoCell *c = (id)cell;
        
        [c.avatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([cell isKindOfClass:[YCChihuoNubmerCell class]]) {
        
        YCChihuoNubmerCell *c = (id)cell;
        [c.avatarControl addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
        @weakify(self,c);
        c.photosView.selectBlock = ^(NSIndexPath *ip,id model){
            @strongify(self,c);
            UITableViewCell *wcell = c;
            NSIndexPath *idp = [self indexPathForCell:wcell];
            [self tableView:self.tableView didSelectRowAtIndexPath:idp];
        };
        
        [c.relativeView addTarget:self action:@selector(onSelectRelativeImage:) forControlEvents:UIControlEventValueChanged];
        [c.btnMore addTarget:self action:@selector(onMoreRecipe:) forControlEvents:UIControlEventTouchUpInside];
    }

     //*/
    if ([cell isKindOfClass:[YCFindChihuoCell class]]) {
        YCFindChihuoCell *c = (id)cell;

        UINib *nib = [UINib nibWithNibName:@"YCRecommandUsersCell" bundle:nil];
        [c.usersView registerNib:nib forCellReuseIdentifier:cell0];

        c.usersView.scrollEnabled = NO;
        c.usersView.rowHeight = 58.f;
        c.usersView.backgroundColor = [UIColor clearColor];
        c.usersView.separatorStyle = UITableViewCellSeparatorStyleNone;
        c.usersView.opaque = YES;


        WSELF;
        c.usersView.updateBlock = ^(UITableViewCell *cell,YCMeM *m) {
            SSELF;
            YCAvatarControl *ac = [cell viewByTag:1];
            UIButton *btn = [cell viewByTag:2];
            
            [ac updateAvatarControlWith:m.imagePath name:m.nickName sign:m.signature];
            btn.selected = m.isFollow.boolValue;

            [ac addTarget:self action:@selector(onRecommandAvatar:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(onRecommandFollow:) forControlEvents:UIControlEventTouchUpInside];
        };


        UIColor *normal = KBGCColor(@"272636");
        UIColor *select = KBGCColor(@"e3e3e3");
        [c.findGuy setTitleColor:normal forState:UIControlStateNormal];
        [c.changeOthers setTitleColor:normal forState:UIControlStateNormal];
        [c.findGuy setTitleColor:select forState:UIControlStateSelected];
        [c.changeOthers setTitleColor:select forState:UIControlStateSelected];

        [c.findGuy setNormalBgColor:nil selectedBgColor:nil highLightedBgColor:[UIColor lightGrayColor]];
        [c.changeOthers setNormalBgColor:nil selectedBgColor:nil highLightedBgColor:[UIColor lightGrayColor]];
        

    }


    WSELF;
    [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
        SSELF;
        id model = [self.viewModel modelForItemAtIndexPath:indexPath];
        if (![cell checkIsHasSetData:model]) {
            [self onUpdateCell:cell model:model atIndexPath:indexPath];
        }
    }];
    
}

#pragma mark - 加载
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:self.viewModel.mainSignal next:^(NSArray *next) {
        self.nextBlock(next);
    
        
    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    self.isFirstLoad = NO;
}

- (void)onReload:(UIRefreshControl *)sender{

    self.executingBlock(NO);
    self.viewModel.pageInfo.status = YCLoadingStatusRefresh;
    [self onMainSignalExecute:nil];
   
}


 #pragma mark --选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];

    YCCheatsType type = m.youchiType.intValue;
    if (type == YCCheatsTypeAd) {
        YCWebVM *vm = [[YCWebVM alloc]initWithUrl:m.originalAction];
        
        [self pushTo:[YCWebVC class] viewModel:vm];
    }

    else if (type == YCCheatsTypeYouChi) {
        YCYouChiDetailVM *vm = [[YCYouChiDetailVM alloc]initWithYouChiId:m.Id];
        vm.title = m.materialName;
        vm.previousModel = m;
        vm.lickCount = m.likeCount;
        [self pushTo:[YCYouChiDetailVC class] viewModel:vm];
        
    }
    
    else if (type == YCCheatsTypeRecipe) {
        YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:m.Id];
        vm.title = m.name;
        vm.previousModel = m;
        [self pushTo:[YCRecipeDetailVC class] viewModel:vm];
        
    }
}



#pragma mark --找吃货
- (void)onFindChiHuo:(UIButton *)sender {
    UIViewController *vc = [UIViewController vcClass:[YCSearchVC class] vcId:NSStringFromClass([YCSearchDetailVCP class])];
    YCSearchDetailVM *vm = [YCSearchDetailVM new];
    vm.isSearch = NO;
    vc.viewModel = vm;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --换一批
- (void)onChangeChiHuo:(UIButton *)sender {
    YCFindChihuoCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];

    
    [sender executeActivitySignal:[self.viewModel onChangeGuysSignal:index] next:^(NSArray *next) {
        cell.usersView.photos = next;
        [cell.usersView reloadData];
        sender.selected = NO;
    } error:self.errorBlock completed:nil executing:nil];
}

#pragma mark --点赞、分享
- (void)onLikeOrShare:(YCCommentControl *)sender {
    YCChihuoyingCell *cell = sender.findTableViewCell;
    NSIndexPath *index = [self indexPathForCell:cell];
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:index];
    
    if (sender.selectedIndex == 0) {
        UIButton *button = sender.like;
        [button executeActivitySignal:[self.viewModel  likeByByModel:m] next:^(NSNumber *likeCount) {
            [sender updateWithModel:m];
            if ([cell respondsToSelector:@selector(likeCount)]) {
                [cell.likeCount updateLikeCount:likeCount.intValue];
            }
        } error:self.errorBlock completed:nil executing:nil];
    }
    else if (sender.selectedIndex == 1) {
        
        YCCheatsType type = m.youchiType.intValue;

        if (type == YCCheatsTypeYouChi) {
            YCYouChiDetailVM *vm = [[YCYouChiDetailVM alloc]initWithYouChiId:m.Id];
            vm.title = m.materialName;
            vm.previousModel = m;
            vm.shouldOpenCommentKeyboard = YES;

            [self pushTo:[YCYouChiDetailVC class] viewModel:vm];
        }

        else if (type == YCCheatsTypeRecipe) {
            YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:m.Id];
            vm.title = m.name;
            vm.previousModel = m;
            vm.shouldOpenCommentKeyboard = YES;

            [self pushTo:[YCRecipeDetailVC class] viewModel:vm];
        }
    }
    else if (sender.selectedIndex == 2) {

        UIButton *button = sender.favorite;
        [self onFavorite:button model:m indexPath:index];

    }
    
}

#pragma mark -- 用户详细信息
- (void)onAvatar:(YCAvatarControl *)sender {
    UITableViewCell *cell = sender.findTableViewCell;
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:m.userId];

    [self pushTo:[YCOthersInfoVC class] viewModel:vm];

}

#pragma mark -- 相关秘籍
- (void)onSelectRelativeImage:(YCImageSelectControl *)sender
{
    UITableViewCell *cell = sender.findTableViewCell;
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    NSUInteger selectedIndex = sender.selectedIndex;
    YCBaseImageModel *pm = m.recipeList[selectedIndex];

    YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:pm.Id];
    vm.title = m.name;
    vm.previousModel = pm;
    [self pushTo:[YCRecipeDetailVC class] viewModel:vm];
}

#pragma mark -- 更多秘籍
- (void)onMoreRecipe:(UIButton *)sender
{
    UITableViewCell *cell = sender.findTableViewCell;
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    YCChihuoyingOtherVM *vm = [[YCChihuoyingOtherVM alloc]initWithId:m.Id];
    YCChihuoyingOtherVC *vc = [YCChihuoyingOtherVC vcClass:[YCChihuoyingVC class] vcId:NSStringFromClass([YCChihuoyingOtherVC class])];
    vc.viewModel = vm;
    [self hideTabbar];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击收藏
- (void)onFavorite:(UIButton *)sender model:(YCChihuoyingM_1_2 *)m indexPath:(NSIndexPath *)indexPath
{
    [sender executeActivitySignal:[self.viewModel  favoriteByModel:m] next:^(YCChihuoyingM_1_2 *x) {
        YCCommentControl *comment = (id)sender.superview;
        [comment updateWithModel:m];
    } error:self.errorBlock completed:nil executing:nil];
}

#pragma mark -- 推荐用户关注
-(void)onRecommandFollow:(UIButton *)sender{
    UITableViewCell *innerCell = sender.findTableViewCell;

    YCFindChihuoCell *cell = innerCell.findTableViewCell;
    NSIndexPath *innerIndexPath = [cell.usersView indexPathForCell:innerCell];

    NSIndexPath *indexPath = [self indexPathForCell:cell];
    YCChihuoyingM_1_2 *model = [self.viewModel modelForItemAtIndexPath:indexPath];

    YCMeM *m =  model.userList[innerIndexPath.row];

    BOOL isFollow = !m.isFollow.boolValue;
    [sender executeActivitySignal:[self.viewModel followUserById:m.Id isFollow:isFollow]  next:^(id x) {
        m.isFollow = @(isFollow);
        sender.selected = isFollow;
    } error:self.errorBlock completed:nil executing:nil];

}


#pragma mark -- 推荐用户详细信息
- (void)onRecommandAvatar:(YCAvatarControl *)sender {
    UITableViewCell *innerCell = sender.findTableViewCell;

    YCFindChihuoCell *cell = innerCell.findTableViewCell;
    NSIndexPath *innerIndexPath = [cell.usersView indexPathForCell:innerCell];

    NSIndexPath *indexPath = [self indexPathForCell:cell];
    YCChihuoyingM_1_2 *model = [self.viewModel modelForItemAtIndexPath:indexPath];

    YCMeM *m =  model.userList[innerIndexPath.row];
    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:m.Id];
    [self pushTo:[YCOthersInfoVC class] viewModel:vm];



}
#pragma mark-------下啦上啦刷新表格

- (void)onSetupRefreshControl
{
    [super onSetupRefreshControl];
}

- (void)onSetupActivityIndicatorView
{
    [super onSetupActivityIndicatorView];
}

- (void)onSetupFooter{
    [super onSetupFooter];
}

- (void)onSetupEmptyView{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.backgroundView = self.emptyView;
        self.emptyView.emptyImage.image = IMAGE(@"公仔");
        self.emptyView.emptyLabel.text = @"请检查您的手机是否联网，然后尝试下拉刷新";
        
        if ([self.viewModel.urlString isEqualToString:apiCGetFollowUserYouchi]&&(self.netState > AFNetworkReachabilityStatusNotReachable)) {
            self.tableView.tableFooterView = nil;
            self.emptyView.emptyLabel.text = @"请您先关注其他吃货，才能发现更多美食哦";
        }
    }
    
    else {
        self.tableView.backgroundView = nil;
    }
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self onScrollToBottom:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


@implementation YCChihuoyingOtherVC
-(void)dealloc{
    //    ok
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.viewModel.title;
}
- (void)showTabbar
{
    
}

- (void)onSetupRefreshControl
{
    
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

@end
