//
//  YCUserDefault.m
//  YouChi
//
//  Created by sam on 15/5/25.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCUserDefault.h"

static NSString *kLastUser = @"lastUser";
static NSString *kAllUser = @"allUser";
static NSString *push = @"push";

NSString *YCUserDefaultUpdate = @"YCUserDefaultUpdate";
@interface YCUserDefault()
{
    NSUserDefaults *_userDefaults;
}
@property (nonatomic,strong) YCLoginM *login;
@property (nonatomic,strong) NSMutableArray *loginIds;

@end

@implementation YCUserDefault
-(void)dealloc{
    //    ok
    
}

+ (YCUserDefault *)standardUserDefaults {
    static YCUserDefault *_standardUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardUserDefaults = [[self alloc]init];
    });
    
    
    return _standardUserDefaults;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _login = [YCLoginM new];
        
        
        self.loginIds = ({
            NSMutableArray *loginIds = [_userDefaults arrayForKey:kAllUser].mutableCopy;
            
            if (!loginIds) {
                loginIds = [NSMutableArray new];
                [_userDefaults setObject:loginIds forKey:kAllUser];
            }
            
            loginIds;
        });
    }
    return self;
}

- (YCLoginM *)loadUser
{
    NSData *data = [_userDefaults objectForKey:apiLogin];
    if (data) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;

}

- (BOOL)saveUser:(YCLoginM *)login
{
    [_userDefaults removeObjectForKey:apiLogin];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:login];
    [_userDefaults setObject:data forKey:apiLogin];
    
    return [_userDefaults synchronize];
}

- (BOOL)saveUser
{
    return [self saveUser:self.login];
}

- (void)updateCurrentUser:(YCLoginM *)login
{
    self.login = login;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:YCUserDefaultUpdate object:login];
}



+ (YCLoginM *)currentUser
{
    return [self standardUserDefaults].login;
}

- (BOOL)isCurrentUserValid
{
    YCLoginM *login = self.login;
    YCLoginUserM *loginUser = login.appUser;
    BOOL b = (loginUser.loginId.length >0 && login.token.length >0);
    return b;
}

- (BOOL)isMoneyUserValid
{
    YCLoginM *login = self.login;
    YCLoginUserM *loginUser = login.appUser;
    BOOL b = (loginUser.loginId.length >0 && login.token.length >0&&login.appUser.balance ==nil &&loginUser.balance ==nil);
    return b;

}


- (BOOL)addCurrentUser:(YCLoginM *)login forLoginId:(NSString *)loginId
{
    if (loginId) {
        if (![self.loginIds containsObject:loginId]) {
            [self.loginIds addObject:loginId];
            [_userDefaults setObject:self.loginIds forKey:kAllUser];
        }
    }
    
    [self updateCurrentUser:login];
    BOOL b =  [self saveUser:login];
    return b;
}

- (BOOL)addCurrentUser:(YCLoginM *)login
{
    return [self addCurrentUser:login forLoginId:nil];
}

- (BOOL)removeCurrentUser
{
    
    [self updateCurrentUser:nil];
    BOOL b = [self saveUser:nil];
    return b;
}

- (NSString *)loadPasswordForUser:(YCLoginM *)login
{
    return [self loadPasswordForLoginId:login.appUser.loginId];
}

- (NSString *)loadPasswordForLoginId:(NSString *)loginId
{
    if (![loginId isKindOfClass:[NSString class]]) {
        return nil;
    }
    UICKeyChainStore *kcs = [UICKeyChainStore keyChainStore];
    NSString *cid = [kcs stringForKey:loginId];
    return cid;
}

- (BOOL )savePassword:(NSString *)psw forUser:(YCLoginM *)login
{
    return [self savePassword:psw forLoginId:login.appUser.loginId];
}

- (BOOL)savePassword:(NSString *)psw forLoginId:(NSString *)loginId
{
    if (![loginId isKindOfClass:[NSString class]]) {
        return NO;
    }
    UICKeyChainStore *kcs = [UICKeyChainStore keyChainStore];
    [kcs setString:psw forKey:loginId];
    return YES;
}

+ (NSString *)currentToken
{
    NSString *token = [YCUserDefault currentUser].token;

    return token?:@"";

}

+ (NSString *)currentLoginId
{
    NSString *loginId = [YCUserDefault currentUser].appUser.loginId;
    return loginId?:@"";
}

+ (NSNumber *)currentId
{
    id Id = [YCUserDefault currentUser].appUser.Id;
    return Id?:@0;
}



- (NSString *)lastLoginId
{
    return [_userDefaults stringForKey:kLastUser];
}

- (BOOL)setlastLoginId:(NSString *)loginId
{
    [_userDefaults setObject:loginId forKey:kLastUser];
    return [_userDefaults synchronize];
}

- (NSArray *)allLoginIds
{
    return self.loginIds.copy;
}

- (BOOL)removeLoginId:(NSString *)loginId
{
    if ([self.loginIds containsObject:loginId]) {
        [self.loginIds removeObject:loginId];
        [_userDefaults setObject:self.loginIds forKey:kAllUser];
        return [_userDefaults synchronize];
    }
    return NO;
}
@end
