//
//  ChatUserDataModel.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/10/27.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUserDataModel : NSObject

@property (strong,nonatomic) NSString * avatar;
@property (strong,nonatomic) NSString * exp;
@property (strong,nonatomic) NSString * Id;
@property (strong,nonatomic) NSString * nickname;
@property (strong,nonatomic) NSString * regtime;
@property (strong,nonatomic) NSString * sex;
@property (strong,nonatomic) NSString * username;

@end

@interface ChatUserDatas : NSObject
@property (nonatomic, strong) NSArray *datas;
@end
