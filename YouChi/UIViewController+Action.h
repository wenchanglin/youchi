//
//  ViewController+Action.h
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "YCCatolog.h"
#import "YCViewModel.h"
#import "YCUserDefault.h"

#import <Toast/UIView+Toast.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <RDVTabBarController/RDVTabBarController.h>
#import <LTNavigationBar/UINavigationBar+Awesome.h>
typedef NS_ENUM(NSUInteger,UIPopDirection) {
    UIPopDirectionUp,
    UIPopDirectionLeft,
    UIPopDirectionDown,
    UIPopDirectionRight,
};
@interface UIViewController(Action)
@property (nonatomic,assign) UIPopoverArrowDirection lastDirection;
@property (nonatomic,strong) UIView *blackView;

- (IBAction)onReturn;
- (IBAction)onDismissReturn;
- (IBAction)onPopToRootVC;
- (void)onReturnToGroupBuy;
- (IBAction)onUnwindTo:(UIStoryboardSegue *)unwindSegue;
- (IBAction)onReload:(UIRefreshControl *)sender;

- (void)showSlideMenu:(UIViewController *)vc from:(UIPopoverArrowDirection )d;

- (void)showSlideMenuFrom:(UIPopoverArrowDirection )d;
- (void)hideSlideMenu;

- (void)showmMidMessage:(NSString *)msg;
- (void)showTopMessage:(NSString *)msg;
- (void)showMessage:(NSString *)msg;

- (void)showTabbar;
- (void)hideTabbar;
- (void)adjustContentIn:(UIScrollView *)scrollView;

- (BOOL)pushToLoginVCIfNotLogin;
@end


@interface UIViewController(Segue)
@property (nonatomic,weak) UIViewController *pushedViewController;
- (id )vcClassWithIdentifier:(NSString *)identifier;
+ (instancetype )vcByStoryboardWithName:(NSString *)name;
+ (instancetype )vcClass;
+ (instancetype )vcClass:(Class)ViewControllerClass;

+ (instancetype )vcClass:(Class)ViewControllerClass vcId:(NSString *)vcId;

- (void)pushToSBName:(NSString *)sbName;
- (void)pushTo:(Class )ViewControllerClass;
- (void)pushTo:(Class)ViewControllerClass viewModel:(id)viewModel;
- (void)pushTo:(Class)ViewControllerClass viewModel:(id)viewModel hideTabBar:(BOOL)hide;

- (void)pushToVC:(UIViewController *)viewController viewModel:(YCViewModel *)viewModel;
- (void)pushToVC:(UIViewController *)viewController;

- (instancetype )removeNavigationController;
@end    

@interface UIViewController(nib)
- (UIBarButtonItem *)creatBackButton;
- (void)onSetupBackButton;
@end

@interface UIViewController(exe)
- (void)onMainSignalExecute:(UIRefreshControl *)sender;
///在onMainSignalExecute-->不能sender调用这个方法，用self
- (void )executeSignal:(RACSignal *)signal next:(YCNextBlock)nextBlock error:(YCErrorBlock)errorBlock completed:(YCCompleteBlock)completedBlock executing:(YCExecutingBlock)executingBlock;
@end

@interface UIViewController (model)
@property (nonatomic,strong,setter=setViewModel:,getter=viewModel) YCViewModel *viewModel;
@end

@interface UITabBarController (appearance)
IBInspectable @property (nonatomic,assign) BOOL hideTabbar;
@end