//
//  AppDelegate.m
//  YouChi
//
//  Created by sam on 15/4/28.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "AppDelegate.h"
#import "YCHttpClient.h"
#import "YCUserDefault.h"
#import "YCDefines.h"

#import <EDColor/EDColor.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "UMSocial.h"

#import "WXApi.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import <MobClick.h>

#import "YCPushManager.h"

#import "YCRecipeDetailVC.h"
#import "YCYouChiDetailVC.h"
#import "YCErweimaVC.h"

#import "DataSigner.h"
#import "DataVerifier.h"

#import "YCSwitchTabControl.h"
#import <PhotoEditFramework/PhotoEditFramework.h>
#import <RNCachingURLProtocol/RNCachingURLProtocol.h>
#import <AlipaySDK/AlipaySDK.h>
#import <KMCGeigerCounter/KMCGeigerCounter.h>

@interface AppDelegate () <UIAlertViewDelegate,WXApiDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // Override point for customization after application launch.
    NSLog(@"%d",SETTING);
    [self _setupAppearance];
    
    [self _setupAPNS:launchOptions];
    
    //TODO:注视首页
    [self _setupIntroduction];
    
    [self _setupAccount];
    
    [self _setupUMShare];
    
    [self _setupIQKeyboardManager];
    
    
    
    [self _setupPGY];
    
    //[self _setupUMfenxi];
    
    [self _setup360Camera];
    
    [self _setupWeixinPay];
    
    [self _checkAppUpdate];
    
    
    
    //Memory capacity: 4 megabytes (4 * 1024 * 1024 bytes)
    //Disk capacity: 20 megabytes (20 * 1024 * 1024 bytes)
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    urlCache.memoryCapacity =  20*1024*1024;
    urlCache.diskCapacity =  200*1024*1024;
    
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    
    [SVProgressHUD setForegroundColor:[UIColor lightGrayColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:SVProgressHUDDidReceiveTouchEventNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [SVProgressHUD dismiss];
    }];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserverForName:YCHttpClientProgress object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        NSProgress *progress = note.object;
        double fractionCompleted = progress.fractionCompleted;
        [SVProgressHUD showProgress:fractionCompleted status:[[NSString alloc]initWithFormat:@"正在上传%.2f%@",fractionCompleted*100,@"%"]];
    }];
    
    //[NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    
    //*/
    
    return YES;
}

- (void)_setupAccount
{
    YCUserDefault *ud = [YCUserDefault standardUserDefaults];
    YCLoginM *login = [ud loadUser];
    if (login) {
        
        [ud updateCurrentUser:login];
        YCHttpClient *client = [YCHttpClient sharedClient];
        [client changeLoginId:[ud lastLoginId] andAppLoginId:login.appUser.loginId];
    }
}


- (void)_setupAppearance
{
    //    UIColor *tintYellow = [UIColor colorWithHexString:@"#ffca26"];
    UIColor *tintYellow = KBtnSelecotColor;
    //    UIColor *tintBrown = [UIColor colorWithHexString:@"#535353"];
    
    //UIColor *tintBrown = [UIColor colorWithHexString:@"e5e5e5"];
    
    
    UIColor *whiteColor = [UIColor whiteColor];
    //UIColor *selectedColor = [UIColor lightGrayColor];
    
    UIColor *navBackgroundColor = [UIColor blackColor];//[UIColor colorWithHexString:@"#272636"];
    //UIColor *backgroundColor = [UIColor colorWithHexString:@"#B5B5B5"];
    
    //点
    [UISwitch appearance].onTintColor = color_btnGold;
    
    
    [UIPageControl appearance].pageIndicatorTintColor = [UIColor lightGrayColor];;
    
    [UIPageControl appearance].currentPageIndicatorTintColor = tintYellow;
    
    //
    UIBarButtonItem *bbi = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    
    bbi.tintColor = color_yellow;
    
    [bbi setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName: color_yellow,
                                  NSFontAttributeName: [UIFont systemFontOfSize:15],
                                  } forState:UIControlStateNormal];
    
    [bbi setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                  } forState:UIControlStateDisabled];
    
    UITabBar *tb = [UITabBar appearance];
    tb.tintColor = tintYellow;
    tb.barTintColor = [UIColor whiteColor];
    
    
    
    UITabBarItem *tbi = [UITabBarItem appearance];
    [tbi setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName: tintYellow,
                                  NSFontAttributeName: [UIFont systemFontOfSize:10.0],
                                  } forState:UIControlStateSelected];
    [tbi setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSFontAttributeName: [UIFont systemFontOfSize:10.0],
                                  } forState:UIControlStateNormal];
    
    
    UIBarItem *bi = [UIBarItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    
    [bi setTitleTextAttributes:@{
                                 NSForegroundColorAttributeName: whiteColor,
                                 NSFontAttributeName: [UIFont systemFontOfSize:10],
                                 } forState:UIControlStateNormal];
    
    
    
    //导航栏
    
    UINavigationBar *nb = [UINavigationBar appearance];
    
    nb.titleTextAttributes = @{
                               NSForegroundColorAttributeName: tintYellow,
                               NSFontAttributeName: [UIFont systemFontOfSize:18],
                               };
    nb.barTintColor = navBackgroundColor;
    
    YCSwitchTabControl *stc = [YCSwitchTabControl appearance];
    stc.normalColor = [UIColor lightGrayColor];
    stc.selectedColor = color_yellow;
    stc.segmentFont = KFontBold(14);
    self.window.backgroundColor = [UIColor blackColor];
}
//pod update --no-repo-update

- (void)_setupUMShare
{
    //如果账号不对，无法分享或第三方登陆，先打开log，
    //[UMSocialData openLog:YES];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMAppKey];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:UMWeixinKey appSecret:UMWeixinSecret url:html5];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:UMQQKey appKey:UMQQSecret url:html5];
    [UMSocialQQHandler setSupportWebView:YES];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
}

- (void)_setupIQKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldShowTextFieldPlaceholder = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.canAdjustTextView = YES;
    manager.enable = YES;
}

- (void)_setupAPNS:(NSDictionary *)launchOptions
{
    
    // [2]:注册APNS
    [[YCPushManager sharedPushManager]addPushWithOptions:launchOptions];
    
    // [2-EXT]: 获取启动时收到的APN
    UIApplication *application = [UIApplication sharedApplication];
    
    //设定BackgroundFetch的频率
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    NSDictionary* dic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (dic) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:YCReceivePushNotification object:dic];
        
        
        
    }
    [application cancelAllLocalNotifications];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        if (application.applicationIconBadgeNumber != 0) {
            application.applicationIconBadgeNumber = 0;
        }
    }
    
}

- (void)_registerRemoteNotification
{
    [[YCPushManager sharedPushManager]addPushWithOptions:nil];
}

- (void)_unregisterRemoteNotification
{
    [[YCPushManager sharedPushManager]removePush];
}

- (void)_setupPGY
{
    
}

- (void)_setupIntroduction
{
    if (!self.window) {
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.window makeKeyAndVisible];
        __weak AppDelegate *weakSelf = self;
        
        UIViewController *mainVC = [UIViewController vcByStoryboardWithName:@"YCMainVC"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        NSString *isNotFirst = info[@"CFBundleShortVersionString"];
        BOOL isNotFirstValue = [userDefaults boolForKey:isNotFirst];
        if ( isNotFirstValue == YES) {
            self.window.rootViewController = mainVC;
            return;
        }
        
        [userDefaults setBool:!isNotFirstValue forKey:isNotFirst];
        
        NSArray *backgroundImageNames = @[@"吃货营介绍", @"发现介绍", @"友吃商城介绍"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"进入" forState:UIControlStateNormal];
        
        
        self.introductionVC = [[YCIntroductionVC alloc] initWithCoverImageNames:backgroundImageNames backgroundImageNames:nil button:btn];
        
        
        self.window.rootViewController = self.introductionVC;
        self.introductionVC.didSelectedEnter = ^() {
            
            [UIView animateWithDuration:1.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.introductionVC.view.alpha = 0.2f;
                weakSelf.introductionVC.view.transform = CGAffineTransformMakeScale(1.08, 1.08);
            } completion:^(BOOL finished) {
                [weakSelf.introductionVC.view removeFromSuperview];
                weakSelf.introductionVC = nil;
                weakSelf.window.rootViewController = mainVC;
            }];
            
        };
    }
}

- (void)_setupUMfenxi
{
    
    // 开启
    [MobClick setAppVersion:XcodeAppVersion];
    
    [MobClick startWithAppkey:UManalyseAppKey reportPolicy:BATCH channelId:nil];
    
    [MobClick setBackgroundTaskEnabled:YES];
    
    [MobClick setEncryptEnabled:YES];
    
    
}

- (void)_setupWeixinPay
{
    [WXApi registerApp:WX_APP_ID];
}

- (void)_setup360Camera
{
#if TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
    // 360 相机
    [pg_edit_sdk_controller sStart:Camera360Key];
#endif
}

#pragma mark - 检查更新
-(void)_checkAppUpdate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APP_ID]];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (!data) {
            return ;
        }
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        jsonDict = [jsonDict[@"results"] firstObject];
        
        if (!error && jsonDict) {
            
            
            NSString *newVersion =jsonDict[@"version"];
            NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            
            NSString *dot = @".";
            NSString *whiteSpace = @"";
            int newV = [newVersion stringByReplacingOccurrencesOfString:dot withString:whiteSpace].intValue;
            int nowV = [nowVersion stringByReplacingOccurrencesOfString:dot withString:whiteSpace].intValue;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(newV > nowV)
                {
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:jsonDict[@"releaseNotes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
                    [alert show];
                    
                    
                    
                }
                
            });
        }
    });
    
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?ls=1&mt=8", APP_ID]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void) showAlertWithMessage:(NSString *) message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本有更新" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //行间距
    paragraphStyle.lineSpacing = 5.0;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13.0], NSParagraphStyleAttributeName : paragraphStyle};
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:message];
    [attributedTitle addAttributes:attributes range:NSMakeRange(0, message.length)];
    [alertController setValue:attributedTitle forKey:@"attributedMessage"];//attributedTitle\attributedMessage
    
    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"取消"
                                                             style: UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               
                                                           }];
    UIAlertAction *defaultAction2 = [UIAlertAction actionWithTitle:@"更新"
                                                             style: UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *action) {
                                                               
                                                               NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?ls=1&mt=8", APP_ID]];
                                                               [[UIApplication sharedApplication] openURL:url];
                                                               [alertController dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
    
    [alertController addAction:defaultAction1];
    [alertController addAction:defaultAction2];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:alertController animated: YES completion: nil];
    
    
}

#pragma mark - 友盟跳转

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == NO) {
        //调用其他SDK，例如支付宝SDK等
        if ([url.absoluteString hasPrefix:@"wx"]) {
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    WSELF;
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == NO) {
        //调用其他SDK，例如支付宝SDK等
        if ([url.absoluteString hasPrefix:@"wx"]) {
            return [WXApi handleOpenURL:url delegate:self];
        }
        
        else {
            if ([url.host isEqualToString:@"safepay"]) {
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    SSELF;
                    //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                    NSLog(@"[AlipaySDK defaultService] processOrderWithPaymentResult result = %@",resultDic);
                    NSString *memo = resultDic[@"memo"];
                    int resultStatus = [resultDic[@"resultStatus"] intValue];
                    
                    
                    if (resultStatus == 9000) {
                        [self.alipaySignal sendNext:nil];
                        [self.alipaySignal sendCompleted];
                    } else {
                        [self.alipaySignal sendError:[NSError errorWithDomain:error_domain_aliplay code:0 userInfo:@{NSLocalizedDescriptionKey:memo?:@"未知错误"}]];
                    }
                }];
            }
            if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
                
                [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                    SSELF;
                    //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                    NSLog(@"[AlipaySDK defaultService] processAuthResult result = %@",resultDic);
                    NSString *memo = resultDic[@"memo"];
                    int resultStatus = [resultDic[@"resultStatus"] intValue];
                    
                    
                    if (resultStatus == 9000) {
                        [self.alipaySignal sendNext:nil];
                        [self.alipaySignal sendCompleted];
                    } else {
                        [self.alipaySignal sendError:[NSError errorWithDomain:error_domain_aliplay code:0 userInfo:@{NSLocalizedDescriptionKey:memo?:@"未知错误"}]];
                    }
                }];
            }
            
            return YES;
        }
    }
    return result;
}

#pragma mark - 系统生命周期

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[GeTuiSdk resume];
    
    /// 通知返回前台
    NSNotification *notification =[NSNotification notificationWithName:YCBecomeActive object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 推送

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }
    
    UIUserNotificationType types = notificationSettings.types;
    if (types != UIUserNotificationTypeNone) {
        if (application.applicationIconBadgeNumber != 0) {
            //application.applicationIconBadgeNumber = 0;
        }
    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    NSLog(@"NotificationsWithError %@",error.localizedDescription);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //
    //    NSString *deviceTokenString = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //
    
    // [3]:向服务器注册deviceToken
    [[YCPushManager sharedPushManager]didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"remoteNotification:%@",userInfo);
    [[YCPushManager sharedPushManager]didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"remoteNotification_fetchCompletionHandler:%@",userInfo);
    [[YCPushManager sharedPushManager]didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = application.applicationState;
    if (state != UIApplicationStateActive ) {
        if (application.applicationIconBadgeNumber > 0) {
            application.applicationIconBadgeNumber --;
        }
        
        [application cancelLocalNotification:notification];
    }
    
}

#pragma mark -


- (void)shouldRegisterRemoteNotification:(BOOL)b
{
    if (b) {
        [self _registerRemoteNotification];
    } else {
        [self _unregisterRemoteNotification];
    }
}

- (WTATagStringBuilder *)builder
{
    if (!_builder) {
        WTATagStringBuilder *builder = [WTATagStringBuilder new];
        [builder addAttribute:NSForegroundColorAttributeName value:KBGCColor(@"#65656d") tag:@"color"];
        [builder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] tag:@"font"];
        _builder = builder;
    }
    return _builder;
}

- (RACSubject *)weixinSignal
{
    if (!_weixinSignal) {
        _weixinSignal = [RACSubject subject];
    }
    return _weixinSignal;
}

- (RACSubject *)alipaySignal
{
    if (!_alipaySignal) {
        _alipaySignal = [RACSubject subject];
    }
    return _alipaySignal;
}

#pragma mark -
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req;
{
    
}


/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp;
{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        PayResp *payRep = (PayResp *)resp;
        NSLog(@"wxresp = %d %@",payRep.errCode,payRep.returnKey);
        if (resp.errCode == WXSuccess) {
            [self.weixinSignal sendNext:payRep.returnKey];
            [self.weixinSignal sendCompleted];
        }
        
        else {
            NSString *errorStr = @"其它未知错误";
            switch (resp.errCode) {
                case -1:
                    errorStr = @"普通错误";
                    break;
                case -2:
                    errorStr = @"用户点击取消并返回";
                    break;
                case -3:
                    errorStr = @"发送失败";
                    break;
                case -4:
                    errorStr = @"授权失败";
                    break;
                case -5:
                    errorStr = @"微信不支持";
                    break;
                    
                default:
                    break;
            }
            [self.weixinSignal sendError:[NSError errorWithDomain:error_domain_weixin code:0 userInfo:@{NSLocalizedDescriptionKey:errorStr}]];
        }
    }
}


@end


