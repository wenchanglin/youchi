//
//  YCShopCategoryM.h
//  YouChi
//
//  Created by 李李善 on 16/1/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
@class YCShopCategorySubsM,YCShopKeyword;
@interface YCShopCategoryM : YCBaseImageModel

@property(nonatomic,strong) NSString *categoryName,*validDate,*btnTitle,*brief,*productName,*keyword,*couponName,*couponDesc,*specName,*categorySubName;

@property(nonatomic,strong) NSNumber *shopPrice,*oneCateValue,*twoCateValue,*isReceived,*isEnd,*userCouponId,*isUsed,*isExpired,*couponId,*marketPrice,*categorySubId,*categoryId,*productId,*antPrice,*specId,*isMoneyPay,*specMoneyPrice;
@property(nonatomic,strong) NSString *couponImagePath,*productImagePath;



@property(nonatomic,strong) NSMutableArray *shopCategorySubs,*shopSpecs;


@property(nonatomic,strong) YCShopKeyword *shopKeyword;
@property(nonatomic,strong) YCShopCategorySubsM *shopCoupon;

///在这里做判断，是否是已过期
-(void)onChangeAllValue;


@end



@interface YCShopCategorySubsM : YCShopCategoryM


@end

@interface YCShopKeyword : YCShopCategoryM


@end
