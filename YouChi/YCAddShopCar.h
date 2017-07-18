//
//  YCAddShopCar.h
//  YouChi
//
//  Created by 李李善 on 16/1/14.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^AddShopCar)(UIButton *button,NSInteger tag);

IB_DESIGNABLE @interface YCAddShopCar : UIControl

///收藏   tag==5
@property(nonatomic,strong) UIButton *btnCollection;


///多少数量
@property(nonatomic,strong) UILabel *much;
///减按钮 tag==10
@property(nonatomic,strong) UIButton *btnReduce;
///加按钮 tag==15
@property(nonatomic,strong) UIButton *btnAdd;

///立即购买 tag==20
@property(nonatomic,strong) UIButton *btnImmediatelyBuy;

///加入购物车 tag==25
@property(nonatomic,strong) UIButton *btnAddShopCar;

///选择哪个
@property(nonatomic,assign) NSInteger selectInteger;
///选择哪个按钮
@property(nonatomic,assign) UIButton * selectButton;

//-(void)onUpdateShopCar:(id)model;

- (void)updateBtnImmediatelyBuyConstraints;

@end
