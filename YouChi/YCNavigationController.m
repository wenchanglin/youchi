//
//  YCNavigationController.m
//  YouChi
//
//  Created by sam on 15/10/20.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNavigationController.h"

@implementation UINavigationController (YC)
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end

@interface YCNavigationController ()

@end

@implementation YCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count == 1) {
        RDVTabBarController *tbc = self.rdv_tabBarController;
        if (!tbc.tabBarHidden) {
            [tbc setTabBarHidden:YES animated:YES];
        }
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = [(UINavigationController *)viewController topViewController];
        }
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.childViewControllers.count == 2) {
        RDVTabBarController *tbc = self.rdv_tabBarController;
        if (tbc.tabBarHidden) {
            [tbc setTabBarHidden:NO animated:YES];
        }
    }
    return [super popViewControllerAnimated:animated];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    RDVTabBarController *tbc = self.rdv_tabBarController;
//    BOOL b = tbc.tabBarHidden;
//    if (!b) {
//        [tbc setTabBarHidden:NO animated:YES];
//    }
//    return !b;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
