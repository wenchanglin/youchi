//
//  UIButton+MJ.h
//  YouChi
//
//  Created by 李李善 on 15/5/21.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIButton (MJ)
/**
 *  根据九宫格创建button
 *
 *  @return UIButton
 */
+(UIButton *)oncrearbuttonSuperFrame:(CGRect)frame Count:(int)Count Row:(int)row Column:(int)column;
/**
 *  根据九宫格计算返回一位置
 *
 *  @return CGPoint
 */
+(CGPoint)onPointbuttonSuperFrame:(CGRect)frame Count:(int)Count Row:(int)row Column:(int)column;
/**
 *  根据位置，添加方法，图片创建一个button
 *
 *  @return UIButton
 */
+(UIButton *)onCreatebuttonTarget:(id)target action:(SEL)action Image:(NSString *)image Frame:(CGRect)frame;
/**
 *  根据添加方法，背景图片，标题 创建一个button
 *
 *  @return UIButton
 */
+(UIButton *)onCearchButtonWithBackgroundImage:(NSString *)Image Title:(NSString *)title Target:(id)target action:(SEL)action;
/**
 *  根据添加方法，默认图片，选择图片，标题 创建一个button
 *
 *  @return UIButton
 */
+(UIButton *)onCearchButtonWithImage:(NSString *)Image SelImage:(NSString *)SelImage Title:(NSString *)title Target:(id)target action:(SEL)action;
@end
