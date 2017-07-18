//
//  YCGroupActionBar.h
//  YouChi
//
//  Created by sam on 16/6/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCContainerControl.h"
#import <YYKit/YYKit.h>
///团拼页面底部两个按钮
@interface YCGroupBottomActionBar : YCContainerControl
///左按钮
@property (strong, nonatomic)  UIButton *btnLeft;
///右按钮
@property (strong, nonatomic)  UIButton *btnRight;

- (void)updateColors;
@end
