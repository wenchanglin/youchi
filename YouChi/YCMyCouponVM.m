//
//  YCMyCouponVM.m
//  YouChi
//
//  Created by 朱国林 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyCouponVM.h"


@implementation YCMyCouponVM
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    
    return self.modelsProxy.count?self.modelsProxy.count:0;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell0;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return DAMAI_RATIO_2(SCREEN_WIDTH, 295, 103+27)+7+35;
}


- (RACSignal *)mainSignal
{
    
    WSELF;
    return [[ENGINE POST_shop_array:self.urlString parameters:@{kToken:[YCUserDefault currentToken],} parseClass:[YCShopCategoryM class] pageInfo:self.pageInfo]doNext:^(NSArray * x) {
        SSELF;
        
    
        if (self.nextBlock) {
            for (YCShopCategoryM  * m in x) {
                if (m.validDate) {
                    m.validDate = [NSString stringWithFormat:@"有效时间:%@",[[YCDateFormatter shareDateFormatter]stringFromNumber:(id)m.validDate]];
                }
            }
            
            self.nextBlock(x);
            //YCShopCategoryM *m = self.modelsProxy.firstObject;
            self.pageInfo.loadmoreId = @(0);
        }
        
    }];
    
}

-(RACSignal *)onReceiveCouPon:(NSNumber *)couPonId{
    
    return [ENGINE POSTBool:@"coupon/receiveCoupon.json" parameters:@{kToken:[YCUserDefault currentToken],@"couponId":couPonId}];
}


@end
