//
//  YCYouChiShopM.h
//  YouChi
//
//  Created by sam on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
typedef NS_ENUM(NSUInteger, YCChannelIdType) {
    YCChannelIdTypeCoupon = 1,/// 优惠劵
    YCChannelIdTypeItemCatolog = 2,/// 商品分类
    YCChannelIdTypeMiExchange = 3,// 友米兑换
    YCChannelIdTypeMoneyCard = 4,// 充值卡
    YCChannelIdTypeAllItem = 5,// 全部商品
    YCChannelIdTypeGroupPurchase = 6,// 团拼
};

@interface YCAdListM : YCBaseImageModel
@property (nonatomic,strong) NSString *originalAction;
@property (nonatomic,strong) NSNumber *originalType;
@property (nonatomic,strong) NSString *title;
@end

@interface YCChannelList : YCBaseImageModel
@property (nonatomic,strong) NSURL *channelUrl,*channelImagePath;
@property (nonatomic,strong) NSString *channelName,*channelId;
@end

@interface YCShopRecommendSubitems : YCBaseImageModel
@property (nonatomic,strong) NSString *recommendSubitemImagePath;
@property (nonatomic,strong) NSNumber *channelId,*originalType,*recommendSubitemId;
@property (nonatomic,strong) NSString *originalAction;
@end

@interface shopFunds : YCBaseModel
PROPERTY_STRONG NSString *balance,*explainUrl,*fundsTitle;
PROPERTY_STRONG NSNumber *fundsId,*isEnabled,*oneDeduct,*oneInterval,*originalAction,*originalType,*totalMoney;
@end

@interface YCYouChiShopM : YCBaseImageModel
@property (nonatomic,strong) NSArray *adList,*channelList,*shopRecommendSubitems;
PROPERTY_STRONG shopFunds *shopFunds;
@property (nonatomic,strong) NSNumber *styleType,*isShowName;
@property (nonatomic,strong) NSString *channelName;
@end



@interface YCLastCouponAndOrder : YCBaseModel

@property (nonatomic,strong) NSNumber *lastCouponCreatDate,*lastOrderDate;
@end

typedef NS_ENUM(NSUInteger, YCPopOriginalType) {
    YCPopOriginalTypeURL = 1,
    YCPopOriginalTypeItem,
    YCPopOriginalTypeCoupon,
};
@interface YCYouChiShopPopM : YCBaseModel
PROPERTY_ASSIGN YCPopOriginalType originalType;
PROPERTY_STRONG NSString *cpmImage,*originalAction;
@end