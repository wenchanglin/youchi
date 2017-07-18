//
//  YCLoginVM.m
//  YouChi
//
//  Created by 李李善 on 15/5/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLoginVM.h"
#import "UMSocial.h"

@implementation YCLoginVM
-(void)dealloc{
    //    ok
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        YCUserDefault *ud = [YCUserDefault standardUserDefaults];
        NSString *loginId = [ud lastLoginId];
        if (loginId) {
            self.loginId = loginId;
            self.password = [ud loadPasswordForLoginId:loginId];
        }
        
        self.loginIds = [ud allLoginIds].mutableCopy;
        
    }
    return self;
}




- (RACSignal *)loginSignal
{
    if (self.loginId.length==0) {
        return [RACSignal error:error(@"请输入电话号码或电子邮件")];
    }
    if (self.password.length==0) {
        return [RACSignal error:error(@"请输入密码")];
    }
    WSELF;
    return [[ENGINE POST_shop_object:apiLogin parameters:@{
                                               kLoginId:self.loginId,
                                               kPassword:self.password,
                                               } parseClass:[YCLoginM class]  parseKey:nil]doNext:^(YCLoginM *x) {
        SSELF;
        
        
        [ENGINE changeLoginId:self.loginId andAppLoginId:x.appUser.loginId];
        
        YCUserDefault *ud = [YCUserDefault standardUserDefaults];
        [ud setlastLoginId:self.loginId];
        
        [ud savePassword:self.password forLoginId:self.loginId];
        [ud addCurrentUser:x forLoginId:self.loginId];
        

    }];
}

- (RACSignal *)otherLoginSignal:(UIViewController *)vc type:(NSString *)platformName{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSArray *platformNames = @[UMShareToSina,UMShareToQQ,UMShareToWechatSession];
        NSAssert([platformNames containsObject:platformName], @"不支持该第三方登录平台");
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        
        snsPlatform.loginClickHandler(vc,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            //          获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
                NSMutableDictionary *param = [NSMutableDictionary new];
                if (snsAccount.userName) {
                    param[@"nickName"] =  snsAccount.userName;
                }
                
                if (snsAccount.iconURL) {
                    param[@"avatar"] = snsAccount.iconURL;
                }
                
                param[@"platformId"] = @([platformNames indexOfObject:platformName]);
                param[@"sex"] = @0;
                
                NSString *lid;
                if (![platformName isEqualToString:UMShareToWechatSession]) {
                    lid = snsAccount.usid;
                } else {
                    lid = snsAccount.unionId;
                }
                
                if (lid) {
                    param[kLoginId] = lid;
                    [subscriber sendNext:param];
                    [subscriber sendCompleted];
                }else {
                    [subscriber sendError:error(@"第三方登陆获取数据失败")];
                }
                
                
                
            } else {
                [subscriber sendError:response.error];
            }
            
            
        });
        return nil;

    }];
    
    return [signal flattenMap:^RACStream *(NSDictionary *param) {
        return [[ENGINE POST_shop_object:apiOtherLogin parameters:param parseClass:[YCLoginM class] parseKey:nil]doNext:^(YCLoginM *x) {
            NSString *lid = param[kLoginId];
            [ENGINE changeLoginId:lid andAppLoginId:x.appUser.loginId];
            
            YCUserDefault *ud = [YCUserDefault standardUserDefaults];
            [ud addCurrentUser:x forLoginId:nil];
            
        }];
        
    }];
}


- (NSString *)loadPasswordForLoginId:(NSString *)loginId
{
    return [[YCUserDefault standardUserDefaults]loadPasswordForLoginId:loginId];
}
@end
