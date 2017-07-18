//
//  YCPushManager.h
//  YouChi
//
//  Created by sam on 15/6/25.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YCUserDefault.h"
#import "UMessage.h"

#define PUSH_MANAGER [YCPushManager sharedPushManager]
@interface YCPushM : NSObject<NSCoding>
@property (nonatomic,assign) NSUInteger originalAction;
@property (nonatomic,assign) YCMessageType originalType;
@end

@interface YCPushManager : NSObject
@property (nonatomic,assign) BOOL hasNewMessage,hasNewCoupon;
+ (YCPushManager *)sharedPushManager;
- (void)addPushWithOptions:(NSDictionary *)launchOptions;
- (void)removePush;

///放在对应的appdelegate
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
///放在对应的appdelegate
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (BOOL)hasPushesByType:(YCMessageType )type;
- (void)removePushesByType:(YCMessageType )type;
@end
