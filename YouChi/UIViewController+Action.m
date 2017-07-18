 //
//  ViewController+Action.m
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCPersonalNotLoginVC.h"
#import "UIViewController+Action.h"
#import <objc/runtime.h>
#import <EDColor/EDColor.h>
#import "YCMarcros.h"
#import "YCLoginVC.h"
#import "YCPersonalNotLoginVC.h"

#import "YCRecipeDetailVC.h"
#import "YCYouChiDetailVC.h"
#import "AppDelegate.h"

static char * dir = "dir";
static char * push = "push";
static char * black = "black";
@implementation UIViewController (Action)

- (UIPopoverArrowDirection)lastDirection
{
    return [objc_getAssociatedObject(self, dir) integerValue];
}

- (void)setLastDirection:(UIPopoverArrowDirection)lastDirection
{
    objc_setAssociatedObject(self, dir, @(lastDirection), OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)blackView
{
    return objc_getAssociatedObject(self, black);
}

- (void)setBlackView:(UIView *)blackView
{
    objc_setAssociatedObject(self, black, blackView, OBJC_ASSOCIATION_RETAIN);
}


- (IBAction)onReturn
{
    dispatch_async_on_main_queue(^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (IBAction)onDismissReturn
{
    dispatch_async_on_main_queue(^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)onPopToRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onReturnToGroupBuy
{
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    [self.navigationController popToViewController:vcs[1] animated:YES];
    
}


- (IBAction)onUnwindTo:(UIStoryboardSegue *)unwindSegue
{
    
}

- (void)onReload:(UIRefreshControl *)sender
{
    if ([self.viewModel respondsToSelector:@selector(pageInfo)]) {
        YCPageInfo *pi = [self.viewModel performSelector:@selector(pageInfo)];
        pi.status = YCLoadingStatusRefresh;
    }
    [self onMainSignalExecute:sender];
}

- (CGRect )_move:(UIPopoverArrowDirection)d frame:(CGRect)frame
{
    switch (d) {
        case UIPopoverArrowDirectionUp:
            frame.origin.y = -frame.size.height;
            break;
        case UIPopoverArrowDirectionLeft:
        {
            frame.origin.x = -frame.size.width;
        }
            break;
        case UIPopoverArrowDirectionDown:
        {
            frame.origin.y = +frame.size.height;
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            frame.origin.x = +frame.size.width;
        }

        default:
            break;
    }
    return frame;
}

- (void)showSlideMenu:(UIViewController *)vc from:(UIPopoverArrowDirection )d
{
    vc.lastDirection = d;
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:vc];
    
    //UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    if (!vc.blackView) {
        vc.blackView = [UIView new];
        vc.blackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
    }
    vc.blackView.alpha = 0.f;
    [self.view addSubview:self.blackView];
    vc.blackView.frame = frame;
    
    
    [self.view addSubview:vc.view];
    frame = [vc _move:d frame:frame];
    vc.view.frame = frame;
    
    
    
    vc.view.hidden = NO;
    
    [UIView animateWithDuration:0.5f animations:^{
        vc.view.center = center;
        vc.blackView.alpha = 1.f;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)showSlideMenuFrom:(UIPopoverArrowDirection)d
{
    self.lastDirection = d;

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [UIScreen mainScreen].bounds;

    if (!self.blackView) {
        self.blackView = [UIView new];
        self.blackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
    }
    self.blackView.alpha = 0.f;
    [window addSubview:self.blackView];
    self.blackView.frame = frame;
    
    
    [self.blackView addSubview:self.view];
    frame = [self _move:d frame:frame];
    self.view.frame = frame;



    self.view.hidden = NO;

    [UIView animateWithDuration:0.5f animations:^{
        self.view.center = self.view.superview.center;
        self.blackView.alpha = 1.f;
    } completion:^(BOOL finished) {
        if (finished) {

        }
    }];
}

- (void)hideSlideMenu
{
    CGRect frame = [UIScreen mainScreen].bounds;

    UIPopoverArrowDirection d = self.lastDirection;
    frame = [self _move:d frame:frame];
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frame;

    } completion:^(BOOL finished) {
        if (finished) {
            self.view.hidden = YES;
            [self.view removeFromSuperview];
            [self.blackView removeFromSuperview];
            self.blackView = nil;
        }
    }];
}

- (void)showTopMessage:(NSString *)msg
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if ([msg isKindOfClass:[NSString class]]) {
            [window makeToast:msg duration:3 position:CSToastPositionTop];
        }
        else if ([msg isKindOfClass:[NSError class]]) {
            [window makeToast:[(NSError *)msg localizedDescription] duration:3 position:CSToastPositionTop];
        }

}

- (void)showmMidMessage:(NSString *)msg
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if ([msg isKindOfClass:[NSString class]]) {
        [window makeToast:msg duration:1 position:CSToastPositionCenter];
    }
    else if ([msg isKindOfClass:[NSError class]]) {
        [window makeToast:[(NSError *)msg localizedDescription] duration:0.5 position:CSToastPositionCenter];
    }
    
}

- (void)showMessage:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        // 不知道为何，弹开相册知之后 提示框会被推到顶部 window的高度变成20，所以加这行
        window.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        if ([msg isKindOfClass:[NSString class]]) {
            [window makeToast:msg duration:1 position:CSToastPositionCenter];

        }
        
        else if ([msg isKindOfClass:[NSError class]]) {
            [window makeToast:[(NSError *)msg localizedDescription]];
        }
    });
}

- (void)showTabbar
{
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (tbc.tabBarHidden) {
        [tbc setTabBarHidden:NO animated:NO];
    }
}

- (void)hideTabbar
{
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.tabBarHidden) {
        [tbc setTabBarHidden:YES animated:YES];
    }
}

- (void)adjustContentIn:(UIScrollView *)scrollView
{
    CGFloat bottom = 44;
    UIEdgeInsets edge = scrollView.contentInset;
    edge.bottom = bottom;
    scrollView.contentInset = edge;
    
    edge = scrollView.scrollIndicatorInsets;
    edge.bottom = bottom;
    scrollView.scrollIndicatorInsets = edge;
}

- (BOOL)pushToLoginVCIfNotLogin
{
    if (![[YCUserDefault standardUserDefaults] isCurrentUserValid]) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *vc = [UIViewController vcClass:[YCLoginVC class]];
        [app.window.rootViewController presentViewController:vc animated:YES completion:nil];
        return YES;
    }
    return NO;
}

@end


@implementation UIViewController (Segue)
- (UIViewController *)pushedViewController
{
    return objc_getAssociatedObject(self, push);
}

- (void)setPushedViewController:(UIViewController *)pushedViewController
{
    objc_setAssociatedObject(self, push, pushedViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (id )vcClassWithIdentifier:(NSString *)identifier
{
    NSParameterAssert(identifier);
    UIStoryboard *sb = self.storyboard;
    return [sb instantiateViewControllerWithIdentifier:identifier];
}

+ (instancetype )vcByStoryboardWithName:(NSString *)name
{
    NSString *sbn = name;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbn bundle:nil];
    
    UIViewController *vc = [sb instantiateInitialViewController];
    return vc;
}

+ (instancetype)vcClass
{
    return [self vcClass:self];
}

+ (instancetype )vcClass:(Class)ViewControllerClass
{
    UIViewController *vc;
    @try {
        NSString *sbn = NSStringFromClass(ViewControllerClass);
        UIStoryboard *sb = [UIStoryboard storyboardWithName:sbn bundle:nil];
        
        vc = [sb instantiateInitialViewController];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    @finally {
        ;
    }
    
    return vc;
}


+ (instancetype )vcClass:(Class)ViewControllerClass vcId:(NSString *)vcId
{
    NSString *sbn = NSStringFromClass(ViewControllerClass);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbn bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:vcId];
    return vc;
}


- (void)pushToSBName:(NSString *)sbName
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushTo:(Class)ViewControllerClass
{
    [self pushTo:ViewControllerClass viewModel:nil];
}

- (void)pushTo:(Class)ViewControllerClass viewModel:(id)viewModel
{
    [self pushTo:ViewControllerClass viewModel:viewModel hideTabBar:NO];
}

- (void)pushTo:(Class)ViewControllerClass viewModel:(id)viewModel hideTabBar:(BOOL)hide
{
    UIViewController *vc = [self.class vcClass:ViewControllerClass];
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nc = (UINavigationController *)vc;
        vc = nc.topViewController;
    }
    if (viewModel) {
        vc.viewModel = viewModel;
    }

    if (hide) {
        [self hideTabbar];
    }
    
    dispatch_async_on_main_queue(^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)pushToVC:(UIViewController *)viewController viewModel:(YCViewModel *)viewModel
{
    viewController.viewModel = viewModel;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushToVC:(UIViewController *)viewController
{
    if ([NSThread isMainThread]) {
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:viewController animated:YES];
        });
    }
}

- (instancetype )removeNavigationController
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nc = (UINavigationController *)self;
        return  nc.topViewController;
    }
    return self;
}
@end


@implementation UIViewController(nib)

- (UIBarButtonItem *)creatBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [[UIImage imageNamed:@"chevron-left"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn setImage:img forState:UIControlStateNormal];
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(onReturn)];
    return bbi;
}

- (void)onSetupBackButton
{
    self.navigationController.navigationBar.translucent = NO;
    if (self.navigationController.topViewController == self) {
        return;
    }
    self.navigationItem.leftBarButtonItem = [self creatBackButton];
}


@end


@implementation UIViewController (exe)
- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    ;
}

- (void )executeSignal:(RACSignal *)signal next:(YCNextBlock)nextBlock error:(YCErrorBlock)errorBlock completed:(YCCompleteBlock)completedBlock executing:(YCExecutingBlock)executingBlock
{
    //NSAssert(signal != nil, @"不能为nil");
    if (!signal) {
        return;
    }
    dispatch_async_on_main_queue(^{
        if (executingBlock) {
            executingBlock(YES);
        }
    });
    [signal.deliverOnMainThread subscribeNext:^(id x) {
        if (nextBlock) {
            nextBlock(x);
        }
        
    } error:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if (executingBlock) {
            executingBlock(NO);
        }
        if (completedBlock) {
            completedBlock();
        }
    } completed:^{
        if (executingBlock) {
            executingBlock(NO);
        }
        if (completedBlock) {
            completedBlock();
        }
    }];
}

@end

static char const *kViewModel;
@implementation UIViewController (model)
@dynamic viewModel;
- (void)setViewModel:(YCViewModel *)viewModel
{
    objc_setAssociatedObject(self, kViewModel, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YCViewModel *)viewModel
{
    return objc_getAssociatedObject(self, kViewModel);
}

@end

@implementation UITabBarController (appearance)

- (void)setHideTabbar:(BOOL)hideTabbar
{
    self.tabBar.hidden = hideTabbar;
}

@end