//
//  YCSpecialDrinkVC.m
//  YouChi
//
//  Created by 李李善 on 15/5/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouChiDetailVC.h"

#import <Masonry/Masonry.h>
#import "YCRankView.h"
#import "YCPhotosView.h"
#import "YCAvatarControl.h"
#import "YCAccusationVC.h"
#import "YCAccusationVM.h"
#import "YCChihuoPeopleCell.h"

#import "YCCommentListVC.h"


#import "YCCommentControl.h"

#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "YCChihuoCommentCell.h"

#import "UIButton+MJ.h"

#import "YCAccusationVC.h"
#import <LTNavigationBar/UINavigationBar+Awesome.h>

#import "YCRightLikeCountView.h"

#import "YCCollectionPhotoCell.h"


#import "YCMaterialVC.h"
#import "YCDetailControlVCP.h"

#import "YCMoreLikeVC.h"
#import "YCMoreLikeVM.h"

#import "YCImageSelectControl.h"
#import "YCRecipeDetailVC.h"
#define NAVBAR_CHANGE_POINT 150

#import "YCOthersInfoVC.h"
#import "YCAvatar.h"
#import "YCCommentListVC.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "YCPhotoBrowser.h"
#import "YCRelativeHeader.h"

#import "NSString+MJ.h"
#import "YCWebVC.h"

@interface YCYouChiDetailVC ()
PROPERTY_STRONG_VM(YCYouChiDetailVM);
@property (nonatomic,strong) YCRelativeHeader *recipeHeader;
@property (nonatomic,strong) YCRelativeHeader *commentHeader;
@end

@implementation YCYouChiDetailVC
SYNTHESIZE_VM;
#pragma mark --生命周期
- (void)dealloc
{
    //ok
    
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideTabbar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.indicator) {
        [super onSetupActivityIndicatorView];
        [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"随手拍";
    
    [self onSetupCell];
    
    _recipeHeader = [YCRelativeHeader viewByClass];
    _recipeHeader.title.text = @"相关秘籍";
    [_recipeHeader.detail setTitleColor:KBGCColor(@"#A7A7AB") forState:UIControlStateNormal];
    _recipeHeader.detail.titleLabel.font =[UIFont systemFontOfSize:10];
    [_recipeHeader.detail addTarget:self action:@selector(onMoreReceipe:) forControlEvents:UIControlEventTouchUpInside];
    _recipeHeader.detail.enabled = YES;
    
    _commentHeader = [YCRelativeHeader viewByClass];
    _commentHeader.title.textColor = _recipeHeader.title.textColor = KBGCColor(@"#272636");
    _commentHeader.title.text = @"评论";
    _commentHeader.detail.enabled = NO;
    
    
    
    
}



- (void)onSetupCell
{

    [super onSetupCell];
    [self onRegisterNibName:@"YCChihuoPeopleCell" Identifier:cell5];
    [self onRegisterNibName:@"YCChihuoCommentCell" Identifier:cell6];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.viewModel numberOfSections];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    WSELF;
    [self executeSignal:self.viewModel.mainSignal next:^(YCChihuoyingM_1_2 *next) {
        SSELF;
        if (!next) {
            return ;
        }
        [self onReloadItems:0];
        self.tableView.tableFooterView = self.moreButton;
        self.moreButton.hidden = next.youchiCommentList.count<10;
        
        [self.recipeHeader.detail setTitle:[NSString stringWithFormat:@"%d篇  >",next.recipeCount.intValue] forState:UIControlStateNormal];
        
        if (self.viewModel.shouldOpenCommentKeyboard) {
            ///回复评论
            YCDetailControlVCP *vcp = (id)self.parentViewController;
            if ([vcp isKindOfClass:[YCDetailControlVCP class]]) {
                [vcp.inputBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.6];
            }
        }
    } error:self.errorBlock completed:^{
        [self.indicator stopAnimating];
    } executing:self.executingBlock];
    
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    #pragma mark --头像
    if (reuseIdentifier == cell0) {
        
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YCAvatarControl *avatar = [YCAvatarControl newInSuperView:view];
            UILabel *date      = [UILabel newInSuperView:avatar];
            
            [avatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                date.textAlignment = NSTextAlignmentRight;
                date.textColor     = KBGCColor(@"#aaaaaa");
                date.font          = [UIFont systemFontOfSize:12];
                UIEdgeInsets edge  = UIEdgeInsetsMake(8, 8, 8, 8);
                avatar.frame = UIEdgeInsetsInsetRect(frame, edge);
                [avatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
                
                [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view).insets(edge);
                }];
                
                [date mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(avatar.mas_top);
                    make.right.equalTo(avatar.mas_right);
                    make.left.equalTo(avatar.name.mas_right);
                }];
            }];
            

            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [avatar updateAvatarControlWith:m.userImage name:m.userName sign:m.signature];
                
                date.text = [m.createdDate substringFromIndex:5];
                
            }];
            
            return ;
        }];
        
    }
    #pragma mark --图片
    if (reuseIdentifier == cell1) {
        UIEdgeInsets edge = UIEdgeInsetsMake(YCYouChiDetailInset, 0, YCYouChiDetailInset, 0);
        [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
            view.frame = UIEdgeInsetsInsetRect(frame, edge);
        }];
        
        [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            if ([cell checkIsHasSetData:m]) {
                return ;
            }
            if (isOldOSS(m.imagePath)) {
                [view ycNotShop_setImageWithURL:m.imagePath placeholder:PLACE_HOLDER];
            } else {
                [view yc_setImageWithURL:IMAGE_HOST_1_2_get(m.imagePath) placeholder:PLACE_HOLDER];
            }
            
        }];
        
        return;
    }
    
#pragma mark --描述
    if (reuseIdentifier == cell2) {
        
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YYLabel *desc = [YYLabel newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                [desc mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                    
                }];
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YYTextLayout *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                desc.attributedText = m.text;
                desc.textLayout = m;
            }];
            
            return ;
            
        }];
        
    }

    
    #pragma mark --阅读量
    if (reuseIdentifier == cell3) {
        
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIView *bottomView = [UIView newInSuperView:view];
            UIView   *leftLine = [UIView newInSuperView:bottomView];
            UIView  *rightLine = [UIView newInSuperView:bottomView];
            UILabel *readCount = [UILabel newInSuperView:bottomView];
            
            
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [readCount sizeToFit];
                readCount.font     = KFont(10);
                
                readCount.textAlignment  =  NSTextAlignmentCenter;
                leftLine.backgroundColor = rightLine.backgroundColor = readCount.textColor = color_title;
                bottomView.hasTopLine    = bottomView.hasBottomLine  = YES;
                bottomView.backgroundColor = KBGCColor(@"#ededed");
                leftLine.alpha = rightLine.alpha = 0.6;
                
                [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.bottom.equalTo(view);
                    make.left.right.equalTo(view);
                    make.height.equalTo(@39);
                }];
                
                [readCount mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.center.equalTo(bottomView);
                }];
                
                [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.right.equalTo(readCount.mas_left).offset(-8);
                    make.centerY.equalTo(readCount);
                    make.width.equalTo(@70);
                    make.height.equalTo(@1);
                }];
                
                [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(readCount.mas_right).offset(8);
                    make.centerY.equalTo(readCount);
                    make.width.equalTo(@70);
                    make.height.equalTo(@1);
 
                }];
                
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                readCount.text = [NSString stringWithFormat:@"%@次阅读",m.pv];
            }];
            
            return ;
        }];
        
    }
    
    #pragma mark --相关秘籍
    if (reuseIdentifier == cell4) {
        
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YCImageSelectControl *relative = [YCImageSelectControl newInSuperView:view];
            relative.gap = 4;
            relative.containerControlType = YCContainerControlTypeHorizion;
            
            UIButton *post = [UIButton newInSuperView:view];
            post.titleLabel.font = KFont(14);
            [post setTitle:@"我来发一个吧" forState:UIControlStateNormal];
            post.backgroundColor = color_btnGold;
            
            post.cornerRadius = 5;
            [relative addTarget:self action:@selector(onRelativeImageSelect:) forControlEvents:UIControlEventValueChanged];
            
            [post addTarget:self action:@selector(onPost:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                [post mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(view).offset(20);
                    make.right.equalTo(view).offset(-20);
                    make.bottom.equalTo(view).offset(-13);
                }];
                
                [relative mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(post);
                    make.right.equalTo(post);
                    make.top.equalTo(view).offset(13);
                    make.bottom.equalTo(post.mas_top).offset(-13);
                }];
                
                
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                BOOL showDefault = (m.recipeList.count == 0);
                
                if (!showDefault) {
                    
                    relative.imageCount = 5;
                    [relative updateImagesWithPageModels:m.recipeList];
                }
                relative.showDefault = showDefault;
                
            }];
            
            return ;
        
        }];
    }
    
    
    
    #pragma mark -点赞列表
    if (reuseIdentifier == cell5) {
        [cell setInitBlock:^(__kindof YCChihuoPeopleCell *cell, UIView *view, NSString *reuseIdentifier) {
            cell.photosView.selectBlock = ^(NSIndexPath *indexPath,YCChihuoyingM_1_2 *model) {
                SSELF;
                YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:model.userId];
                [self pushTo:[YCOthersInfoVC class] viewModel:vm];
            };
            
            cell.more.enabled = NO;
            [cell.more addTarget:self action:@selector(onMoreLike:) forControlEvents:UIControlEventTouchUpInside];
            
            ///点赞 通知
            WSELF;
            [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCClickNotification object:nil] subscribeNext:^(NSNotification *x) {
                SSELF;
                YCChihuoyingM_1_2 *m = x.object;
                
                if (m) {
                    NSIndexPath *index = [self indexPathForCell:cell];
                    m = [self.viewModel modelForItemAtIndexPath:index];
                    if (m) {
                        [cell updateChihuo:m type:YCCheatsTypeYouChi];
                    }
                }
            }];
            
            [cell setUpdateBlock:^(YCChihuoPeopleCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [cell updateChihuo:m type:YCCheatsTypeYouChi];
                });
            }];
            
            return ;
        }];
    }
    
#pragma mark - 评论列表
    if (reuseIdentifier == cell6) {
        [cell setInitBlock:^(__kindof YCChihuoCommentCell *cell, UIView *view, NSString *reuseIdentifier) {
            [cell.avatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
            [cell setUpdateBlock:^(__kindof YCChihuoCommentCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCCommentM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [cell updateComment:m];
            }];
            
        }];
    }
    
    
}



- (void)onConfigureHeader:(YCTableViewHeaderFooterView *)header reuseIdentifier:(NSString *)reuseIdentifier
{
    if (reuseIdentifier == headerC) {
        header.backgroundView = _recipeHeader;
    }
    
    else if (reuseIdentifier == headerC2) {
        header.backgroundView = _commentHeader;
    }
}
#pragma mark --查看更多 （更多点赞）
- (void)onMoreLike:(UIButton *)sender
{
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    YCChihuoPeopleCell *cell = (YCChihuoPeopleCell *)sender.findTableViewCell;
    NSIndexPath * indexPath =[self indexPathForCell:cell];
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    
    YCMoreLikeVM *vm = [[YCMoreLikeVM alloc]initWithId:m.Id withMoreTepy:YCMoreLikeTypeYouChi];
    vm.isVideo = NO;
    vm.totalNum = m.likeCount.intValue;
    [self pushTo:[YCMoreLikeVC class] viewModel:vm];
}

#pragma mark -- 发果单
- (void)onPost:(UIButton *)sender {
    if ([self pushToLoginVCIfNotLogin]) {
        return;
    }
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    
    
    YCMaterialVM *vm =  [YCMaterialVM cacheViewModel];
    if (!vm) {
        vm = [[YCMaterialVM alloc]initWithModel:self.viewModel.title];
    }
    vm.Id = self.viewModel.Id;
    
    [self pushTo:[YCMaterialVC class] viewModel:vm];
    
}


#pragma mark -- 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == cell1) {
        
        YCPhotoBrowser *browser = [[YCPhotoBrowser alloc]initWithPageModels:self.viewModel.model.youchiPhotoList selectedIndex:indexPath.row];
        [browser setUrlBlock:^NSURL *(YCChihuoyingM_1_2 *m) {
            if (isOldOSS(m.imagePath)) {
                return NSURL_URLWithString(IMAGE_HOST_NOT_SHOP_(IMAGE_LARGE(m.imagePath)));
            } else {
                return NSURL_URLWithString(IMAGE_HOST_1_2(m.imagePath));
            }
        }];
        
        [self.navigationController pushViewController:browser animated:YES];
    }
    else if (cell.reuseIdentifier == cell6)
    {
        
        YCCommentM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        
        UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"删除", nil];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        WSELF;
        [[actionSheet.rac_buttonClickedSignal ignore:@(actionSheet.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
            SSELF;
            NSInteger buttonIndex = x.integerValue;
            
            if (buttonIndex==0) {
                ///回复评论
                YCDetailControlVCP *vcp = (id)self.parentViewController;
                if ([vcp isKindOfClass:[YCDetailControlVCP class]]) {
                    [vcp.inputBar becomeFirstResponder];
                }
                self.viewModel.replyModel = m;
            } else if (buttonIndex==1) {
                ///删除评论
                [[self.viewModel deleteCommentById:m.Id type:YCCheatsTypeYouChi].deliverOnMainThread subscribeNext:^(id x) {
                    SSELF;
                    @try {
                        [self.viewModel.model.youchiCommentList removeObject:m];
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
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
}

#pragma mark -- 相关秘籍
- (void)onRelativeImageSelect:(YCImageSelectControl *)sender
{
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    UITableViewCell *cell = sender.findTableViewCell;
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    YCBaseImageModel *pm = m.recipeList[sender.selectedIndex];
    
    YCRecipeDetailVM *vm = [[YCRecipeDetailVM alloc]initWithId:pm.Id];
    
    [self pushTo:[YCRecipeDetailVC class] viewModel:vm];
}

#pragma mark - 头像
- (void)onAvatar:(YCAvatar *)sender
{
    UITableViewCell *cell = sender.findTableViewCell;
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:m.userId];
    [self pushTo:[YCOthersInfoVC class] viewModel:vm];
}

#pragma mark - 更多评论
- (void)onMoreComment:(UIButton *)sender
{
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    YCCommentListVM *vm = [[YCCommentListVM alloc]initWithId:self.viewModel.model.Id type:YCCheatsTypeYouChi];
    [self pushTo:[YCCommentListVC class] viewModel:vm];
}

#pragma mark -- 更多秘籍
- (void)onMoreReceipe:(UIButton *)sender
{
    YCChihuoyingOtherVM *vm = [[YCChihuoyingOtherVM alloc]initWithId:self.viewModel.Id];
    YCChihuoyingOtherVC *vc = [YCChihuoyingOtherVC vcClass:[YCChihuoyingVC class] vcId:NSStringFromClass([YCChihuoyingOtherVC class])];;
    vc.viewModel = vm;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupActivityIndicatorView
{
    ;
}
- (void)onSetupFooter
{
    [super onSetupFooter];
}
- (void)onSetupEmptyView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





