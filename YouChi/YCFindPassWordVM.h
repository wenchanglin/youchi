//
//  YCFindPassWordVM.h
//  YouChi
//
//  Created by 李李善 on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"

@interface YCFindPassWordVM : YCPageViewModel
@property (nonatomic,strong) NSString *loginIdm,*smsCodem,*Onepasswordm,*TWopasswordm,*MeToKen;
@property (nonatomic,assign) BOOL isCodeValidm;
- (RACSignal *)getSmsCodeSignal;///获取验证码

- (RACSignal *)FindPassWordSignal;///找回密码
@end
