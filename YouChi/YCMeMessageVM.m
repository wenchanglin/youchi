//
//  YCMeMessageVM.m
//  YouChi
//
//  Created by 李李善 on 15/6/3.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMeMessageVM.h"
#import "YCUserCommentM.h"
#import "YCGuopinDetailM.h"
@implementation YCMeMessageVM
-(void)dealloc
{
    //OK
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        YCLoginUserM *m = [YCUserDefault currentUser].appUser;
        [self _update:m];
        
        
    }
    return self;
}

- (instancetype)initWithModel:(YCBaseModel *)model
{
    self = [super initWithModel:model];
    if (self) {
        if ([model isKindOfClass:[YCUserCommentM class]]) {
            YCUserCommentM *M = (YCUserCommentM *)model;
            self.youId = M.Id;
            self.youUserId= M.userId;
            self.Id = M.Id;
        }
        
    }
    return self;
}


- (void)_update:(YCLoginUserM *)m{
    self.avatar = m.imagePath;
    self.name = [m.nickName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.birthDay = m.birthDay;
    self.signture = m.signature;
    self.email = m.email;
    self.phoneNum = m.phone;
    self.sex = m.sex.boolValue;
}





- (RACSignal *)saveSignal:(NSString *)key value:(id)value
{
    WSELF;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    param[kToken] = [YCUserDefault currentToken];
    
    param[key] = value;
    
    return [[[ENGINE POSTBool:apiSavePersonalInfo parameters:param] doNext:^(id x) {
        SSELF;
        YCUserDefault *ud = [YCUserDefault standardUserDefaults];
        YCLoginM *user = [YCUserDefault currentUser];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [param enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [user.appUser setValue:obj forKey:key];
            }];
            user.appUser.birthDay = self.birthDay;
            [self _update:user.appUser];
        });
        
        
        [ud saveUser:user];
        [ud updateCurrentUser:user];
    }] subscribeOn:[RACScheduler mainThreadScheduler]];
}



- (RACSignal *)uploadAvatarSignal:(UIImage *)img
{
    WSELF;
    NSData *data = UIImageJPEGRepresentation(img, QUALITY);
    return [[ENGINE POSTImage:apiGSavePersonal parameters:@{
                                                            kToken:[YCUserDefault currentToken],
                                                            } data:data parseClass:[YCMeM class] parseKey:@"appUser"]doNext:^(YCMeM *x) {
        
        SSELF;
        
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache setImage:img forKey:x.imagePath];
        self.avatar = x.imagePath;
        
        YCUserDefault *ud = [YCUserDefault standardUserDefaults];
        YCLoginM *user = [YCUserDefault currentUser];
        user.appUser.imagePath = x.imagePath;
        [ud saveUser:user];
        [ud updateCurrentUser:user];
    }];
}

- (RACSignal *)validatePhoneSignal:(NSString *)phone smsCode:(NSString *)code
{
    return [ENGINE POSTBool:apiValidatePhone parameters:
                                                 @{kToken:[YCUserDefault currentToken],
                                                   @"phone":phone,
                                                    @"smsCode":code}];
}


/**
 *
 * SSELF;
 self.phoneNum = phone;
 YCUserDefault *ud = [YCUserDefault standardUserDefaults];
 YCLoginM *user = [YCUserDefault currentUser];
 user.appUser.phone = phone;
 [ud saveUser:user];
 [ud updateCurrentUser:user];
 */
- (RACSignal *)getSmsCodeSignal:(NSString *)phone
{
    return [ENGINE POSTBool:apiAccessGetSmsCode parameters:@{kLoginId:phone}];
}







@end
