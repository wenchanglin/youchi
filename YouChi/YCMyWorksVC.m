//
//  YCMyshareVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyWorksVC.h"
#import "YCMyWorksVM.h"
#import "YCChihuoyingVC.h"
@interface YCMyWorksVC ()
{
    UITabBarController *_tbc;
}
@property(nonatomic,strong)YCMyWorksVM *viewModel;
@property(nonatomic,assign)BOOL isScroll;
@property(nonatomic,assign)NSInteger CurrentIndex;
@end

@implementation YCMyWorksVC
@synthesize viewModel;
-(void)dealloc{
    //    ok
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabbar];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的作品";
    
    [self _initOpints];
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
}


//初始化---,随手拍，全部，秘籍
-(void)_initOpints
{
    [self.option insertSegmentWithTitle:@"随手拍" image:nil];
    [self.option insertSegmentWithTitle:@"秘籍" image:nil];
    self.option.backgroundColor = KBGCColor(@"#ebebeb");
    self.option.normalColor = KBGCColor(@"#535353");
    self.option.hasBottomLine = YES;
    [self.option addTarget:self action:@selector(selector:) forControlEvents:UIControlEventValueChanged];

}

//  底部的黄色view
-(void)selector:(YCSwitchTabControl *)sender
{
    [self.view endEditing:YES];
    
    [sender segmentLineScrollToIndex:sender.selectedSegmentIndex animate:YES];
    _tbc.selectedIndex =sender.selectedSegmentIndex;
    
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark --左右滑手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{

    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
            if (_tbc.selectedIndex>=_tbc.viewControllers.count) {
                return;
            }
            
        @try {
            
            for (YCMyWorksOfScrollVC *vc in _tbc.viewControllers) {
                
                /// 只有滑动的时候才有动画效果
                vc.isAnimation = YES;
                vc.direction = 1;
            }
            
            _tbc.selectedIndex = 1;
            
            self.option.selectedSegmentIndex = 1;
            [self.option segmentLineScrollToIndex:1 animate:YES];
            
            
            for (YCMyWorksOfScrollVC *vc in _tbc.viewControllers) {
                
                /// 取消动画效果，否则进入其他页面也会有翻页效果
                vc.isAnimation = NO;
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
            
            if (_tbc.selectedIndex == 0) {
                
                return;
            }
        
        @try {
            
            for (YCMyWorksOfScrollVC *vc in _tbc.viewControllers) {
                
                vc.isAnimation = YES;
                vc.direction = 2;
            }
            _tbc.selectedIndex = 0;
            self.option.selectedSegmentIndex = 0;
            [self.option segmentLineScrollToIndex:0 animate:YES];
            
            for (YCMyWorksOfScrollVC *vc in _tbc.viewControllers) {
                
                vc.isAnimation = NO;
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITabBarController *tbc = segue.destinationViewController;
    _tbc = tbc;
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if (flag) {
 
    }else{
    
    }
    
    
}

@end


@interface YCMyWorksOfScrollVC ()
@end

@implementation YCMyWorksOfScrollVC

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isAnimation) {
        
        CATransition *transition = [CATransition animation];
        [transition setDuration:0.3];
        transition.type=kCATransitionPush;
        
        if (self.direction == 1) {
        
            transition.subtype=kCATransitionFromRight;
            [self.tabBarController.view.layer addAnimation:transition forKey:nil];
            
        }else if (self.direction == 2){
        
            transition.subtype=kCATransitionFromLeft;
            [self.tabBarController.view.layer addAnimation:transition forKey:nil];
            
        }
        
    }
    self.isAnimation = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

@end
