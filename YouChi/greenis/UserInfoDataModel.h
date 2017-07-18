//
//  UserInfoDataModel.h
//  SmartKitchen
//
//  Created by LICAN LONG on 16/1/31.
//  Copyright © 2016年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoDataModel : NSObject

@property (strong,nonatomic) NSString  *accessToken;
@property (strong,nonatomic) NSString  *userId;
@property (strong,nonatomic) NSString  *nickname;
@property (strong,nonatomic) NSString  *sex;
@property (strong,nonatomic) NSString  *mobile;
@property (strong,nonatomic) NSString  *avatarURL;
@property (strong,nonatomic) NSString  *account;
@property (strong,nonatomic) NSString  *password;
@property (strong,nonatomic) NSString  *OAuthName;
@property (strong,nonatomic) NSString  *openid;

@end

@interface UserInfoDatas : NSObject
@property (nonatomic, strong) NSArray *datas;
@end
