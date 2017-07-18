//
//  YCAboutGoodsM.m
//  YouChi
//
//  Created by 朱国林 on 16/1/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
/**
 TODO: + 说明：
 如果代码中有该标识，说明在标识处有功能代码待编写，待实现的功能在说明中会简略说明。
 
 FIXME: + 说明：
 如果代码中有该标识，说明标识处代码需要修正，甚至代码是错误的，不能工作，需要修复，如何修正会在说明中简略说明。
 
 MARK: + 说明：
 如果代码中有该标识，说明标识处代码虽然实现了功能，但是实现的方法有待商榷，希望将来能改进，要改进的地方会在说明中简略说明。
 */
#import "YCModel.h"
#import "YCAboutGoodsM.h"
#import "YCRecipientAddressM.h"

@implementation YCAboutGoodsM
- (void)dealloc{
    //    OK
}
- (instancetype)init{
    
    if (self = [super init]) {
        _isSelected = YES;
    }
    return self;
}

/*
 @property (nonatomic,strong) YCShopSpecM *shopSpec;
 @property (nonatomic,strong) YCShopProductM *shopProduct;
 @property (nonatomic,strong) NSMutableArray * shopSpecs;
 @property (nonatomic,strong) NSMutableArray * shopCarts;
 @property (nonatomic,strong) YCRecipientAddressM *address;
 @property (nonatomic,assign)BOOL isOrderDetail;
 @property (nonatomic,strong) NSURL *productImagePath;
 @property (nonatomic,strong) YCShopCategoryM * shopCoupon;
 */
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"address" : [YCRecipientAddressM class],
             @"shopCarts" : [YCAboutGoodsM class],
             @"shopProduct" : [YCShopProductM class],
             
             @"shopSpec" : [YCShopSpecM class],
             @"shopSpecs" : [YCShopSpecM class],
             @"shopCoupon" : [YCShopCategoryM class]};
}
@end

@implementation YCShopProductM
- (void)dealloc{
    //    OK
}



/*
 @property (nonatomic,strong) YCShopSpecsM *shopShipping;
 ///团拼-<商品内容图片，商品认证，商品攻略,自动播放图片>
 @property (nonatomic,strong) NSArray *shopProductImages,*shopProductVerifys,*shopProductStrategys,*shopProductCoverImages,*shopSpecs;
 ///团拼认证
 @property(nonatomic,strong) YCShopVerifyM *shopVerify;
 */
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"shopProductStrategys":[YCShopProductStrategyModel class],
             @"shopProductImages":[YCShopProductImagesM class],
             @"shopProductVerifys":[YCShopProductM class],
             @"shopShipping":[YCShopSpecs class],
             @"shopSpecs":[YCShopSpecs class],
             @"shopProductCoverImages":[YCShopProductImagesM class],
             @"shopVerify":[YCBaseImageModel class],
             };
}



@end

@implementation YCShopSpecM
- (void)dealloc{
    //    OK
}


@end


