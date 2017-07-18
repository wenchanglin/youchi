//
//  YCMyInitiateGroupM.h
//  YouChi
//
//  Created by ant on 16/5/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved. YCLoginUserM
//
#import "YCMeM.h"
#import "YCModel.h"
#import "YCAboutGoodsM.h"
#import "YCNewstGroupM.h"
@class YCNowProductStrategyM,YCshopGroupBuySubsM;

@interface YCMyInitiateGroupM : YCBaseImageModel
@property(nonatomic,strong)YCMeM *appUser;
@property(nonatomic,strong)YCShopProductM *shopProduct;
@property(nonatomic,strong)NSArray<YCshopGroupBuySubsM *> *shopGroupBuySubs;
@property(nonatomic,strong)YCNowProductStrategyM *nowProductStrategy ,*nextProductStrategy;
@property(nonatomic,strong)NSNumber *joinCount,*groupBuyId,*gapCount,*isEnough,*isJoin;


PROPERTY_STRONG_READONLY NSAttributedString *groupCountAttr,*priceAttr;

PROPERTY_STRONG_READONLY YYTextLayout *briefLayout;

PROPERTY_STRONG_READONLY YCLinearInfoManager *infoMgr;

@end

@interface YCMyParticipationGroupM : YCMyInitiateGroupM

@end

@interface YCNowProductStrategyM : YCBaseModel
@property(nonatomic,strong)NSNumber *discount,*gteCount;
@property(nonatomic,strong)NSString *strategyName;
@end

@interface YCshopGroupBuySubsM : YCBaseModel
@property(nonatomic,strong)YCMeM *appUser;
@end