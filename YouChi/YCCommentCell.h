//
//  YCMessageCell.h
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAvatarControl.h"
@interface YCCommentCell : UITableViewCell
///头像
@property (weak, nonatomic)IBOutlet YCAvatarControl *avatarControl;
///大图片
@property (weak, nonatomic) IBOutlet UIImageView *imagvIcon;
///标题
@property (weak, nonatomic) IBOutlet UILabel *lTitle;
///内容
@property (weak, nonatomic) IBOutlet UILabel *lInfo;
///果单创建时间
@property (weak, nonatomic)IBOutlet UILabel *lTimer;
@end
