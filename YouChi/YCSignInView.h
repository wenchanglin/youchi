//
//  YCSignInView.h
//  YouChi
//
//  Created by sam on 15/10/22.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCView.h"

@interface YCSignInView : UIView
+ (void)showSignInView:(UIView *)view action:(NSString *)action count:(int)count;

+ (void)showSignInView:(UIView *)view;
@end
