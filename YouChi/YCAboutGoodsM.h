//
//  YCAboutGoodsM.h    shopSpec  attribute
//  YouChi
//
//  Created by 朱国林 on 16/1/5. createdDate
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.  ,*refundRemark,*refuseRemark
//  kuaidiName  specName refundProcessDesc   refundDesc  productFavoriteId shippingNo mustPayMoney isRefund specAntPrice orderProductId wuliuInfoId refundStatus


#import "YCModel.h"
#import "YCRecipientAddressM.h"
#import "YCShopCategoryM.h"
#import "YCItemDetailM.h"
@class YCShopSpecM,YCShopProductM,YCShopSpecs;

@interface YCAboutGoodsM : YCBaseImageModel
@property (nonatomic,strong) NSString *productName,*productPrice,*loction;
@property (strong,nonatomic) NSNumber *qty,*cartId,*actualityPayTotal,*accountPayTotal,*preferentialTotal,*productTotalPrice,*freightPrice,*specId,*productId,*isMoneyPay,*howManyFullShipping,*isPresell,*groupCoupon;
@property (nonatomic,strong) YCShopSpecM *shopSpec;
@property (nonatomic,strong) YCShopProductM *shopProduct;
@property (nonatomic,strong) NSMutableArray * shopSpecs;
@property (nonatomic,strong) NSMutableArray * shopCarts;
@property (nonatomic,strong) YCRecipientAddressM *address;

@property (nonatomic,assign)BOOL isOrderDetail;
@property (nonatomic,strong) NSString *productImagePath;
@property (nonatomic,strong) YCShopCategoryM * shopCoupon;
@property (nonatomic,assign)BOOL isSelected;
@end


@class YCShopVerifyM;
@interface YCShopProductM : YCBaseImageModel
///commentCount 评论数
@property (strong,nonatomic) NSNumber *productId,*isMyFavorite,*marketPrice,*shopPrice,*status,*showSalesQty,*antPrice,*pv,*showQty,*isQtyExist,*isMoneyPay,*isPresell,*commentCount,*isTeamProduct;
@property (nonatomic,strong) NSString *productName,*brief,*categoryName;

@property (nonatomic,strong) YCShopSpecs *shopShipping;
///团拼-<商品内容图片，商品认证，商品攻略,自动播放图片>
@property (nonatomic,strong) NSArray *shopProductImages,*shopProductVerifys,*shopProductStrategys,*shopProductCoverImages,*shopSpecs;
///团拼认证
@property(nonatomic,strong) YCShopVerifyM *shopVerify;



@end


@interface YCShopSpecM : YCBaseImageModel
@property (nonatomic,strong) NSString *specName,*parameterName,*productName,*specDesc;
@property (strong,nonatomic) NSNumber *specId,*antPrice,*specMoneyPrice,*specQty;
@property(nonatomic,strong) NSString *productImagePath;

/*-----------------处理过的数据---------------------*/
@property (nonatomic,strong) NSString *specInfo;
@end




