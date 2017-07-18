//
//  YCYouChiShopVC.h
//  YouChi
//
//  Created by 李李善 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCYouChiShopVM.h"

#import "YCImagePlayerView.h"
#import "YCContainerControl.h"
#import "YCCenterButton.h"
#import "YCShopCategoryVC.h"
#import "YCWebVC.h"

#import "YCYouMiExchangeVC.h"
#import "YCMyCouponVC.h"
#import "YCMyOrderVC.h"
#import "YCItemDetailVC.h"
#import "YCMyCartVC.h"
#import "YCItemDetailVC.h"
#import "YCPhotosView.h"

#import "YCSearchVC.h"
#import "YCMyMoneyVC.h"
#import "AppDelegate.h"

#import "YCShopCategoryNameVC.h"
#import "YCView.h"
#import "YCPushManager.h"
#import "YCMessageVC.h"

#import "YCGroupPurchaseVCP.h"

#import "YCGroupPurchaseMainVC.h"
#import "YCAvatar.h"
#import "YCErweimaVC.h"

#import "YCLoginVC.h"

@interface YCYouChiShopVCP : YCViewController
@property (weak, nonatomic) IBOutlet YCContainerControl *floatBar;

@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@end

@interface YCYouChiShopVC : YCBTableViewController

@end

@interface YCYouChiShopPopVC : YCViewController_v1
PROPERTY_ASSIGN_REAODNLY UIViewController *fromVC;
PROPERTY_STRONG_READONLY NSArray<YCYouChiShopPopM *> *pages;
- (instancetype)initWithFromVC:(UIViewController *)fromVC pages:(NSArray<YCYouChiShopPopM *> *)pages;
- (void)popFromVC:(UIViewController *)vc;

@end