//
//  MainVC.m
//  YouChi
//
//  Created by sam on 15/4/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMainVC.h"
#import "YCMarcros.h"
#import <EDColor/EDColor.h>

#import "YCPrivateBookingVC.h"
#import "YCChihuoyingVC.h"
#import "YCRandomPicturesVC.h"
#import "YCPersonalProfileVC.h"
#import "YCPersonalNotLoginVC.h"

#import "YCNavigationController.h"

#import "UIViewController+Action.h"
#import "YCPersonalProfileVC.h"
#import "YCCoinBaseVC.h"
#import "YCDiscoverVC.h"

#import "YCPassValueHelper.h"

#import "YCUserDefault.h"
#import "YCYouChiShopVC.h"

#import "KitchenViewController.h"
#import "RecipeViewController.h"
@interface YCMainTabVCP () <RDVTabBarDelegate>
@property (strong, nonatomic) YCRandomPicturesVC *popVC;
@property (strong, nonatomic) YCPersonalNotLoginVC *notLoginVC;
@property (strong, nonatomic) YCPersonalProfileVC  *personalVC;
@end

@implementation YCMainTabVCP
- (void)dealloc{
    //ok
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _init];
    
    
    
}
- (YCRandomPicturesVC *)popVC
{
    YCRandomPicturesVC *vc = (id)[UIViewController vcClass:[YCRandomPicturesVC class]];
    return vc;
}

- (YCPersonalNotLoginVC *)notLoginVC
{
    YCPersonalNotLoginVC *vc = (id)[UIViewController vcClass:[YCPersonalNotLoginVC class]];

    return vc;
}


- (void)_init
{
    UIColor *tintYellow = color_yellow;
    self.tabBar.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
    self.tabBar.translucent = YES;
    [self.tabBar.backgroundView setBackgroundColor:[UIColor clearColor]];
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.contentView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [self.tabBar.backgroundView addSubview:effectview];
        [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(effectview.superview);
        }];
    } else {
        [self.tabBar.backgroundView setBlurTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.01]];
    }
    
    NSMutableArray *vcs = [[NSMutableArray alloc]init]; // 有吃 私人定制 吃货营 有米基地
    NSArray *sbNames = @[[YCYouChiShopVC vcClass],[RecipeViewController new],[UIViewController new],[KitchenViewController new],[YCPersonalProfileVC vcClass],];
    NSArray *titleNames = @[@"友吃商城",@"发现",[NSNull null],@"吃货营",@"我的"];
    
    
    NSArray *imgNames = @[@"友吃商城",@"发现",@"拍照",@"吃货营",@"我的"];
    for (int n = 0; n<sbNames.count; n++) {
        
        id vc = sbNames[n];
        
        if ([vc isKindOfClass:[YCNavigationController class]]) {
            [vcs addObject:vc];
        } else {
            [vcs addObject:[[YCNavigationController alloc] initWithRootViewController:vc]];
        }
        
        
    }
    [self setViewControllers:vcs];
    
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(RDVTabBarItem *item, NSUInteger idx, BOOL *stop) {
        NSString *title = titleNames[idx];
        if ([title isKindOfClass:[NSString class]]) {
            item.title = title;
        }
        item.unselectedTitleAttributes = @{
                                           NSFontAttributeName: [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName: tintYellow,};
        item.selectedTitleAttributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:12],
                                         NSForegroundColorAttributeName: [UIColor whiteColor],};
        
        NSString *img = [imgNames[idx] stringByAppendingString:@"_选中"];
        NSString *simg = imgNames[idx];
        [item setFinishedSelectedImage:IMAGE(img) withFinishedUnselectedImage:IMAGE(simg)];
        item.titlePositionAdjustment = UIOffsetMake(0, 4);
        
        
    }];
    self.tabBar.delegate = self;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index
{
    if (index == 2) {
        if ([self pushToLoginVCIfNotLogin]) {
            
            return;
        }
        [self presentViewController:self.popVC animated:YES completion:nil];
    }
    
    else if (index==4){
        
        if (![[YCUserDefault standardUserDefaults] isCurrentUserValid]) {
            [self presentViewController:self.notLoginVC animated:YES completion:nil];
            return;
        }
        
        [super tabBar:tabBar didSelectItemAtIndex:index];
        
        
        
    }
    else {
        [super tabBar:tabBar didSelectItemAtIndex:index];
    }
    
}


@end


@interface YCTextVC : UIViewController<YYTextParser>
@end


@implementation YCTextVC
- (YYTextView *)lb
{
    return (id)self.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.lb.numberOfLines = 0;
    self.lb.textVerticalAlignment = YYTextVerticalAlignmentTop;
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);
    self.lb.textContainerInset = edge;
    UIView *v = [UIView new];v.backgroundColor = [UIColor grayColor];
    CGRect frame = CGRectMake(50, 50, 100, 100);
    frame = UIEdgeInsetsInsetRect(frame, edge);
    v.frame = frame;
    CGRect f = CGRectInset(frame, -10, -10);
    [self.lb addSubview:v];
    UIBezierPath *bp = [UIBezierPath bezierPathWithRect:f];
    self.lb.exclusionPaths = @[bp];
    self.lb.text = @"Git 与 SVN 区别 \nGit不仅仅是个版本控制系统，它也是个内容管理系统(CMS),工作管理系统等。 如果你是一个具有使用SVN背景的人，你需要做一定的思想转换，来适应GIT提供的一些概念和特征。 Git 与 SVN 区别点：\n 1、Git是分布式的，SVN不是：这是GIT和其它非分布式的版本控制系统，例如SVN，CVS等，最核心的区别。\n 2、Git把内容按元数据方式存储，而SVN是按文件：所有的资源控制系统都是把文件的元信息隐藏在一个类似.svn,.cvs等的文件夹里。\n 3、Git分支和SVN的分支不同：分支在SVN中一点不特别，就是版本库中的另外的一个目录。\n 4、GIT没有一个全局的版本号，而SVN有：目前为止这是跟SVN相比GIT缺少的最大的一个特征。 5、Git的内容完整性要优于SVN：GIT的内容存储使用的是SHA-1哈希算法。这能确保代码内容的完整性，确保在遇到磁盘故障和网络问题时降低对版本库的破坏。";
    
    self.lb.textParser = self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange
{
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"(Git|的)" options:NSRegularExpressionUseUnicodeWordBoundaries error:nil];
    [re enumerateMatchesInString:text.string options:NSMatchingReportProgress range:text.rangeOfAll usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length == 0) {
            return ;
        }
        [text setColor:[UIColor greenColor] range:range];
        YYTextHighlight *th = [YYTextHighlight highlightWithBackgroundColor:[UIColor lightGrayColor]];
        [text setTextHighlight:th range:range];
        YYTextAction tap = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            
        };
        [th setTapAction:tap];
        
    }];
    return YES;
}
@end
