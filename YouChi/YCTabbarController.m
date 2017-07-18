//
//  YCTabbarController.m
//  YouChi
//
//  Created by sam on 16/1/11.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTabbarController.h"

@implementation YCTabbarController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBar.hidden = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self onSetupBackButton];
    }
    return self;
}
@end
