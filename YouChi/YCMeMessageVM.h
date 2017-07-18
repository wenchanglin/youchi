//
//  YCMeMessageVM.h
//  YouChi
//
//  Created by 李李善 on 15/6/3.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCLoginM.h"
#import "YCMeM.h"
#define SEX(s)  s?@"男":@"女"
@interface YCMeMessageVM : YCViewModel

///头像
@property (strong, nonatomic)  NSString *avatar;
///名字
@property (strong, nonatomic)  NSString *name;
///出生
@property (strong, nonatomic)  NSDate *birthDay;
///签名
@property (strong, nonatomic)  NSString *signture;
///邮箱
@property (strong, nonatomic)  NSString *email;
///电话号码
@property (strong, nonatomic)  NSString *phoneNum;
@property (assign, nonatomic) BOOL sex;

///youchiID
@property (strong, nonatomic)  NSNumber *youId;
///youchiuserId
@property (strong, nonatomic)  NSNumber *youUserId;



- (RACSignal *)saveSignal:(NSString *)key value:(id)value;
- (RACSignal *)uploadAvatarSignal:(UIImage *)img;
- (RACSignal *)validatePhoneSignal:(NSString *)phone smsCode:(NSString *)code;
- (RACSignal *)getSmsCodeSignal:(NSString *)phone;
@end
