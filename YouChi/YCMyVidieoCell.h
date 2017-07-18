//
//  YCMyVidieoCell.h
//  YouChi
//
//  Created by 朱国林 on 15/8/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAvatarControl.h"

@interface YCMyVidieoCell : UITableViewCell

@property(strong,nonatomic) UIView *view;
///头像
@property (weak, nonatomic) IBOutlet UIImageView *imgvAvatar;
///标题
@property (weak, nonatomic) IBOutlet UILabel *lTitle;
///内容
@property (weak, nonatomic) IBOutlet UILabel *lDesc;
///关注按钮
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
///时长
@property (weak, nonatomic) IBOutlet UILabel *lTime;

@end
