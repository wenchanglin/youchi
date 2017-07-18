//
//  YCSmallHelperTwoDetailedVC.m
//  YouChi
//
//  Created by 李李善 on 15/6/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRecipeDetailVC.h"


#define NAVBAR_CHANGE_POINT 150
#import "YCRecipeDetailVC.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

#import <LTNavigationBar/UINavigationBar+Awesome.h>

#import "YCCommentM.h"
#import "YCYouChiDetailVC.h"
#define KSectionHeight 32.f


#import "YCVideosDetailVM.h"
#import "YCDetailControlVCP.h"
#import "YCAvatar.h"
#import "YCOthersInfoVC.h"
#import "YCPersonalProfileVM.h"
#import "AppDelegate.h"
#import "YCCommentListVC.h"
#import "YCPhotoBrowser.h"
#import "YCMoreLikeVM.h"
#import "YCMoreLikeVC.h"

#import "YCChihuoCommentCell.h"

#import "YCRightLikeCountView.h"
#import "YCPhotosView.h"
#import "YCCollectionPhotoCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "YCChihuoPeopleCell.h"
#import "YCRecipeDetailStepCell.h"

#import "YCRelativeHeader.h"


@interface YCRecipeDetailVC ()
PROPERTY_STRONG_VM(YCRecipeDetailVM);
@property (nonatomic,strong) YCRelativeHeader *commentHeader;
@end


@implementation YCRecipeDetailVC
SYNTHESIZE_VM;
- (void)dealloc{
    //ok
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.indicator) {
        [super onSetupActivityIndicatorView];
        [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }
    
    [self hideTabbar];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"秘籍";

    _commentHeader = [YCRelativeHeader viewByClass];
    _commentHeader.title.textColor =  KBGCColor(@"#272636");
    _commentHeader.title.text = @"评论";
    _commentHeader.detail.enabled = NO;

    
}

- (void)onSetupCell
{
    
    [super onSetupCell];
    UINib *nib0 = [UINib nibWithNibName:@"YCChihuoPeopleCell" bundle:nil];
    [self.tableView registerNib:nib0 forCellReuseIdentifier:cell6];
    UINib *nib1 = [UINib nibWithNibName:@"YCChihuoCommentCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:cell7];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.viewModel numberOfSections];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:^(YCChihuoyingM_1_2 *next) {
        [self onReloadItems:0];
        
        self.tableView.tableFooterView = self.moreButton;
        
        self.moreButton.hidden = next.recipeCommentList.count<10;
        
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
    #pragma mark --图片
    if (reuseIdentifier == cell0) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [view ycNotShop_setImageWithURL:IMAGE_MEDIUM(m.imagePath) placeholder:PLACE_HOLDER];
            }];
        }];
        return;
    }
    
    #pragma mark --标题
    if (reuseIdentifier == cell1) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UILabel *title    = [UILabel newInSuperView:view];
            UIView *leftLine  = [UIView newInSuperView:view];
            UIView *rightLine = [UIView newInSuperView:view];
            UILabel *name     = [UILabel newInSuperView:view];
            YCAvatar *avatar    = [YCAvatar newInSuperView:view];
            
            avatar.cornerRadius = 25;
            avatar.masksToBounds = YES;
            
            
            title.font = [UIFont systemFontOfSize:13];
            name.font  = [UIFont systemFontOfSize:20];
            
            
            leftLine.backgroundColor = rightLine.backgroundColor = title.textColor = color_title;
            name.textColor = [UIColor blackColor];
            title.textAlignment = name.textAlignment = NSTextAlignmentCenter;
            
            cell.backgroundColor = KBGCColor(@"#f6f6f6");
            
            [avatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                [title mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.top.equalTo(view).offset(10);
                    make.centerX.equalTo(view);
                }];
                
                [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(title.mas_left).offset(-20);
                    make.height.equalTo(@1);
                    make.width.equalTo(@60);
                    make.centerY.equalTo(title.mas_centerY);
                }];
                
                [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(title.mas_right).offset(20);
                    make.height.equalTo(@1);
                    make.width.equalTo(@60);
                    make.centerY.equalTo(title.mas_centerY);
                }];
                
                [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(title);
                    make.top.equalTo(title.mas_bottom).offset(10);
                    make.height.width.equalTo(@50);
                }];
                
                [name mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(avatar.mas_bottom).offset(10);
                    make.centerX.equalTo(avatar);
                }];
                
                
            }];
            
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                title.text = m.name;
                [avatar ycNotShop_setImageWithURL:m.userImage placeholder:PLACE_HOLDER];
                name.text = m.userName;
                
            }];

        }];
        return;
    }
    
#pragma mark --描述
    if (reuseIdentifier == cell2) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
          
            YYLabel *text     = [YYLabel newInSuperView:view];
            text.numberOfLines = 0;
            cell.backgroundColor = KBGCColor(@"#f6f6f6");
            
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                text.frame = frame;
            }];
            
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YYTextLayout *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                text.attributedText = m.text;
                text.textLayout = m;
            }];
            
        }];
        return;
    }

    
    #pragma mark --难度时间
    if (reuseIdentifier == cell3) {
        
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
           
            UIView *leftView = [UIView newInSuperView:view];
            UIView *rightView = [UIView newInSuperView:view];
            
            UILabel *lDifficult = [UILabel newInSuperView:leftView];
            UILabel *difficulty = [UILabel newInSuperView:leftView];
            UILabel *lTime = [UILabel newInSuperView:rightView];
            UILabel *timer = [UILabel newInSuperView:rightView];
            rightView.hasLeftLine = YES;
            timer.tag = 2;
            difficulty.tag = 1;
            lDifficult.text = @"难度";
            lTime.text = @"时间";
            lDifficult.textColor = lTime.textColor = KBGCColor(@"#929292");
            difficulty.textColor = timer.textColor = [UIColor blackColor];
            lDifficult.font = lTime.font = [UIFont systemFontOfSize:13];
            difficulty.font = timer.font = [UIFont systemFontOfSize:12];
            view.hasBottomLine = YES;
            view.hasTopLine = YES;
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.left.bottom.top.equalTo(view);
                    make.width.equalTo(@(view.centerX));
                }];
                
                [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.right.bottom.top.equalTo(view);
                    make.width.equalTo(leftView.mas_width);
                }];
                
                [lDifficult mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.left.equalTo(leftView).offset(8);
                    make.centerY.equalTo(leftView);
                }];
                
                [difficulty mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.right.equalTo(leftView).offset(-20);
                    make.centerY.equalTo(leftView);
                }];
                
                [lTime mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.left.equalTo(rightView).offset(8);
                    make.centerY.equalTo(rightView);
                }];
                
                [timer mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.right.equalTo(rightView).offset(-20);
                    make.centerY.equalTo(rightView);
                }];
            }];
            
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                difficulty.text = m.difficulty;
                timer.text = m.maxSpendTime.intValue>0?[[NSString alloc] initWithFormat:@"%d-%d分钟",m.minSpendTime.intValue,m.maxSpendTime.intValue]:@"一小时以上";
                
            }];

            
        }];
        return;
    }
    
    
    #pragma mark --材料
    if (reuseIdentifier == cell4) {
        
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UILabel *title = [UILabel newInSuperView:view];
            UILabel *desc = [UILabel newInSuperView:view];
            
            title.tag = 1;
            desc.tag = 2;
            title.font = desc.font = [UIFont systemFontOfSize:12];
            title.textColor = KBGCColor(@"#929292");
            desc.textColor = KBGCColor(@"#555555");
            view.hasBottomLine = YES;
            
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
            
                [title mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.centerY.equalTo(view);
                    make.left.equalTo(view).offset(20);
                }];
                
                [desc mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.centerY.equalTo(view);
                    make.right.equalTo(view).offset(-20);
                }];
                
                
                [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                    SSELF;
                    YCMaterialList *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                    if ([cell checkIsHasSetData:m]) {
                        return ;
                    }
                    title.text = m.materialName;
                    desc.text = m.quantity;
                    
                }];
            }];
        }];
        
        return;
    }
    
    #pragma mark --步骤
    if (reuseIdentifier == cell5) {
        
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UIView *iv = [UIView newInSuperView:view];
            YYLabel *l = [YYLabel newInSuperView:view];
            
           
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view);
                    make.left.right.equalTo(view);
                }];
                
                [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(l.mas_bottom);
                    make.left.right.equalTo(view);
                    make.bottom.equalTo(view);
                }];
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCStepList *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [iv ycNotShop_setImageWithURL:IMAGE_MEDIUM(m.imagePath) placeholder:PLACE_HOLDER];
                l.attributedText = m.layout.text;;
                l.textLayout = m.layout;
                
                [l mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.height.equalTo(@(m.layout.textBoundingSize.height));
                }];

            }];
        }];
        return;
    }

    #pragma mark --赞
    if (reuseIdentifier == cell6) {
        [cell setInitBlock:^(__kindof __weak YCChihuoPeopleCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            WSELF;
            cell.photosView.selectBlock = ^(NSIndexPath *indexPath,YCChihuoyingM_1_2 *model) {
                SSELF;
                YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:model.userId];
                [self pushTo:[YCOthersInfoVC class] viewModel:vm];
            };
            cell.more.enabled = NO;
            [cell.more addTarget:self action:@selector(onMoreLike:) forControlEvents:UIControlEventTouchUpInside];
            
            ///点赞 通知
            [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCClickNotification object:nil] subscribeNext:^(NSNotification *x) {
                SSELF;
                YCChihuoyingM_1_2 *m = x.object;
                
                if (m) {
                    NSIndexPath *index = [self indexPathForCell:cell];
                    m = [self.viewModel modelForItemAtIndexPath:index];
                    if (m) {
                        [cell updateChihuo:m type:YCCheatsTypeRecipe];
                    }
                }
            }];

            
            [cell setUpdateBlock:^(__kindof __weak YCChihuoPeopleCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [cell updateChihuo:m type:YCCheatsTypeRecipe];
                });
                
            }];
            
        }];
        
        return;
    }
    
    #pragma mark --评论
    if (reuseIdentifier == cell7) {
        [cell setInitBlock:^(__kindof YCChihuoCommentCell *cell, UIView *view, NSString *reuseIdentifier) {
            [cell.avatar addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
            [cell setUpdateBlock:^(__kindof __weak YCChihuoCommentCell *cell, UIView *view, NSIndexPath *indexPath) {
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


#pragma mark --查看更多 
- (void)onMoreLike:(UIButton *)sender
{
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    YCChihuoPeopleCell *cell = (YCChihuoPeopleCell *)sender.findTableViewCell;
    NSIndexPath * IndexPath =[self indexPathForCell:cell];
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:IndexPath];
    
    YCMoreLikeVM *vm = [[YCMoreLikeVM alloc]initWithId:m.Id withMoreTepy:YCMoreLikeTypeRecipe];
    vm.isVideo = NO;
    vm.totalNum = m.likeCount.intValue;
    [self pushTo:[YCMoreLikeVC class] viewModel:vm];
}


- (void)onConfigureHeader:(YCTableViewHeaderFooterView *)header reuseIdentifier:(NSString *)reuseIdentifier
{
#pragma mark --准备材料
    if (reuseIdentifier == cell4) {
        
        [header setInitBlock:^(YCTableViewHeaderFooterView *headerFooter, UIView *view, NSString *reuseIdentifier) {
            UILabel *l = [UILabel newInSuperView:view];
            l.text = @"  准备材料";
            l.textColor = KBGCColor(@"#626262");
            l.font = [UIFont systemFontOfSize:15];
            l.backgroundColor = [UIColor whiteColor];
            view.hasBottomLine = YES;
            headerFooter.backgroundView = l;
        }];
    }

    if (reuseIdentifier == cell7) {
        header.backgroundView = _commentHeader;
    }
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == cell0) {
        YCPhotoBrowser *browser = [[YCPhotoBrowser alloc]initWithPageModels:@[[self.viewModel modelForItemAtIndexPath:indexPath]] selectedIndex:0];
        [self.navigationController pushViewController:browser animated:YES];
    }
    else if (cell.reuseIdentifier == cell5){
        YCPhotoBrowser *browser = [[YCPhotoBrowser alloc]initWithPageModels:self.viewModel.model.recipeStepList selectedIndex:indexPath.row];
        [self.navigationController pushViewController:browser animated:YES];
    }
    else if (cell.reuseIdentifier == cell7){
        
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
            }
            else if (buttonIndex==1) {
                ///删除评论
                [[self.viewModel deleteCommentById:m.Id type:YCCheatsTypeRecipe].deliverOnMainThread subscribeNext:^(id x) {
                    SSELF;
                    @try {
                        [self.viewModel.model.recipeCommentList removeObject:m];
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

#pragma mark -头像
- (void)onAvatar:(YCAvatar *)sender
{
    UITableViewCell *cell = sender.findTableViewCell;
    YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:m.userId];
    [self pushTo:[YCOthersInfoVC class] viewModel:vm];
}

- (void)onMoreComment:(UIButton *)sender
{
    YCCommentListVM *vm = [[YCCommentListVM alloc]initWithId:self.viewModel.model.Id type:YCCheatsTypeRecipe];
    [self pushTo:[YCCommentListVC class] viewModel:vm];
}


#pragma mark --刷新
- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupFooter
{
    
}


- (void)onSetupActivityIndicatorView
{

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

