//
//  YCAvatarInforView.h
//  YouChi
//
//  Created by 朱国林 on 15/8/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAvatar.h"
/**
 头像View
 */

@interface YCAvatarControl : UIControl
/// 头像
@property (strong, nonatomic) YCAvatar *icon;
/// 名字
@property (strong, nonatomic) UILabel *name;
/// 签名
@property (strong, nonatomic) UILabel *sign;
/// 性别
@property (strong, nonatomic) UIImageView *sex;
/// 是否隐藏性别
@property (assign, nonatomic) BOOL isSexHidden;
/// 是否剪切头像
@property (assign, nonatomic) IBInspectable BOOL isClipAvatar;
/// 是否隐藏签名
@property (assign, nonatomic) BOOL isSignHidden;
/// 头像的高度
@property (assign, nonatomic)CGFloat iconHeight;
- (void)updateAvatarControlWith:(NSString *)icon name:(NSString *)name sign:(NSString *)sign sex:(id)sex;
- (void)updateAvatarControlWith:(NSString *)icon name:(NSString *)name sign:(NSString *)sign;
- (void)updateComment:(id)model;
@end


/**
 评论View有时间
 */
IB_DESIGNABLE@interface YCCenterAvatarControl : YCAvatarControl
/// 时间
@property (strong, nonatomic) UILabel *timer;
- (void)updateAvatarControlWith:(NSString *)iconUrlString name:(NSString *)name timer:(NSString *)timer;
@end


/**
 友米兑换View
 */
IB_DESIGNABLE@interface YCExchangeAvatarControl : YCAvatarControl
/// 如何获取友米?---->按钮
@property (strong, nonatomic) UIButton *btnAchieveYouMi;


- (void)updateAvatar:(NSURL *)icon Name:(NSString *)name hasYouMi:(NSInteger)youmi;
@end



