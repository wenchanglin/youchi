//
//  YCChihuoyingFourCell.h
//  YouChi
//
//  Created by 李李善 on 15/5/29.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCChihuoyingCell.h"
#import "YCAvatar.h"

///秘籍
@interface YCChihuoPhotoCell : YCChihuoyingCell

@property (weak, nonatomic) IBOutlet UILabel *title;
///内容图片
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
///发的人头像
@property (weak, nonatomic) IBOutlet YCAvatar *avatar;
// 横线
@property (weak, nonatomic) IBOutlet UIView *line;
@end
