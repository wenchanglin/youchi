//
//  YCYouChiShopM.m
//  YouChi
//
//  Created by sam on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouChiShopM.h"

@implementation YCAdListM

@end

@implementation YCChannelList

@end


@implementation YCShopRecommendSubitems
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"imagePath" : @"recommendSubitemImagePath",
             };
}
@end

@implementation shopFunds

@end

@implementation YCYouChiShopM
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"adList" : [YCAdListM class],
             @"channelList" : [YCChannelList class],
             @"shopRecommendSubitems" : [YCShopRecommendSubitems class] };
}
@end


@implementation YCLastCouponAndOrder

@end


@implementation YCYouChiShopPopM


@end