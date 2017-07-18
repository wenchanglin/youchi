//
//  YCNewstGroupM.h
//  YouChi
//
//  Created by ant on 16/5/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <YYKit/YYKit.h>
#import "YCModel.h"
#import "YCItemDetailM.h"
@interface YCNewstGroupM : YCBaseImageModel

@property (nonatomic,strong) NSNumber *productId,*marketPrice,*shopPrice,*showSalesQty,*joinCount,*sponsorCount;
@property (nonatomic,strong) NSString *productName,*brief;

/**
 *  规格数组
 */
@property(nonatomic,strong) NSArray<YCShopSpecs *> *shopSpecs;

PROPERTY_STRONG_READONLY NSAttributedString *groupCountAttr,*priceAttr;

PROPERTY_STRONG_READONLY YYTextLayout *briefLayout;

PROPERTY_STRONG_READONLY YCLinearInfoManager *infoMgr;
@end
