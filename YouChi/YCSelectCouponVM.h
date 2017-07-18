//
//  YCSelectCouponVM.h
//  YouChi
//
//  Created by 李李善 on 16/1/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouMiExchangeVM.h"
#import "YCShopCategoryM.h"
@interface YCSelectCouponVM : YCYouMiExchangeVM
///商品ID数组
@property(nonatomic,strong) NSString *cartIds;

///<YCShopCategoryM>
PROPERTY_STRONG RACSubject *selectCouponSignal;

-(instancetype)initWithCartIdArray:(NSArray<NSNumber *> *)cartIdArray ;
@end
