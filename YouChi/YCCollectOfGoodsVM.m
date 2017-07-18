//
//  YCCollectOfGoodsVM.m
//  YouChi
//
//  Created by 朱国林 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfGoodsVM.h"
#import "YCAboutGoodsM.h"
@implementation YCCollectOfGoodsVM




- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell0;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 133.;
}



- (RACSignal *)mainSignal
{
    return [[ENGINE POST_shop_array:@"product/getMyFavoriteProduct.json" parameters:@{
                                                                                kToken:[YCUserDefault currentToken]
                                                                                } parseClass:[YCAboutGoodsM class] parseKey:kContent pageInfo:self.pageInfo  ]doNext:^(id x) {
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];
}

@end
