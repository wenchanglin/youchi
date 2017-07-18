//
//  YCMuchPrice.h
//  YouChi
//
//  Created by 李李善 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface YCMuchPrice : UIControl
///价格
@property(nonatomic,strong) UILabel *price;
///多少数量
@property(nonatomic,strong) UILabel *much;
///总价格
@property(nonatomic,strong) UILabel *totalPrice;
///减按钮 tag==10
@property(nonatomic,strong) UIButton *btnReduce;
///加按钮 tag==20
@property(nonatomic,strong) UIButton *btnAdd;

///是否隐藏--->减按钮和加按钮
@property(nonatomic,assign)IBInspectable BOOL hiddenBtnMuch;

/**
 price  价格
 much    数量
 */
-(void)onUpdataPrice:(NSString *)price Much:(NSString *)much;
//-(void)onUpdataPrice:(NSString *)price Much:(float)much;
@end
