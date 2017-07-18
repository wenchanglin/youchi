//
//  YCssss.h
//  YouChi
//
//  Created by 李李善 on 16/1/19.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAvatar.h"
IB_DESIGNABLE @interface YCAvatarView : UIView
/// 头像
@property (strong, nonatomic) YCAvatar *icon;
/// 名字
@property (strong, nonatomic) UILabel *name;
/// 签名
@property (strong, nonatomic) UILabel *sign;
/// 性别
@property (strong, nonatomic) UIImageView *sex;

- (void)updateAvatar:(NSURL *)icon Name:(NSString *)name hasYouMi:(NSString *)youmi;
@end

