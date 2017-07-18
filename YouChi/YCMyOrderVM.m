//
//  YCMyOrderVM.m
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCFixOrderM.h"
#import "YCMyOrderVM.h"
#import "YCAboutGoodsM.h"
#import "YCOrderNumView.h"
#import <YYKit/YYKit.h>
#import "YCMyOrderM.h"
@implementation YCMyOrderVM
{
    NSInteger _actionType;
}

- (NSMutableArray *)CartIds{

    if (!_CartIds) {
        _CartIds = [NSMutableArray array];
    }
    
    return _CartIds;
}

-(instancetype)initWithIdx:(NSInteger)aId{
    if (self ==[super init]) {
        _actionType =aId;
        _integer = aId;
    }
    return self;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCMyOrderM *m = [self.modelsProxy objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return m;
    }else if (indexPath.row == m.shopOrderProducts.count + 1 ){
        
        return m;
    }
    
    return m.shopOrderProducts[indexPath.row-1];
}

- (NSInteger)numberOfSections{

    return self.modelsProxy.count?:0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    
    YCMyOrderM *m = [self.modelsProxy objectAtIndex:section];
    return m.shopOrderProducts.count + 2;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        YCMyOrderM *m = [self.modelsProxy objectAtIndex:indexPath.section];
        
        if (indexPath.row == 0) {
            return cell1;
        }else if (indexPath.row == m.shopOrderProducts.count + 1 ){
            
            return cell2;
        }else
            
            return cell0;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        YCMyOrderM *m = [self.modelsProxy objectAtIndex:indexPath.section];
        
        if (indexPath.row == 0) {
            return 28;
        }else if (indexPath.row == m.shopOrderProducts.count + 1 ){
            
            return 35;
        }else
            
            return 87;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


- (RACSignal *)mainSignal
{
    
    return [[ENGINE POST_shop_array:@"order/getMyOrderList.json" parameters:@{@"actionType":@(_actionType),kToken:[YCUserDefault currentToken]} parseClass:[YCMyOrderM class] pageInfo:self.pageInfo]doNext:^(NSArray *x){
    
        self.insertBackSection = self.numberOfSections;
        if (self.nextBlock) {
            self.nextBlock(x);
        }
        self.pageInfo.loadmoreId = x.count>0?@(0):nil;
        
    }];
}


- (RACSignal *)onConfirmOrderSignal:(NSNumber *)orderId
{
//    NSDictionary *param = @{
//                            kToken:[YCUserDefault currentToken],
//                            @"orderId":orderId,
//                            } ;
    return [self payItNow:orderId];
    /*
    return [[ENGINE POST_shop_object:@"order/payItNow.json" parameters:param parseClass:[YCFixOrderM class] parseKey:kContent].deliverOnMainThread flattenMap:^RACStream *(YCFixOrderM *m) {
        if (m.payType.intValue == 1) { /// 支付宝
            
            return [ENGINE aliPayWithTradeNO:m.tradeNO productName:m.productName productDescription:m.productDescription amount:m.amount notifyURL:m.notifyURL];
            
        }
        else if (m.payType.intValue == 2){/// 微信
            
            return [ENGINE wxOrderWithAppId:m.appid partnerId:m.partnerid prepayId:m.prepayid noncestr:m.noncestr timeStamp:m.timestamp orderNo:m.orderNo package:m.package sign:m.sign];
        }
        return [RACSignal empty];
    }];
    
    */
}


@end
