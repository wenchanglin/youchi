//
//  YCCommodity.h
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface YCCommodity : UIView
///商品名称
@property(nonatomic,strong) UILabel *commodityName;
///商品数量 x10
@property(nonatomic,strong) UILabel *commodityMuch;
///商品单价 ¥50
@property(nonatomic,strong) UILabel *commodityPrice;
///商品份量 200g/份
@property(nonatomic,strong) UILabel *commodityWeight;
///商品规格
@property(nonatomic,strong) UILabel *commoditySpecifications;
///商品图片
@property(nonatomic,strong) UIImageView *commodityImage;
///是否隐藏--->商品规格
@property(nonatomic,assign)IBInspectable BOOL hiddenSpecifications;
///是否隐藏--->商品数量
@property(nonatomic,assign)IBInspectable BOOL hiddenMuch;

///是否隐藏---> ¥
@property(nonatomic,assign)IBInspectable BOOL hiddenY;
/// ¥字
@property(nonatomic,strong) UILabel *Y;

/// 友米字
@property(nonatomic,strong) UIImageView *ant;

///name:商品名字 much:商品数量 price:商品单价 weight:规格 1g/份 image:商品图片
-(void)onUpdataCommodityName:(NSString *)name Much:(int)much Price:(NSString *)price Weight:(NSString *)weight Image:(NSString *)url;

@end
