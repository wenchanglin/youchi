//
//  YCPushManager.m
//  YouChi
//
//  Created by sam on 15/6/25.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPushManager.h"
#import "YCDefines.h"
#import <Toast/UIView+Toast.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import "AppDelegate.h"
#import "YCGroupPurchaseMainVC.h"
#import "YCMyCouponVC.h"
#define Push_Type @"Push_Type"

@implementation YCPushM
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [self modelEncodeWithCoder:aCoder];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder; // NS_DESIGNATED_INITIALIZER
{
    if (self = [super init]) {
        [self modelInitWithCoder:aDecoder];
    }
    return self;
}
@end

@interface YCPushManager ()
@property (nonatomic,strong) NSString *lastAlias;

@end

@implementation YCPushManager
{
    NSMutableSet *_pushes;
}
- (void)dealloc
{
    
}

+ (YCPushManager *)sharedPushManager {
    static YCPushManager *_sharedManager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc]init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pushes = [NSMutableSet set];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userDefaultLogin:) name:YCUserDefaultUpdate object:nil];
        [UMessage setAutoAlert:NO];
        //for log
#if DEBUG
        [UMessage setLogEnabled:YES];
#endif
    }
    return self;
}

- (void)userDefaultLogin:(NSNotification *)noti
{
    YCLoginM *login = noti.object;
    [self onBindAlias:login.appUser.loginId];
}

///绑定用户别名
- (void)onBindAlias:(NSString *)loginId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.lastAlias.length>0) {
            [UMessage removeAlias:self.lastAlias type:Push_Type response:^(id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"removeAlias error = %@",error.localizedDescription);
                } else {
                    NSLog(@"remove Alias ok = %@",responseObject);
                }
            }];
        }
        
        if (loginId.length>0) {
            self.lastAlias = loginId;
            [UMessage setAlias:self.lastAlias type:Push_Type response:^(id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"setAlias error = %@",error.localizedDescription);
                } else {
                    NSLog(@"set Alias ok = %@",responseObject);
                }
            }];
        }
        
    });
}


///启动个推 SDK
- (void)addPushWithOptions:(NSDictionary *)launchOptions
{
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UM_push_app_key launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"accept";
        action1.title= @"接受";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"refuse";
        action2.title= @"拒绝";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
}

///移除通知
- (void)removePush
{
    [UMessage unregisterForRemoteNotifications];
}


#pragma mark -
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    [UMessage sendClickReportForRemoteNotification:userInfo];
    
    YCPushM *push = [YCPushM modelWithDictionary:userInfo];
    
    //在界面里
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    //在后台
    else {
        UIWindow *app = [UIApplication sharedApplication].keyWindow;
        if (push.originalType == YCMessageTypeCUIKUAN) {
            YCGroupPurchaseMainVM *vm = [[YCGroupPurchaseMainVM alloc]initWithParameters:@{@"groupBuyId":@(push.originalAction)}];
            vm.isSponsor = NO;
            YCGroupPurchaseMainVC *vc =[YCGroupPurchaseMainVC vcClass];
            vc.viewModel = vm;
            @weakify(vc);
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
            [app.rootViewController presentViewController:nc animated:YES completion:^{
                [vc.navigationItem.leftBarButtonItem setActionBlock:^(id _Nonnull bbi) {
                    @strongify(vc);
                    [vc dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
        }
        
        if (push.originalType == YCMessageTypeCOUPON) {
            YCMyCouponVC *vc = [YCMyCouponVC vcClass];
            @weakify(vc);
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
            [app.rootViewController presentViewController:nc animated:YES completion:^{
                [vc.navigationItem.leftBarButtonItem setActionBlock:^(id _Nonnull bbi) {
                    @strongify(vc);
                    [vc dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
        }
    }
    

    self.hasNewMessage = YES;
    
    if (push.originalType == YCMessageTypeCOUPON) {
        self.hasNewCoupon = YES;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:YCReceivePushNotification object:push];
}


///暂时用不到
- (BOOL)hasPushesByType:(YCMessageType)type
{
    __block BOOL has = NO;
    [_pushes enumerateObjectsUsingBlock:^(YCPushM * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.originalType == type) {
            has = YES;
            *stop = YES;
        }
    }];
    return NO;
}

- (void)removePushesByType:(YCMessageType)type
{
    [_pushes enumerateObjectsUsingBlock:^(YCPushM * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.originalType == type) {
            [_pushes removeObject:obj];
        }
    }];
}
@end
