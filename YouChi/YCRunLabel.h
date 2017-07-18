//
//  YCRunLabel.h
//  YouChi
//
//  Created by 李李善 on 15/10/26.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE@interface YCRunLabel : UIView
@property(strong,nonatomic)UILabel *label;
- (void)setTitle:(NSString *)title;
@end
