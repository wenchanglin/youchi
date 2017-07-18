//
//  YCMyCartCell.h
//  YouChi
//
//  Created by 朱国林 on 15/12/28.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCCategoryDelete.h"
#import "YCTableVIewCell.h"
#import "YCAboutGoodsM.h"
#import "YCMuchPrice.h"
#import <UIKit/UIKit.h>
#import "YCCommodity.h"
#import "YCView.h"
@interface YCMyCartCell : YCTableVIewCell
/// 商品属性 多少个 规格  价钱之类,商品名字
@property (weak, nonatomic) IBOutlet YCCommodity *vCommodity;
/// 第几类商品，删除商品按钮
@property (weak, nonatomic) IBOutlet YCCategoryDelete *vGoodsName;
/// 总价
@property (weak, nonatomic) IBOutlet YCMuchPrice *vTotalPrice;

// 每个cell 刚请求回来的价钱
@property (nonatomic,assign)float eachGoodsPirce;

@property (nonatomic,strong)YCAboutGoodsM *model;

@end
