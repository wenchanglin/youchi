//
//  YCCommodityManifestCell.h
//  YouChi
//
//  Created by 李李善 on 15/12/26.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCCommodity.h"
#import "YCOrderNumView.h"
#import "YCTableVIewCell.h"


@interface YCCommodityManifestCell : YCTableVIewCell

///商品展示View
@property (weak, nonatomic) IBOutlet YCCommodity *commodityView;
///商品晒单
@property (weak, nonatomic) IBOutlet UIButton *btnEvaluate;
///商品退款
@property (weak, nonatomic) IBOutlet UIButton *btnRefund;
///商品加入购物车
@property (weak, nonatomic) IBOutlet UIButton *btnShoppingCart;
@property (weak, nonatomic) IBOutlet YCOrderStatueView *orderStatueView;

@end
