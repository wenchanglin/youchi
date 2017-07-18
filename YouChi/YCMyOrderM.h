//
//  YCMyOrderM.h
//  YouChi
//
//  Created by 朱国林 on 16/3/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.  shopUserAddress
//
#import "YCMyInitiateGroupM.h"
#import "YCModel.h"
#import "YCAboutGoodsM.h"

@class YCShopOrderProductM,YCShopOrderGroupBuySubs,YCShopGroupBuy;
@interface YCMyOrderM : YCBaseModel

@property(nonatomic,strong)NSNumber *orderStatus,*shippingStatus,*realPayMoney,*payStatus,*isMoneyPay,*orderId,*refundStatus,*orderMoneyTotal,*postMoney,*favorableMoney,*balanceMoney,*howManyFullShipping,*refundId,*isPresell,*isTeamOrder,*noPayCount,*groupCoupon,*groupBuyId;
@property(nonatomic,strong)NSString *orderNo,*receiverAddress,*receiverName,*receiverPhone,*refundDesc,*refundProcessDesc;
@property(nonatomic,strong)NSMutableArray *shopOrderProducts,*shopWuliuInfos,*refundRemark,*refuseRemark,*shopGroupBuySubs;
@property(nonatomic,strong)YCShopProductM *shopProduct;
@property(nonatomic,strong)YCShopGroupBuy *shopGroupBuy;

@property (nonatomic,assign)BOOL isOrderDetail;
@end


@interface YCShopOrderProductM : YCBaseModel

@property(nonatomic,strong)NSNumber *isMoneyPay,*qty,*isRefund,*orderProductId;
@property(nonatomic,strong)YCShopProductM *shopProduct;
@property(nonatomic,strong)YCShopSpecM *shopSpec;
@end

/**
 *  物流Model
 */
@interface YCShopWuliuInfoM : YCBaseModel


@property(nonatomic,strong)NSMutableArray *wuliuJson,*shopOrderProducts;
/**
 *  shippingNo 物流单号
    wuliuInfoId ID
 
 */
@property(nonatomic,strong)NSNumber *shippingNo,*wuliuInfoId;

/**
 *  kuaidiName 快递名字
 */
@property(nonatomic,strong) NSString *kuaidiName;
@end


@interface YCKuaidi : YCBaseModel
/**
 *  kuaidiName 快递名字  shopGroupBuy  
 */
@property(nonatomic,strong) NSString *time,*context;


@end

@interface YCRefundM : YCBaseModel

@property(nonatomic,strong) NSString *date,*phone,*remark;
@end


@interface YCShopOrderGroupBuySubs : YCBaseModel
@property(nonatomic,strong)YCMeM *appUser;
@property(nonatomic,strong)YCShopGroupBuy *shopGroupBuy;
@property(nonatomic,strong) NSNumber *isPay,*isMe,*groupBuySubId,*qty,*groupBuyId,*price;
@property(nonatomic,strong)YCShopSpecM *shopSpec;
@property(nonatomic,strong)YCShopProductM *shopProduct;

@end

@interface YCShopGroupBuy : YCBaseModel

@property(nonatomic,strong)YCRecipientAddressM *shopUserAddress;
@property(nonatomic,strong) NSNumber *isPay,*isMe,*groupBuySubId,*qty,*groupBuyId,*currentMoney;
@property(nonatomic,strong) NSString *shopSpec;
@property(nonatomic,strong) NSArray *shopGroupBuySubs;

@end

