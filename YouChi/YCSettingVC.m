//
//  YCCeSheZhiVC.m
//  YouChi
//
//  Created by 李李善 on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSettingVC.h"
#import "YCMeMessageVC.h"
#import "YCSettingVM.h"

#import "YCChihuoyingVC.h"
#import "YCWebVC.h"
#import "YCLoginVC.h"
#import "AppDelegate.h"
#import <GBDeviceInfo/GBDeviceInfo.h>


#import "YCModifyPasswordVC.h"

@import StoreKit;
@interface YCSettingVC ()<SKStoreProductViewControllerDelegate>
@property (nonatomic,strong) YCSettingVM *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *loginOrLogout;
@property (weak, nonatomic) IBOutlet UISwitch *pushSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fontSwitch;
@end

@implementation YCSettingVC
@synthesize viewModel;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.isTabBarHidden) {
        [self hideTabbar];
    }
}
- (void)dealloc
{
  //OK
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //WSELF;
    //self.fontSwitch.tintColor = color_yellow;
 
    // 通知
    BOOL canPush;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {
        canPush = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
    } else {
        canPush =  [[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone;
    }
    
    self.pushSwitch.on = canPush ;
    
   [self.loginOrLogout setTitle:@"注销" forState:UIControlStateNormal]; 
}


#pragma mark --推送
- (IBAction)onSwitch:(UISwitch *)sender {
    [APP shouldRegisterRemoteNotification:sender.isOn];
}

#pragma mark --字体
- (IBAction)onSwitchFont:(UISegmentedControl *)sender {
    //[NSNotificationCenter defaultCenter]postNotificationName:<#(nonnull NSString *)#> object:<#(nullable id)#>
}




- (IBAction)logoutOrLogin:(UIButton *)sender {
    if ([self pushToLoginVCIfNotLogin]) {
        return;
    }
    WSELF;
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您要注销吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)] flattenMap:^RACStream *(id value) {
        SSELF;
        return self.viewModel.logoutSignal;
    }].deliverOnMainThread subscribeNext:^(id x) {
        SSELF;
        [self showMessage:@"已注销"];
    
        RDVTabBarController *tbc = self.rdv_tabBarController;
        
        [self performSelector:@selector(tbcSetSelectedIndex:) withObject:tbc afterDelay:0.5];
        } error:self.errorBlock];
    [av show];
}
- (void)tbcSetSelectedIndex:(RDVTabBarController *)tbc{

    tbc.selectedIndex = 0;
    [super onReturn];
}


#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要清空这些缓存吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        WSELF;
        [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
            [[NSURLCache sharedURLCache]removeAllCachedResponses];
            [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
            [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
            [[SDImageCache sharedImageCache]clearDisk];
            SSELF;
            [self showMessage:@"缓存删除成功!"];
        }];
        [av show];
    }

    else if (indexPath.row == 2) {
        [self openAppWithIdentifier:APP_ID];
    }
    
    else if (indexPath.row == 3) {
        YCModifyPasswordVC *vc = [YCModifyPasswordVC vcClass:[YCLoginVC class] vcId:NSStringFromClass([YCModifyPasswordVC class])];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if (indexPath.row == 4) {
        [self _checkAppUpdate];
    }
    
    
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
                    
                    
                    
                } else {
                    [self showMessage:@"已是最新版本"];
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

// 头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1;
}

- (void)openAppWithIdentifier:(NSString *)appId {
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;

    //微信 appId = @"414478124";

    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            
        }
        if (error) {
            [self showMessage:error.localizedDescription];
        }
    }];
    [self presentViewController:storeProductVC animated:YES completion:nil];
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end






