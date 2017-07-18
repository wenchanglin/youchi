//
//  YCUserDefault.h
//  YouChi
//
//  Created by sam on 15/5/25.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import "YCApis.h"
#import "YCLoginM.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

extern NSString *YCUserDefaultUpdate;
//extern NSString *YCUserDefaultLogin;

#define USER_DEFAULT [YCUserDefault standardUserDefaults]
@interface YCUserDefault : NSObject
+ (YCUserDefault *)standardUserDefaults;
- (void)updateCurrentUser:(YCLoginM *)login;

+ (YCLoginM *)currentUser;

- (YCLoginM *)loadUser;
- (BOOL)saveUser:(YCLoginM *)login;
- (BOOL)saveUser;

- (BOOL)addCurrentUser:(YCLoginM *)login forLoginId:(NSString *)loginId;
- (BOOL)addCurrentUser:(YCLoginM *)login;

- (BOOL)removeCurrentUser;
- (BOOL)isCurrentUserValid;
- (BOOL)isMoneyUserValid;

- (NSString *)loadPasswordForUser:(YCLoginM *)login;
- (NSString *)loadPasswordForLoginId:(NSString *)loginId;

- (BOOL )savePassword:(NSString *)psw forUser:(YCLoginM *)login;
- (BOOL )savePassword:(NSString *)psw forLoginId:(NSString *)loginId;

+ (NSString *)currentToken;
+ (NSString *)currentLoginId;
+ (NSNumber *)currentId;

- (NSString *)lastLoginId;
- (BOOL)setlastLoginId:(NSString *)loginId;

- (NSArray *)allLoginIds;
- (BOOL)removeLoginId:(NSString *)loginId;
@end
