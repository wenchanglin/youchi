//
//  YCNotificationCell.h
//  YouChi
//
//  Created by 李李善 on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCNotificationCell : UITableViewCell
///名字
@property (weak, nonatomic) IBOutlet UILabel *lName;
///时间
@property (weak, nonatomic) IBOutlet UILabel *lTimer;
///内容
@property (weak, nonatomic) IBOutlet UILabel *lInfo;
///头像
@property (weak, nonatomic) IBOutlet UIImageView *imagvIcon;
@end
