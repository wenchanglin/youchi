//
//  YCSelectCouponVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSelectCouponVM.h"

@implementation YCSelectCouponVM
GETTER_LAZY_SUBJECT(selectCouponSignal);

-(instancetype)initWithCartIdArray:(NSArray<NSNumber *> *)cartIdArray
{
    if (self = [self init]) {
        self.title = @"商品优惠卷";
        self.cartIds = [[NSString alloc]initWithFormat:@"%@",[cartIdArray componentsJoinedByString:@","]];
    }
    return self;
}


-(NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    return cell0;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170.f;
}

-(RACSignal *)mainSignal
{
    
    return [[ENGINE POST_shop_array:@"coupon/getOptionalUserCoupon.json" parameters:@{@"cartIds":self.cartIds,kToken:[YCUserDefault currentToken]} parseClass:[YCShopCategoryM class] pageInfo:self.pageInfo]doNext:^(NSArray * x) {
        
        
        if (self.nextBlock) {
            [x enumerateObjectsUsingBlock:^(YCShopCategoryM * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.validDate = [[YCDateFormatter shareDateFormatter] stringFromNumber:(id)obj.validDate];
            }];
            self.nextBlock(x);
        }
    }];
}


@end
