//
//  YCSearchDetaiLlistVC.m
//  YouChi
//
//  Created by 李李善 on 15/9/11.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchDetaiLlistVC.h"


#import "YCVideoM.h"
#import "AppDelegate.h"


/**
视频
*/
#import "YCVideosDetailVC.h"
#import "YCMyVidieoCell.h"


/**
其他用户
其他用户界面
*/
#import "YCOthersInfoVC.h"
#import "YCMeM.h"


/**
随手拍
*/
#import "YCYouChiDetailVC.h"
#import "YCChihuoyingCell.h"
#import "YCChihuoPhotoCell.h"
#import "YCChihuoNubmerCell.h"
#import "YCRecipeDetailVC.h"


/**
资讯
*/
#import "YCNewsCell.h"
#import "YCWebVC.h"
#import "YCNewsM.h"

#import "YCSearchDetailOphoneCell.h"
@interface YCSearchDetaiLlistVC ()

@end

@implementation YCSearchDetaiLlistVC


-(void)dealloc{
//    ok
    
}

#pragma mark-----网络请求
- (void)viewDidLoad {
    [super viewDidLoad];

    //YCSearchDetaiLlistVM * viewModel =(id)self.viewModel;
    self.title = @"更多搜索结果";
    //[NSString stringWithFormat:@"所有%@的搜索结果",viewModel.searchText];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
}

-(void)onSetupCell{
    ///工作人员
    UINib *nib = [UINib nibWithNibName:@"YCSearchDetailOphoneCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cell0];
    //*
    ///随手拍
    UINib *nib1 = [UINib nibWithNibName:@"YCChihuoNubmerCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:cell1];
    ///视频
    UINib *nib2 = [UINib nibWithNibName:@"YCMyVidieoCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:cell2];
    ///资讯
    UINib *nib3 = [UINib nibWithNibName:@"YCNewsCell" bundle:nil];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:cell3];
     //*/
}

#pragma mark-----更新数据
-(void)onUpdateCell:(YCSearchDetailOphoneCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    YCSearchDetaiLlistVM *vm = (id)self.viewModel;
    #pragma mark-----吃后更新数据
    if (vm.listType ==YCSearchlistTypeUser) {
        YCLoginUserM *m = (id)model;
        [cell updateIcon:m.imagePath title:m.nickName shouldShowAction:YES isSelected:m.isFollow.boolValue];
        [cell.action addTarget:self action:@selector(onAttention:) forControlEvents:UIControlEventTouchUpInside];
    }
    #pragma mark-----随手拍更新数据
    else if (vm.listType ==YCSearchlistTypePhoto) {
        YCChihuoyingM_1_2 *m = (id)model;
        [cell updateIcon:[m.youchiPhotoList.firstObject imagePath] title:[NSString stringWithFormat:@"%@\n%@",m.materialName,m.desc] shouldShowAction:NO isSelected:NO];
    }
    #pragma mark-----视频更新数据
    else if (vm.listType ==YCSearchlistTypeVideo) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        YCVideoM *m = (id)model;
        YCMyVidieoCell *cell1 =(id)cell;
        [cell1 update:m atIndexPath:indexPath];
        cell1.view.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        [cell1.btnAttention addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
    }
     #pragma mark-----资讯更新数据
    else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        YCNewsCell *cell1 =(id)cell;
        YCNewsList *m = (id)model;
        [cell1 update:m atIndexPath:indexPath];
        [cell1.bFavorite addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}


#pragma mark-----随手拍收藏和图片点击事件
/**
 1:随手拍的Model是YCChihuoyingM_1_2
 2:随手拍 在 self.viewmModel中数组  content
 

 */

-(void)onCommentWithCollect:(YCLeftCommentControl *)sender
{
    YCChihuoyingCell *cell = (id)sender.findTableViewCell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YCSearchDetaiLlistVM *vm = (id)self.viewModel;
    YCChihuoyingM_1_2 *m = [vm modelForItemAtIndexPath:indexPath];//vm.model.content[indexPath.row];
    
    if (sender.selectedIndex == 0) {
        UIButton *button = sender.like;
        BOOL isLike = !m.isLike.boolValue;
        [sender executeActivitySignal:[self.viewModel  likeById:m.Id isLike:isLike type:m.youchiType.intValue] next:^(NSNumber *likeCount) {
            m.isLike  = @(isLike);
            button.selected =  isLike;
//            [self showMessage:isLike?@"已赞":@"取消赞"];
        } error:self.errorBlock completed:nil executing:nil];
    }
    /// 收藏
    else if (sender.selectedIndex == 2) {
        UIButton *button = sender.favorite;
        BOOL isFavorite = !m.isFavorite.boolValue;
        [sender executeActivitySignal:[self.viewModel  favoriteById:m.Id isFavorite:isFavorite type:m.youchiType.intValue] next:^(id x) {
            m.isFavorite  = @(isFavorite);
            button.selected =  isFavorite;
//            [self showMessage:isFavorite?@"已收藏":@"取消收藏"];
        } error:self.errorBlock completed:nil executing:nil];
       }
 }

-(void)onRelativeImageSelect:(YCImageSelectControl *)sender
{
    YCChihuoyingCell *cell = (id)sender.findTableViewCell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YCSearchDetaiLlistVM *viewModel = (id)self.viewModel;
    YCChihuoyingM_1_2 *m =viewModel.model.content[indexPath.row];
    NSUInteger selectedIndex = sender.selectedIndex;
    YCBaseImageModel *pm = m.recipeList[selectedIndex];
    [self hideTabbar];
    YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:pm.Id];
    vm.title = @"秘籍";
    [self pushTo:[YCRecipeDetailVC class] viewModel:vm ];
}


#pragma mark-----视频收藏和资讯收藏
/**
 1:视频的model  ———》YCVideoM    和资讯的Model ----->YCNewsList 不同
 2:视频和资讯 在 self.viewmModel中不同的数组中videoList 和newsList
 */
    //*
-(void)onComment:(UIButton *)sender
{
    YCSearchDetaiLlistVM *viewModel =(id)self.viewModel;
    UITableViewCell *cell = sender.findTableViewCell;
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    BOOL isLike;
    if (viewModel.listType ==YCSearchlistTypeVideo) {
        
        YCVideoM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        isLike =!m.isFavorite.boolValue;
        [sender  executeActivitySignal:[self.viewModel favoriteById:m.Id  isFavorite:isLike type:YCCheatsTypeVideo] next:^(id next) {
            m.isFavorite = @(isLike);
            sender.selected = isLike;
        } error:self.errorBlock completed:nil executing:nil];
    }
    else
    {
        YCNewsList *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        isLike =!m.isFavorite.boolValue;
        [sender  executeActivitySignal:[self.viewModel favoriteById:m.Id  isFavorite:isLike type:YCCheatsTypeNews] next:^(id next) {
            NSString *btnTitle;
            btnTitle = !isLike?@"收藏":@"已收藏";
            
            btnTitle = (![next intValue])?@"收藏":[NSString stringWithFormat:@"%@(%@)",btnTitle,next];
            [sender setTitle:btnTitle forState:UIControlStateNormal];
            m.isFavorite = @(isLike);
            sender.selected = isLike;
            m.moreFavoriteCount =  [next integerValue]>9999?@"9999+":[NSString stringWithFormat:@"%@",next];
        } error:self.errorBlock completed:nil executing:nil];
    }
    
    
    
}

//*/

#pragma mark-----吃货关注
/**
 1:吃货的Model是YCMeM
 2:吃货 在 self.viewmModel中userList
 
 
 */

-(void)onAttention:(UIButton *)sender{
    
    YCSearchDetaiLlistVM *viewModel =(id)self.viewModel;
    UITableViewCell *cell = sender.findTableViewCell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YCLoginUserM *m = [viewModel modelForItemAtIndexPath:indexPath];
    BOOL isLike =!m.isFollow.boolValue;
    [sender executeActivitySignal:[self.viewModel followUserById:m.Id isFollow:isLike]  next:^(id x) {
        m.isFollow = @(isLike);
    } error:self.errorBlock completed:nil executing:nil];
    
}




#pragma mark-----单元格的选择
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCSearchDetaiLlistVM *viewModel =(id)self.viewModel;
    id model = [viewModel modelForItemAtIndexPath:indexPath];
    if (viewModel.listType ==YCSearchlistTypeUser) {
        YCLoginUserM *M = model;//viewModel.model.userList[indexPath.row];
        YCOthersInfoVM * vm = [[YCOthersInfoVM alloc]initWithId:M.Id];
        [self pushTo:[YCOthersInfoVC class] viewModel:vm];
    }
    else if (viewModel.listType ==YCSearchlistTypePhoto) {
        YCChihuoyingM_1_2 *m = model;//viewModel.model.content[indexPath.row];
        YCYouChiDetailVM *vm = [[YCYouChiDetailVM alloc]initWithModel:m];
        vm.title = @"随手拍";
        vm.previousModel = m;
        [self pushTo:[YCYouChiDetailVC class] viewModel:vm ];
        
    }else if (viewModel.listType ==YCSearchlistTypeVideo) {
       
        YCChihuoyingM_1_2 *m = model;//viewModel.model.videoList[indexPath.row];
        YCVideosDetailVM *vm = [[YCVideosDetailVM alloc]initWithModel:m];
        vm.urlString = apiGetRecommendList;
        vm.isUpdate = YES;
        vm.previousModel = m;
        [self pushTo:[YCVideosDetailVC class] viewModel:vm];
        
    }else {
        YCNewsList *m = model;
        NSString *url = [NSString stringWithFormat:@"%@informaction.html?id=%@",html_share,m.Id];
        YCWebVM *vm = [[YCWebVM alloc]initWithUrl:url];
        vm.shareUrl =  [NSURL URLWithString:url];
        vm.shareImageUrl = m.imagePath;
        [self pushTo:[YCWebVC class] viewModel:vm hideTabBar:YES];
    }
    
}


#pragma mark------ 网络加载图片
- (void)onSetupActivityIndicatorView{
    [super onSetupActivityIndicatorView];
}
///下拉刷新
- (void)onSetupRefreshControl{;}

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
