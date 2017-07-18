//
//  YCRegisterVM.m
//  YouChi
//
//  Created by 李李善 on 15/5/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRegisterVM.h"
#import <Regexer/Regexer.h>
#import "YCLoginM.h"
#import <GBDeviceInfo/GBDeviceInfo.h>
@implementation YCRegisterVM
-(void)dealloc{
    //    ok
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (RACSignal *)registerAndLoginSignal
{
    CHECK_SIGNAL(!self.loginId, @"请填写账号");
    CHECK_SIGNAL(!self.smsCode, @"请填写验证吗");
    CHECK_SIGNAL(!self.password, @"请填写密码");
    
    GBDeviceInfo *info = [GBDeviceInfo deviceInfo];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    WSELF;
    NSDictionary *param = @{
                            @"channelId":@"apple",
                            kLoginId:self.loginId,
                            kSmsCode:self.smsCode,
                            kPassword:self.password,
                            @"clientType":@"IOS",
                            @"clientVersion":[[NSString alloc]initWithFormat:@"%@.%@",app_Version,app_build],
                            @"clientOsVersion":[[NSString alloc]initWithFormat:@"%d.%d",(int)info.osVersion.major,(int)info.osVersion.minor],
                            };
    return [[ENGINE POST_shop_object:apiRegister parameters:param parseClass:[YCLoginM class] parseKey:nil]doNext:^(YCLoginM *x) {
        SSELF;
        [ENGINE changeLoginId:self.loginId andAppLoginId:x.appUser.loginId];
        
        
        YCUserDefault *ud = [YCUserDefault standardUserDefaults];
        [ud setlastLoginId:self.loginId];
        [ud savePassword:self.password forLoginId:self.loginId];
        
        [ud addCurrentUser:x forLoginId:self.loginId];
        
        
        
    }];
}

- (RACSignal *)getSmsCodeSignal
{
    CHECK_SIGNAL(!self.loginId.length, @"请填写账号");
    return [ENGINE POST_shop_object:apiGetSmsCode parameters:@{kLoginId:self.loginId} parseClass:nil parseKey:nil];
}

@end
