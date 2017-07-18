//
//  YCShopCategoryM.m
//  YouChi
//
//  Created by 李李善 on 16/1/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopCategoryM.h"

@implementation YCShopCategoryM
//+ (NSDictionary *)JSONKeyPathsByPropertyKey
//{
//    NSMutableDictionary *dict = [super JSONKeyPathsByPropertyKey].mutableCopy;
//    [dict addEntriesFromDictionary:@{
//                                     @"categoryName":@"categoryName",
//                                     @"brief":@"brief",
//                                     @"productName":@"productName",
//                                     @"marketPrice":@"marketPrice",
//                                     @"keyword":@"keyword",
//                                     @"categorySubId":@"categorySubId",
//                                     @"shopCoupon":@"shopCoupon",
//                                     @"shopKeyword":@"shopKeyword",
//                                     @"shopCategorySubs":@"shopCategorySubs",
//                                     @"shopPrice":@"shopPrice",
//                                     @"oneCateValue":@"oneCateValue",
//                                     @"twoCateValue":@"twoCateValue",
//                                     @"couponId":@"couponId",
//                                     @"couponImagePath":@"couponImagePath",
//                                     @"isReceived":@"isReceived",
//                                     @"isEnd":@"isEnd",
//                                     @"isUsed":@"isUsed",
//                                     @"isExpired":@"isExpired",
//                                     @"userCouponId":@"userCouponId",
//                                     @"validDate":@"validDate",
//                                     @"categoryId":@"categoryId",
//                                     @"productId":@"productId",
//                                     @"couponName":@"couponName",
//                                     @"couponDesc":@"couponDesc",
//                                     @"shopSpecs":@"shopSpecs",
//                                     @"specId":@"specId",
//                                     @"antPrice":@"antPrice",
//                                     @"isMoneyPay":@"isMoneyPay",
//                                     @"specName":@"specName",
//                                     @"specMoneyPrice":@"specMoneyPrice",
//                                     @"productImagePath":@"productImagePath",
//                                     @"categorySubName":@"categorySubName",
//                                     }];
//    return dict;
//}
//
//+ (NSValueTransformer *)validDateJSONTransformer
//{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        if (!value) {
//            return nil;
//        }
//        NSString *date = [[YCDateFormatter shareDateFormatter] stringFromNumber:value];
//        
//        return date;
//    }];
//}
//
//
//+ (NSValueTransformer *)couponImagePathJSONTransformer
//{
//    return [self imagePathJSONTransformer];
//}
//
//+ (NSValueTransformer *)shopCategorySubsJSONTransformer
//{
//    return [self JSONTransformerFromArray:[YCShopCategorySubsM class]];
//}
//
//+ (NSValueTransformer *)shopKeywordJSONTransformer
//{
//    return [self JSONTransformerFromDictonary:[YCShopCategorySubsM class]];
//}
//+ (NSValueTransformer *)shopCouponJSONTransformer
//{
//    return [self JSONTransformerFromDictonary:[YCShopCategorySubsM class]];
//}
//
//+ (NSValueTransformer *)shopSpecsJSONTransformer
//{
//    return [self JSONTransformerFromArray:[YCShopCategorySubsM class]];
//}
//+ (NSValueTransformer *)productImagePathJSONTransformer
//{
//     return [self imagePathJSONTransformer];
//}




-(void)onChangeAllValue{
    
    //    self.btnTitle
}


/*
 @property(nonatomic,strong) NSMutableArray *shopCategorySubs,*shopSpecs;
 
 
 @property(nonatomic,strong) YCShopKeyword *shopKeyword;
 @property(nonatomic,strong) YCShopCategorySubsM *shopCoupon;
 */
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"shopCategorySubs" : [YCShopCategorySubsM class],
             @"shopSpecs" : [YCShopCategorySubsM class],
             };
}

@end


@implementation YCShopCategorySubsM

@end

@implementation YCShopKeyword

@end


