//
//  YCRefundConditionVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/23.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRefundConditionVM.h"

@implementation YCRefundConditionVM


-(instancetype)initWithModel:(id)aModel{
    if (self ==[super initWithModel:aModel]) {
        self.oldAboutGoodsM = aModel;
        self.title = @"退货情况";
    }
    return self;
}

- (RACSignal *)mainSignal
{
    return [[ENGINE POST_shop_object:@"order/getReturnGoodsByOrderProductId.json" parameters:@{@"orderProductId":self.Id,kToken:[YCUserDefault currentToken]} parseClass:[YCMyOrderM class] parseKey:kContent]doNext:^(id x) {
        self.aboutGoodsM = x;
        
    }];
}

-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.aboutGoodsM;
}

///撤销申请退货
- (RACSignal *)onCancelRefundSignalRefundId:(NSInteger)refundId{

    return [ENGINE POSTBool:@"order/cancelRefundRequest.json" parameters:@{@"refundId":@(refundId),kToken:[YCUserDefault currentToken]}];
}
@end
