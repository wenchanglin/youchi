//
//  YCGuanZhuCell.h
//  YouChi
//
//  Created by 李李善 on 15/5/31.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCRankView.h"

@interface YCGuanZhuCell : UITableViewCell
///头像
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
///名字
@property (weak, nonatomic) IBOutlet UILabel *lName;
///标题
@property (weak, nonatomic) IBOutlet UILabel *lSignture;
///删除
@property (weak, nonatomic) IBOutlet UIButton *bAttention;



@property (strong,nonatomic) NSArray *arr;

@end





