//
//  UserInfoDataModel.m
//  SmartKitchen
//
//  Created by LICAN LONG on 16/1/31.
//  Copyright © 2016年 LICAN LONG. All rights reserved.
//

#import "UserInfoDataModel.h"

@implementation UserInfoDataModel

- (instancetype)init {
    NSLog(@"UserInfoDataModel init");
    self = [super init];
    if (self) {
        _accessToken = @"";
        _userId = @"";
        _nickname = @"";
        _sex = @"";
        _mobile = @"";
        _avatarURL = @"";
        _account = @"";
        _password = @"";
        _OAuthName = @"";
        _openid = @"";
    }
    return self;
}

@end

@implementation UserInfoDatas

@end
