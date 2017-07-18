//
//  YCVideosDetailVC.m
//  YouChi
//
//  Created by 李李善 on 15/8/28.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCVideosDetailVC.h"

#import "YCMoreLikeVC.h"

#import "YCCommentControl.h"
#import "YCVideoM.h"

#import "YCAccusationVC.h"
#import "YCAvatarControl.h"

#import "YCRightLikeCountView.h"
#import "YCChihuoCommentCell.h"
#import "YCPhotosView.h"

#import "YCCollectionPhotoCell.h"
#import "YCNewsM.h"
#import "AppDelegate.h"
#import "YCMyVidieoCell.h"
#import "YCChihuoPeopleCell.h"

#define NAVBAR_CHANGE_POINT 150

#import "TCCloudPlayerSDK.h"
#import "TCCloudPlayerView.h"
#import "YCCommentListVC.h"
#import "YCPlayerVC.h"

#import "YCOthersInfoVC.h"
#import "YCOthersInfoVM.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "NSString+MJ.h"

#import "YCRelativeHeader.h"





@interface YCVideosDetailVC ()
PROPERTY_STRONG_VM(YCVideosDetailVM);
@property (nonatomic,strong) YCRelativeHeader *commentHeader;
@property (nonatomic,strong) YCRelativeHeader *recommendHeader;
@end
@implementation YCVideosDetailVC
SYNTHESIZE_VM;
-(void)dealloc{
    //    ok
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideTabbar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.indicator) {
        [super onSetupActivityIndicatorView];
        if ([self.viewModel numberOfSections]>0) {
            [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
    _recommendHeader = [YCRelativeHeader viewByClass:[YCRelativeHeader class]];
    _recommendHeader.title.text = @"热门视频推荐";
    [_recommendHeader.title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    
    _commentHeader = [YCRelativeHeader viewByClass:[YCRelativeHeader class]];
    _commentHeader.title.textColor = _recommendHeader.title.textColor =KBGCColor(@"#272636");
    _commentHeader.title.text = @"评论";
    [_commentHeader.title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    _commentHeader.detail.enabled =_recommendHeader.detail.enabled = NO;
    _commentHeader.hasTopLine = YES;
    
    RAC(self,title) = RACObserve(self.viewModel, title).deliverOnMainThread;
    
    WSELF;
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCClickNotification object:nil] subscribeNext:^(NSNotification *x) {
        SSELF;
        YCVideoM *m = x.object;
        
        if (m) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
            m = [self.viewModel modelForItemAtIndexPath:index];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
            [self onUpdateCell:cell model:m atIndexPath:index];
        }
    }];
    
}


- (void)onSetupCell{
    UINib *nib0 = [UINib nibWithNibName:@"YCChihuoPeopleCell" bundle:nil];
    [self.tableView registerNib:nib0 forCellReuseIdentifier:cell3];
    UINib *nib1 = [UINib nibWithNibName:@"YCChihuoCommentCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:cell5];
    UINib *nib2 = [UINib nibWithNibName:@"YCMyVidieoCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:cell4];
}
/// 刷新推荐
- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    ///内容
    [self executeSignal:self.viewModel.mainSignal next:^(id x){
        [self onReloadItems:0];
    } error:self.errorBlock completed:^{
        [self.indicator stopAnimating];
    } executing:self.executingBlock];
    WSELF;
    ///评论
    [self executeSignal:self.viewModel.commentSignal next:^(id next) {
        SSELF;
        @try {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:4];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                self.tableView.tableFooterView = self.moreButton;

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
       
    } error:self.errorBlock completed:nil executing:self.executingBlock];
    
    ///如果更新 ----请求推荐
    if (self.viewModel.isUpdate==YES) {
        
    [self executeSignal:self.viewModel.recommendSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
    }
}



#pragma mark --设置表头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        if (section==3) {
            
            return _recommendHeader;
        }
        else if (section==4){  
            
            return _commentHeader;
        }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3 ) {return KSectionHeight;}
    else if(section == 4)
    {
        
    self.moreButton.hidden =(self.viewModel.videoCommentList.count>10)?NO:YES;
        
        if(self.viewModel.videoCommentList.count==0)
    {
        return 0;
    }
        return KSectionHeight;
    }
    return 0;
}

#pragma mark --数据
- (void)onUpdateCell:(YCMyVidieoCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    
    YCChihuoyingM_1_2 *m = model;
    
    // 大图片
    if (indexPath.section == 0) {
        UIImageView *avatar = (id)[cell viewByTag:1];;
        [avatar ycNotShop_setImageWithURL:IMAGE_MEDIUM(m.imagePath) placeholder:PLACE_HOLDER];
    }
    // 描述
    else if (indexPath.section == 1) {
        UILabel *title = (id)[cell viewByTag:3];
        title.text = m.title;
        
//        NSRange range = [m.data rangeOfString:@"时间"];
//        NSString *timeStr = [m.data substringFromIndex:range.location+range.length+1];

//        NSRange range2 = [dataStr rangeOfString:@"/"];
//        NSString *timeStr = [dataStr substringFromIndex:range2.location];
        
        UILabel *commnent = (id)[cell viewByTag:4];
        commnent.text = m.data;
        
//        UILabel *timeLbl = (id)[cell viewByTag:100];
        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr.doubleValue];
//        
//        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//        fmt.dateFormat = @"yyyy/MM/dd";
//        NSString *dateStr = [fmt stringFromDate:date];
//        timeLbl.text = m.data;//[NSString stringWithFormat:@"时间:%@",dateStr];
        
        UILabel *info = (id)[cell viewByTag:5];
        info.text  = m.desc;
        
    }
    // 点赞人数
    else if (indexPath.section == 2) {
        
        YCChihuoPeopleCell *c = (id)cell;
        [c updateChihuo:m type:YCCheatsTypeVideo];
        //赞view
        WSELF;
        c.photosView.selectBlock = ^(NSIndexPath *indexPath,YCBaseUserImageModel *model) {
            SSELF;
            YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:model.userId];
            [self pushTo:[YCOthersInfoVC class] viewModel:vm];
        };
        [c.more addTarget:self action:@selector(onMoreLike:) forControlEvents:UIControlEventTouchUpInside];
    }
    // 热门视频推荐
    else if (indexPath.section == 3) {
        [cell update:model atIndexPath:indexPath];
        [cell.btnAttention addTarget:self action:@selector(onFavorite:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 评论
    else if (indexPath.section==4){
        
        YCChihuoCommentCell *c = (id)cell;
        YCCommentM *m = (id)model;
        [c updateComment:m];
        [c.avatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}


#pragma mark --查看更多点赞
- (void)onMoreLike:(UIButton *)sender{
    
    YCChihuoPeopleCell *cell = (YCChihuoPeopleCell *)sender.findTableViewCell;
    NSIndexPath * IndexPath =[self indexPathForCell:cell];
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:IndexPath];
    

    YCMoreLikeVM *vm = [[YCMoreLikeVM alloc] initWithId:m.Id withMoreTepy:YCMoreLikeTypeVideo];
    vm.isVideo = YES;
    vm.totalNum = m.likeCount.intValue;
    [self pushTo:[YCMoreLikeVC class] viewModel:vm];
}

#pragma mark -头像
- (void)onAvatar:(YCAvatar *)sender
{
    UITableViewCell *cell = sender.findTableViewCell;
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:m.userId];
    [self pushTo:[YCOthersInfoVC class] viewModel:vm];
}

#pragma mark --收藏
- (void)onFavorite:(UIButton *)sender{
    YCVideosDetailVM *vm = (id)self.viewModel;
    YCMyVidieoCell *cell = (YCMyVidieoCell *)sender.findTableViewCell;
    NSIndexPath * IndexPath =[self indexPathForCell:cell];
    
    YCVideoM *m = [self.viewModel modelForItemAtIndexPath:IndexPath];
    BOOL isFavorite = !m.isFavorite.boolValue;
    [sender executeActivitySignal:[vm favoriteById:m.Id isFavorite:isFavorite type:YCCheatsTypeVideo] next:^(id next) {
        m.isFavorite  = @(isFavorite);
        sender.selected = isFavorite;
    } error:self.errorBlock completed:nil executing:nil];
}


#pragma mark --选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        YCPlayerVM *vm = [[YCPlayerVM alloc]initWithModel:m];
        YCPlayerVC *vc = [self vcClassWithIdentifier:NSStringFromClass([YCPlayerVC class])];
        vc.viewModel = vm;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.navigationItem.leftBarButtonItem.action = @selector(onDismissReturn);
        [self presentViewController:nc animated:YES completion:nil];
        
    }
    
    else if (indexPath.section ==3){
        
        YCVideoM *m =self.viewModel.videoRecommends[indexPath.row];
        YCVideosDetailVM *vm = [[YCVideosDetailVM alloc]initWithModel:m recommends:nil];
        vm.urlString =self.viewModel.urlString;
        vm.isUpdate=YES;
        vm.previousModel = m;
        YCVideosDetailVC *toVC = [YCVideosDetailVC vcClass];
        toVC.viewModel = vm;
        
        NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
        [vcs removeLastObject];
        [vcs appendObject:toVC];
        [self.navigationController setViewControllers:vcs animated:YES];

    }

    else if (indexPath.section == 4)
    {
        
        YCCommentM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"删除", nil];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        WSELF;
        [[actionSheet.rac_buttonClickedSignal ignore:@(actionSheet.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
            SSELF;
            NSInteger buttonIndex = x.integerValue;
            
            if (buttonIndex == 0) {
                ///回复评论
                YCDetailControlVCP *vcp = (id)self.parentViewController;
                if ([vcp isKindOfClass:[YCDetailControlVCP class]]) {
                    [vcp.inputBar becomeFirstResponder];
                }
                
                self.viewModel.replyModel = m;
            } else if (buttonIndex == 1) {
                [[self.viewModel deleteCommentById:m.Id type:YCCheatsTypeVideo].deliverOnMainThread subscribeNext:^(id x) {
                    SSELF;
                    
                    ///删除评论
                    @try {
                        [self.viewModel.videoCommentList removeObject:m];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    @catch (NSException *exception) {
                        return ;
                    }
                    @finally {
                        ;
                    }
                    [self showMessage:@"删除成功"];
                } error:self.errorBlock completed:^{
                    
                }];
            }
        }];
        [actionSheet showInView:cell];
    }
    
}

- (IBAction)onMoreComment:(id)sender {
    
    
    YCCommentListVM *vm = [[YCCommentListVM alloc]initWithId:self.viewModel.Id type:YCCheatsTypeVideo];
    [self pushTo:[YCCommentListVC class] viewModel:vm];
}


#pragma mark------- 下拉刷新
- (void)onSetupRefreshControl{
    ;
}

- (void)onSetupFooter{
    ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
