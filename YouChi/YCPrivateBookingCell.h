//
//  YCPrivateCell.h
//  YouChi
//
//  Created by 李李善 on 15/5/13.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCCommentControl.h"
#import "YCChihuoyingM.h"
#import "YCView.h"
#import "YCRankView.h"
#import "YCAvatarControl.h"
#import "YCTableVIewCell.h"
@interface YCPrivateBookingCell : YCTableVIewCell
@property (weak, nonatomic) IBOutlet YCAvatarControl *avatarControl;
@property (weak, nonatomic) IBOutlet UIImageView *tupian;
@property (weak, nonatomic) IBOutlet UILabel *miaoshu;
@property (weak, nonatomic) IBOutlet YCCommentControl *pinglun;

@end
