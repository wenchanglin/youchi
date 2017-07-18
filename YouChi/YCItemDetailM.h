//
//  YCItemDetailM.h
//  YouChi
//
//  Created by sam on 16/1/8.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import "YCAboutGoodsM.h"

#define YCItemDetailEdge 5
#define YCItemDetailInnerEdge 10
#define YCItemDetailInnerGroupEdge 15 //平均15

///团拼详情
typedef NS_ENUM(NSUInteger, YCGroupTag) {
    YCGroupTagStatusSponsorDidNotOrder = 1,
    YCGroupTagStatusSponsorDidOrder,
    YCGroupTagStatusDidNotSubmittedOrder,
    YCGroupTagStatusSubmittedOrderDidNotPay,
    YCGroupTagStatusSubmittedOrderDidPay,
    YCGroupTagStatusNotValid,
    YCGroupTagStatusComplete,
};

///团拼状态
typedef NS_ENUM(NSUInteger, YCGroupStatus) {
    YCGroupStatusInviting = 1,///1：发起团拼邀请中
    YCGroupStatusPaying,///2：发起结算中
    YCGroupStatusPayedAndDispatching,///3：全部结算完成/发货中
    YCGroupStatusCanceled,///4：已解散
    YCGroupStatusReceivedProduct,///5：已结束/已完成/确认收货
};

@class shopPostagePolicy;
///邮费策略sub
@interface shopPostagePolicySub : YCBaseModel
PROPERTY_ASSIGN long ShopPostagePolicySub,postagePolicySubId,postage;
PROPERTY_STRONG NSString *name;
PROPERTY_STRONG shopPostagePolicy *shopPostagePolicy;
@end

///邮费策略
@interface shopPostagePolicy : YCBaseModel
PROPERTY_STRONG NSString *postagePolicyName,*postagePolicyDesc;
PROPERTY_ASSIGN long postagePolicyId;
PROPERTY_ASSIGN int count;
PROPERTY_STRONG NSArray<shopPostagePolicySub *> *shopPostagePolicySubs;
@end



///规格
@interface YCShopSpecs : YCBaseImageModel
@property (nonatomic,strong) NSString *specDesc,*shippingProvinceName,*specName,*parameterName,*specInfo;
@property (nonatomic,strong) NSNumber *shippingAreaId,*specId,*specMoneyPrice,*parameterValue,*specQty,*antPrice,*isShipping;

@property (nonatomic,strong) NSArray *shopShippingAreas;
@end


///团拼攻略S
@interface YCShopProductStrategyModel : YCBaseModel
///优惠等级
@property(nonatomic,strong) NSString *strategyName;
///优惠详情
@property(nonatomic,strong) NSString *details;
///价格
@property(nonatomic,strong) NSNumber *disPrice;

///优惠详情--外面处理过的数据
@property(nonatomic,strong) NSString *detailInfo;
///优惠范围～～>最小
@property(nonatomic,strong) NSNumber* gteCount;
///优惠范围～～>最大
@property(nonatomic,strong) NSNumber* ltCount;

///优惠折扣
@property(nonatomic,strong) NSString *discount;
///折扣背景颜色S
@property(nonatomic,strong) UIColor *BGColor;

@end

///认证
@interface YCShopVerifyM : YCBaseImageModel
@property (nonatomic,strong) NSString *verifyName;
@end

///图片
@interface YCShopProductImagesM : YCBaseImageModel
@property (nonatomic,strong) NSNumber *seqNo;
@end

@interface YCShopGroupBuySubM : YCBaseModel
///用户model
@property(nonatomic,strong) YCLoginUserM *appUser;
/**
 *  是否付款 isPay
 *  是否是自己
 */
@property(nonatomic,strong) NSNumber *isPay,*isMe,*qty;

@property(nonatomic,strong)NSString * price;

///团（付款情况）
@property(nonatomic,assign,readonly) YCGroupPayState groupPayState;
@end

@class YCShopProductM;
@interface ShopProductRecommend : YCBaseModel
PROPERTY_STRONG NSString *recommendProductName,*recommendProductImage,*recommendProductDesc;
PROPERTY_STRONG NSNumber *productRecommendId,*recommendProductPrice;
@end
@class YCShopSpecs,YCShopProductM,YCShopSpecM;

@interface YCItemDetailM : YCBaseImageModel
@property (nonatomic,strong) NSString *brief,*categoryName,*categorySubName,*shopNumber,*productName,*videoPath;

///showPrice 根据规格价格变动
@property (nonatomic,strong) NSNumber *commentCount,*isMyFavorite,*marketPrice,*actuallyQty,*content,*showPrice,*showSalesQty,*isPresell,*productId;
@property (nonatomic,strong) NSNumber *isEnough,*tag,*status;
/**
 *  是否是发起人 isSponsor
    数量  qty
    金额  currentMoney
 */
@property(nonatomic,strong) NSNumber *isSponsor,*qty,*currentMoney;

///商品图片放置web
@property(nonatomic,strong) NSString *htmlPath;
///商品图片放置web位置
@property(nonatomic,assign) uint htmlPosition;
/**
   团拼ID groupBuyId
   还缺多少个人 gapCount
   是否参与团 isJoin
 
 */
@property(nonatomic,strong) NSNumber *groupBuyId,*gapCount,*isJoin,*orderId,*isPay;
///发起人得到信息
@property(nonatomic,strong) YCLoginUserM *appUser;

@property (nonatomic,strong) YCShopSpecs *shopShipping;
///可解散团拼商品基本信息
@property(nonatomic,strong) YCShopProductM *shopProduct;
///商品规格
@property(nonatomic,strong) YCShopSpecM * shopSpec;
///邮费政策
PROPERTY_STRONG shopPostagePolicy *shopPostagePolicy;
/**
 *  shopSpecs 规格s
 *  shopProductImages 商品内容图片s
 *  shopProductParameters
 *  shopProductCoverImages 抽屉动画图片s
 *  shopProductVerifys  认证s
 *  shopGroupBuySubs 参团人s
 *  
 *  
 *
 */
@property (nonatomic,strong) NSArray *shopSpecs,*shopProductImages,*shopProductParameters,*shopProductCoverImages,*shopProductVerifys,*shopGroupBuySubs;
///userImg
@property(nonatomic,strong) NSMutableArray *userImages;
PROPERTY_STRONG NSArray<ShopProductRecommend *> *shopProductRecommends;

/**
 *  下一个规格
 *  当前规格
 */
@property(nonatomic,strong) YCShopProductStrategyModel *nextProductStrategy,*nowProductStrategy;

///团拼攻略内容S
@property(nonatomic,strong) NSMutableArray *shopProductStrategys;
@property(nonatomic,strong)YCRecipientAddressM *shopUserAddress;


///商品图片排序
- (void )sortShopProductImages;
- (NSArray *)sortShopProductImagesByImages:(NSArray *)images;

///创建描述
-(YYTextLayout *)creatDescTextLayout;
@end

@interface YYTextLayout (yc)
+(YYTextLayout *)creatTextLayoutWith:(NSString *)title desc:(NSString *)desc;
@end