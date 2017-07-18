//
//  YCFixOrderM.m
//  YouChi
//
//  Created by sam on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFixOrderM.h"

@implementation YCFixOrderM
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"payType":@"payType",
             @"onlinePayMoney":@"onlinePayMoney",
             @"alipayVo":@"alipayVo",
             @"weixinMap":@"weixinMap",
             
             @"amount":@"alipayVo.amount",
             @"notifyURL":@"alipayVo.notifyURL",
             @"productDescription":@"alipayVo.productDescription",
             @"productName":@"alipayVo.productName",
             @"tradeNO":@"alipayVo.tradeNO",
             
             @"appid":@"weixinMap.appid",
             @"noncestr":@"weixinMap.noncestr",
             @"orderNo":@"weixinMap.orderNo",
             @"package":@"weixinMap.package",
             @"partnerid":@"weixinMap.partnerid",
             @"prepayid":@"weixinMap.prepayid",
             @"sign":@"weixinMap.sign",
             @"timestamp":@"weixinMap.timestamp",
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"payType":@"payType",
             @"onlinePayMoney":@"onlinePayMoney",
             @"alipayVo":@"alipayVo",
             @"weixinMap":@"weixinMap",
             
             @"amount":@"alipayVo.amount",
             @"notifyURL":@"alipayVo.notifyURL",
             @"productDescription":@"alipayVo.productDescription",
             @"productName":@"alipayVo.productName",
             @"tradeNO":@"alipayVo.tradeNO",
             
             @"appid":@"weixinMap.appid",
             @"noncestr":@"weixinMap.noncestr",
             @"orderNo":@"weixinMap.orderNo",
             @"package":@"weixinMap.package",
             @"partnerid":@"weixinMap.partnerid",
             @"prepayid":@"weixinMap.prepayid",
             @"sign":@"weixinMap.sign",
             @"timestamp":@"weixinMap.timestamp",
             };

}
@end
