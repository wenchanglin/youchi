//
//  YCFixOrderM.h
//  YouChi
//
//  Created by sam on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
typedef NS_ENUM(NSInteger,YCPayType) {
    YCPayTypeAliPay = 1,
    YCPayTypeWeixin = 2,
};


typedef NS_ENUM(NSInteger,YCOrderType) {
    YCOrderTypeCommodity = 0,//商品
    YCOrderTypeGroup        ,//团拼
};

@interface YCFixOrderM : YCBaseModel
@property (nonatomic,strong) NSString *alipayTradeNo,*wxpayTradeNo,*alipayVo,*weixinMap;
@property (nonatomic,strong) NSNumber *payType,*onlinePayMoney;

//支付宝
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;

//微信
@property(nonatomic, copy) NSString * appid;
@property(nonatomic, copy) NSString * noncestr;
@property(nonatomic, copy) NSString * orderNo;
@property(nonatomic, copy) NSString * package;
@property(nonatomic, copy) NSString * partnerid;
@property(nonatomic, copy) NSString * prepayid;
@property(nonatomic, copy) NSString * sign;
@property(nonatomic, copy) NSString * timestamp;
@end
