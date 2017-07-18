//
//  YCTextField.h
//  YouChi
//
//  Created by 李李善 on 15/8/9.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE@interface YCTextField : UITextField
/**
 *  隐藏输入框中的下行线
 */
@property(nonatomic,assign)IBInspectable BOOL isXHidden ;

- (void)lineColorSelected:(UIColor *)color;
- (void)lineColorNormal:(UIColor *)color;

@end
