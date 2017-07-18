//
//  YCItemDetailM.m
//  YouChi
//
//  Created by sam on 16/1/8.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCItemDetailM.h"
@implementation shopPostagePolicySub
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"name":@"shopProvince.name"
             };
}

@end

@implementation shopPostagePolicy
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"shopPostagePolicySubs":[shopPostagePolicySub class],
             };
}


@end



@implementation YCShopSpecs

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"shopShippingAreas":[YCShopSpecs class],
             };
}


@end



@implementation YCShopProductStrategyModel


@end



@implementation YCShopVerifyM


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"verifyName":@"shopVerify.verifyName",
             @"imagePath":@"shopVerify.imagePath",
             };
}
@end

@implementation YCShopProductImagesM


@end


@implementation YCShopGroupBuySubM
- (YCGroupPayState)groupPayState
{
    YCShopGroupBuySubM *m = self;
    if (m.isPay.boolValue) {
        return  YCGroupPayStateHadPay;//已支付
    }
    else {
        //没有支付并且不是自己
        if (!m.isPay.boolValue&&!m.isMe.boolValue)
        {
            return  YCGroupPayStateNotPay;//他人未支付
        }
        
        else{
            return  YCGroupPayStateSelfNotPay;//自己没有支付
        }
    }
}


@end


@implementation ShopProductRecommend

@end
@implementation YCItemDetailM


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"shopSpecs" : [YCShopSpecs class],
             @"shopProductStrategys":[YCShopProductStrategyModel class],
             @"shopProductImages":[YCShopProductImagesM class],
             @"shopProduct":[YCShopProductM class],
             @"shopShipping":[YCShopSpecs class],
             @"shopUserAddress":[YCRecipientAddressM class],
             @"shopGroupBuySubs":[YCShopGroupBuySubM class],
             @"shopProductCoverImages":[YCShopProductImagesM class],
             @"appUser":[YCLoginUserM class],
             @"shopProductVerifys":[YCShopVerifyM class],
             @"shopProductRecommends":[ShopProductRecommend class]
             };
}

- (void)sortShopProductImages
{
    _shopProductImages = [_shopProductImages sortedArrayUsingComparator:^NSComparisonResult(YCShopProductImagesM  *_Nonnull obj1, YCShopProductImagesM  *_Nonnull obj2) {
        return obj1.seqNo.intValue>=obj2.seqNo.intValue;
    }];
}

- (NSArray *)sortShopProductImagesByImages:(NSArray *)images
{
    return [images sortedArrayUsingComparator:^NSComparisonResult(YCShopProductImagesM  *_Nonnull obj1, YCShopProductImagesM  *_Nonnull obj2) {
        
        return obj1.seqNo.intValue>obj2.seqNo.intValue;
    }];
}

-(YYTextLayout *)creatDescTextLayout
{
    YCItemDetailM *x = self;
    YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH-2*YCItemDetailEdge, HUGE) insets:UIEdgeInsetsMake(20, YCItemDetailInnerEdge, 20, YCItemDetailInnerEdge)];
    
    NSMAString *title = NSMAString_initWithString(x.brief);
    [title appendString:@"\n"];
    title.font = KFont(20);
    title.color = UIColorHex(0x333333);
    title.lineSpacing = 8;
    
    NSMAString *desc = NSMAString_initWithString(x.desc);
    [desc appendString:@"\n"];
    
    desc.font = KFont(14);
    desc.color = [UIColor lightGrayColor];
    desc.lineSpacing = 6;
    [title appendAttributedString:desc];
    
    
    return [YYTextLayout layoutWithContainer:tc text:title];
}
@end


@implementation YYTextLayout (yc)
+ (YYTextLayout *)creatTextLayoutWith:(NSString *)_title desc:(NSString *)_desc
{
    YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH-2*YCItemDetailEdge, HUGE) insets:UIEdgeInsetsMake(20, YCItemDetailInnerEdge, 20, YCItemDetailInnerEdge)];
    
    NSMAString *title = NSMAString_initWithString(_title);
    [title appendString:@"\n"];
    title.font = KFont(20);
    title.color = UIColorHex(0x333333);
    title.lineSpacing = 8;
    
    NSMAString *desc = NSMAString_initWithString(_desc);
    [desc appendString:@"\n"];
    
    desc.font = KFont(14);
    desc.color = [UIColor lightGrayColor];
    desc.lineSpacing = 6;
    [title appendAttributedString:desc];
    
    
    return [YYTextLayout layoutWithContainer:tc text:title];
}


@end