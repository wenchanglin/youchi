//
//  YCChihuoyingVC.h
//  YouChi
//
//  Created by sam on 15/5/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCChihuoyingVM.h"
#import "YCSwitchTabControl.h"
#import "YCSearchVC.h"

@class YCCommentControl,YCAvatarControl;
@interface YCChihuoyingVCP : YCViewController

@end

@interface YCChihuoyingVC : YCBTableViewController
#pragma mark --点赞、分享
- (IBAction)onLikeOrShare:(YCCommentControl *)sender;
- (void)onFavorite:(UIButton *)sender model:(YCChihuoyingM_1_2 *)model indexPath:(NSIndexPath *)indexPath;
#pragma mark -- 用户详细信息
- (IBAction)onAvatar:(YCAvatarControl *)sender;

@end


@interface YCChihuoyingOtherVC : YCChihuoyingVC

@end