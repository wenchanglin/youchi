//
//  YCCollectOfGoodsCell.h
//  YouChi
//
//  Created by 朱国林 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCollectOfGoodsCell : UITableViewCell
/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *imgGoogs;
/// 商品名字
@property (weak, nonatomic) IBOutlet UILabel *lGoodsName;
/// 商品价钱
@property (weak, nonatomic) IBOutlet UILabel *lGoodsPrice;
/// 秒杀价
@property (weak, nonatomic) IBOutlet UILabel *lOldGoodsPrice;
/// 加入到购物车
@property (weak, nonatomic) IBOutlet UIButton *bAddToCart;
/// 收藏
@property (weak, nonatomic) IBOutlet UIButton *bCollection;

// 缺货
@property (weak, nonatomic) IBOutlet UILabel *lShippingTag;
@property (weak, nonatomic) IBOutlet UILabel *lDesc;

@end
