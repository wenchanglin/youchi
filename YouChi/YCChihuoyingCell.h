//
//  YCChihuoyingCell.h
//  YouChi
//
//  Created by sam on 15/6/1.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCCatolog.h"
#import "YCChihuoyingM.h"
#import "YCMarcros.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YCCommentControl.h"
#import "YCAvatarControl.h"
#import "YCRightLikeCountView.h"
#import "YCView.h"
#import "YCViewModel+Logic.h"
#import "YCViewController.h"
#import "YCTableVIewCell.h"
///吃货营cell父类
@interface YCChihuoyingCell : YCTableVIewCell


///显示赞数
@property (weak, nonatomic) IBOutlet YCRightLikeCountView *likeCount;


///内容
@property (weak, nonatomic) IBOutlet YYLabel *lContent;

@property (weak, nonatomic) IBOutlet YCCommentControl *actions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relativeHeight;

@property (weak, nonatomic) YCChihuoyingM_1_2 *model;

@end
