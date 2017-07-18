//
//  YCGoodsCommentCell.h
//  YouChi
//
//  Created by 朱国林 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
///

#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"
@interface YCGoodsCommentCell : YCTableVIewCell

/// 商品图片
@property (weak, nonatomic) IBOutlet UIImageView *imgGoodsPictrure;
/// 商品名字
@property (weak, nonatomic) IBOutlet UILabel *lGoodsName;
/// 商品描述
@property (weak, nonatomic) IBOutlet UILabel *lGoodsDesc;
/// 加入购物车
@property (weak, nonatomic) IBOutlet UIButton *bAddToCart;

/**
 *  加入购物车tag  1001
 */

@end
