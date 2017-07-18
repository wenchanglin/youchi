//
//  YCFindPassWordVM.m
//  YouChi
//
//  Created by 李李善 on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFindPassWordVM.h"
#import "YCFindPassWordM.h"
#import <Regexer/Regexer.h>

@implementation YCFindPassWordVM
- (void)dealloc{
    //ok
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (BOOL)_validateAccount
{
    NSString *phoneReg = @"^[1][3-8]+\\d{9}";
    NSString *emailReg = @"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$";
    
    BOOL p = [self.loginIdm rx_matchesPattern:phoneReg];
    BOOL e = [self.loginIdm rx_matchesPattern:emailReg];
    return (!p && !e);
    
}

- (BOOL)_validatePassword
{
    
    NSString *psw =[self.Onepasswordm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *psw2 =[self.TWopasswordm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL valid = [psw isEqualToString:self.Onepasswordm] && psw.length>=6 &&[psw isEqualToString:psw2];
    
    return valid;
    
}

///获取验证码
- (RACSignal *)getSmsCodeSignal{
    CHECK_SIGNAL(self.loginIdm.length == 0, @"请输入正确的电话号码或电子邮件");
    
    return [ENGINE POST_shop_object:apiGetSmsCode parameters:@{kLoginId:self.loginIdm} parseClass:nil parseKey:nil];
}

///找回密码
- (RACSignal *)FindPassWordSignal{
    CHECK_SIGNAL(self.loginIdm.length == 0, @"请输入正确的电话号码或电子邮件");
    CHECK_SIGNAL(self.smsCodem.length == 0, @"请输入验证码");
    CHECK_SIGNAL(self.Onepasswordm.length == 0, @"请输入新密码");
    CHECK_SIGNAL(self.TWopasswordm.length == 0, @"请再次输入新密码");
    CHECK_SIGNAL(![self.TWopasswordm isEqualToString:self.Onepasswordm], @"密码不一致");
    
    return [ENGINE POST_shop_object:apiFindPassword parameters:@{
                                                                 kLoginId:self.loginIdm,
                                                                 kSmsCode:self.smsCodem,
                                                                 kPassword:self.TWopasswordm,
                                                                 
                                                                 } parseClass:[YCLoginM class] parseKey:nil];
}


@end
