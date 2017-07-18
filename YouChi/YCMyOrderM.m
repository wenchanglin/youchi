//
//  YCMyOrderM.m
//  YouChi
//
//  Created by 朱国林 on 16/3/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//  *orderMoneyTotal,*postMoney,*favorableMoney,*balanceMoney,*howManyFullShipping;

#import "YCMyOrderM.h"

@implementation YCMyOrderM

//@property(nonatomic,strong)NSMutableArray *shopOrderProducts,*shopWuliuInfos,*refundRemark,*refuseRemark,*shopGroupBuySubs;
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"shopOrderProducts" : [YCShopOrderProductM class],
             @"shopWuliuInfos" : [YCShopWuliuInfoM class],
             @"refundRemark" : [YCRefundM class],
             @"refuseRemark" : [YCRefundM class],
             @"shopGroupBuySubs" : [YCShopOrderGroupBuySubs class],
             
             
             };
}

/*
 @property(nonatomic,strong)NSMutableArray *shopOrderProducts,*shopWuliuInfos,*refundRemark,*refuseRemark;
 @property(nonatomic,strong)NSArray *shopGroupBuySubs;
 @property(nonatomic,strong)YCShopProductM *shopProduct;
 @property(nonatomic,strong)YCShopGroupBuy *shopGroupBuy;
 */
@end




@implementation YCShopOrderProductM

@end

@implementation YCShopWuliuInfoM

//@property(nonatomic,strong)NSMutableArray *wuliuJson,*shopOrderProducts;
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"wuliuJson" : [YCKuaidi class],
             @"shopOrderProducts" : [YCShopOrderProductM class],
             };
}
@end

@implementation YCKuaidi
- (void)dealloc{
    //    OK
}

@end

@implementation YCRefundM
- (void)dealloc{
    //    OK *date,*phone,*remark
}

@end


@implementation YCShopOrderGroupBuySubs
@end

@implementation YCShopGroupBuy


//@property(nonatomic,strong)NSMutableArray *shopGroupBuySubs;
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"shopGroupBuySubs" : [YCShopOrderGroupBuySubs class],
             };
}
@end
