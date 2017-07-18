//
//  YCGuanZhuCell.h
//  YouChi
//
//  Created by 李李善 on 15/5/31.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCRankView.h"
#import "BFPaperTableViewCell.h"
#import "YCAvatarControl.h"

@interface YCFollowsAndFansCell : UITableViewCell
///头像
@property (weak, nonatomic) IBOutlet YCAvatarControl *superView;
///删除
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

@property (strong,nonatomic) NSArray *arr;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (weak, nonatomic) IBOutlet UILabel *lSign;

@end


@interface YCFansCell : YCFollowsAndFansCell

@end





