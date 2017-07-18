//
//  YCOrderDetailedVM.m
//  YouChi
//
//  Created by 李李善 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCAboutGoodsM.h"
#import "YCOrderDetailedVM.h"
#define  RowHeight 5.f

// cell00 为空cell 作为cell之间分割用
/*
 section 0 订单号
 section 1 退款情况（根据状态来显示或隐藏cell）
 section 2 地址
 section 3 物流情况（根据情况来显示或隐藏cell）
 
 */

@implementation YCOrderDetailedVM
@synthesize model;
GETTER_LAZY_SUBJECT(orderDetaileUpdateSignal);

-(instancetype)initWithIdx:(NSInteger)aId{
    if (self =[super init]) {
        
        self.title =@"订单详情";
        self.Id = @(aId);
    }
    return self;
    
}

//*
- (NSInteger)numberOfSections{
    
    return self.model?7:0;
    
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    
    if      (section == 0||section==1 )return 2;
    else if (section == 2) {
        if (self.model.description) {
            return 3;
        }
        return 2;
    }
    else if (section == 3)return 1;
    else if (section == 4)return self.model.shopOrderProducts.count + 1;
    
    else if (section == 5){ // 团拼
        
        if (self.model.shopGroupBuySubs.count == 0) {
            return 0;
        }
        return self.model.shopGroupBuySubs.count + 1;
    }
    else if (section == 7)return 1;
    else {
        if (self.model.isMoneyPay.boolValue == NO) {
            return 0;
        }
        else{
            return 2;
        }
        
    }
    return 0;
}




- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        if (indexPath.row==0)
            return cell0;
        return cell00;
    }
    
    else if (indexPath.section == 1){
        
        if      (indexPath.row==0) return self.model.refundStatus.intValue!= 0 ?cell10 :cell00;  // 若没有退款，给空cell
        
        return cell00;
    }
    
    else if (indexPath.section == 2){
        
        if      (indexPath.row==0){
            
            if (self.model.isTeamOrder.boolValue) {  // 团拼
                
                return cell3;
            }
            
            return cell1;
        }
        if (indexPath.row == 1) {
            return cell13;
        }
        return cell00;
    }
    
    else if (indexPath.section == 3){
        return cell2;
    }
    
    else if (indexPath.section == 4) {
        if (indexPath.row != self.model.shopOrderProducts.count )return cell4 ;
        return cell4_1;
        
    }else if (indexPath.section == 5){
        
        if (indexPath.row == self.model.shopGroupBuySubs.count) {
            
            return cell12;
        }
        
        return cell5;
    }
    
    else if (indexPath.section == 7){
        return cell9;
    }
    
    else{
        if (indexPath.row == 0)return cell6;
        return  cell8;
    }
    
    
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row==0)return 43.f;
        return RowHeight;
    }
    
    if (indexPath.section == 1)  // 退款
    {
        if (indexPath.row==0)return self.model.refundStatus.intValue!= 0 ?125.f:0;
        else{
            return self.model.refundStatus.intValue!= 0 ?RowHeight:0;
        }
    }
    
    else if (indexPath.section == 2){  // 地址
        
        if (indexPath.row==0){
            
            if (self.model.isTeamOrder.boolValue) {  // 团拼地址
                
                return 138;
            }
            
            return 80.f;
        }
        
        if (indexPath.row == 1) {
            return 40;
        }
        
        return RowHeight;
    }
    else if (indexPath.section == 3){ // 物流
        if (self.orderSendingState.intValue == 0) {
            return 0;
        }
        else{
            YCShopWuliuInfoM *shopWuliuInfo =self.model.shopWuliuInfos.firstObject;
            return shopWuliuInfo.wuliuJson.count !=0 ? 210.f:75.f;
        }
        
    }
    
    else if (indexPath.section == 4) {
        if (indexPath.row != self.model.shopOrderProducts.count)return 145.f ;
        return RowHeight;
    }
    
    else if (indexPath.section == 5){
        
        if (indexPath.row == self.model.shopGroupBuySubs.count) { // 团拼
            
            return 49;
        }
        return 98;
    }
    
    else if (indexPath.section == 7){
        return 44;
    }
    
    else{
        if      (indexPath.row == 0)return 119.f;
        return  33.f;
    }
}

//*/


- (RACSignal *)mainSignal
{
    NSMutableDictionary *param = @{@"orderId":@(self.Id.intValue),kToken:[YCUserDefault currentToken]}.mutableCopy;
    [param addEntriesFromDictionary:self.parameters];
    
    return [[ENGINE POST_shop_object:@"order/getOrderDetail.json" parameters:param parseClass:[YCMyOrderM class] parseKey:kContent ]doNext:^(YCMyOrderM * x) {
        /*
        YCCellInfo *blank = [YCCellInfo cellInfoWithId:cell00 height:^CGFloat(NSIndexPath *indexPath) {
            return RowHeight;
        } number:^NSInteger(NSInteger section) {
            return 1;
        }];
        
        YCCellModelBlock modelBlock  = [YCCellInfo model:^id(NSIndexPath *indexPath) {
            return x;
        }];
        [self.cellInfos setArray:@[
                                [YCCellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath *indexPath) {
            return 43.f;
        } number:^NSInteger(NSInteger section) {
            return 1;
        } model:nil],
                                blank,
                                [YCCellInfo cellInfoWithId:cell10 height:^CGFloat(NSIndexPath *indexPath) {
            return x.refundStatus.intValue!= 0 ?125.f:0;
        } number:^NSInteger(NSInteger section) {
            return x.refundStatus.intValue!= 0 ?1:0;;
        } model:nil],
                                blank,
                                
                                [YCCellInfo cellInfoWithId:cell3 height:^CGFloat(NSIndexPath *indexPath) {
            return 43.f;
        } number:^NSInteger(NSInteger section) {
            return 1;
        } model:nil],
                                blank,
                                [YCCellInfo cellInfoWithId:cell2 height:^CGFloat(NSIndexPath *indexPath) {
            return 43.f;
        } number:^NSInteger(NSInteger section) {
            return 1;
        } model:nil],
                                blank,
                                [YCCellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath *indexPath) {
            return 43.f;
        } number:^NSInteger(NSInteger section) {
            return 1;
        } model:nil],
                                blank,
                                [YCCellInfo cellInfoWithId:cell12 height:^CGFloat(NSIndexPath *indexPath) {
            return 43.f;
        } number:^NSInteger(NSInteger section) {
            return 1;
        } model:nil]
                                
                                   ]];
        //*/
        self.model = x;
        self.orderSendingState = x.shippingStatus;
        
    }];
    
}



-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3){
        return self.model.shopWuliuInfos.firstObject;
    }
    
    else if (indexPath.section == 5||indexPath.section == 6){
        
        self.model.isOrderDetail = YES;
        
        return self.model;
    }
    
    
    return self.model;
}


@end
