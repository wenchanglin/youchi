//
//  YCGoodsOrderVM.m
//  YouChi
//
//  Created by 朱国林 on 15/11/25.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFixOrderVM.h"
#import "YCCatolog.h"
#import <YYKit/YYKit.h>
#import "DataSigner.h"
#define  RowHeight 5.f
#define SectionHight 35.f




@implementation YCFixOrderVM
@synthesize model;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"确认订单";
        self.payType = YCPayTypeWeixin -1;
        if (!self.cartIdArrayJson) {
            self.cartIdArrayJson = @"[]";
        }
        self.descriptions = @"";
    }
    return self;
}


- (instancetype)initWithPresellProductId:(NSNumber *)productId qty:(NSNumber *)qty productSpecId:(NSNumber *)productSpecId{
    
    self.productId = productId;
    self.qty = qty;
    self.productSpecId = productSpecId;
    self.isPresell = YES;
    return [self init];
    
}

-(instancetype)initWithCartIdArray:(NSArray<NSNumber *> *)cartIdArray
{
    _cartIdArray = cartIdArray.mutableCopy;
    
    if (cartIdArray.count > 0) {
        self.cartIdArrayJson = [[NSString alloc]initWithFormat:@"[%@]",[cartIdArray componentsJoinedByString:@","]];
        
    }
    return [self init];
}

/*
- (NSInteger)numberOfSections{
    
    return self.model?7:0;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    if      (section == 1||section==4)return 2+1+1;
    else if (section == 2)return self.model.shopCarts.count;
    else if (section == 3)return 1;
    else if (section == 5)return 2;
    else if (section == 6)return 1;
    return 2;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row==0){
            return cell0;
        }
        return cellInset;
    }
    
    else if (indexPath.section == 1){
        if      (indexPath.row==0) return cell1_1;
        else if (indexPath.row==1) return cell1;
        else if (indexPath.row==2) return cell2;
        return cell2_1;
    }
    else if(indexPath.section == 2){
        return cell3;
    }
    else if (indexPath.section == 3){
        return cell18;
    }
    
    else if (indexPath.section == 4) {
        if      (indexPath.row == 0)return cell3_1;
        else if (indexPath.row == 1)return cell4;
        else if (indexPath.row == 2)return cell5;
        return cellInset;
    }
    
    else if (indexPath.section == 6){
        
        return cell8;
    }
    
    else{
        if      (indexPath.row == 0)return cell6;//;
        else return cell7;
    }
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row==0){
            
            if (self.orderType == YCOrderTypeGroup) { // 团拼地址改变
                return 138.0;
            }
            return 80.f;
        }
        return RowHeight;
    }
    
    else if (indexPath.section == 1){
        
        if     (indexPath.row==0)return  SectionHight;
        else if(indexPath.row==1||indexPath.row==2) return 54.f;
        return RowHeight;
    }
    else if (indexPath.section == 2){
        return  162.f;
    }
    else if (indexPath.section == 3){
        return 42;
    }
    else if (indexPath.section == 4) {
        if (self.isPresell || self.orderType == YCOrderTypeGroup) { // 预售，不要优惠券
            return 0;
        }
        if     (indexPath.row == 0) return SectionHight;
        else if(indexPath.row == 1) return self.isUserCoupon?120.f:0;
        else if(indexPath.row == 2) return 40.f;
        return RowHeight;
    }
    
    
    else if (indexPath.section == 6){
        
        return 33;
    }
    
    else{
        if      (indexPath.row == 0) return 119.f;
        return 33.f;
    }
}


-(id )modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return self.model.address;
    }
    else if (indexPath.section==2) {
        return self.model.shopCarts[indexPath.row];
    }
    return self.model;
}
*/

- (RACSignal *)mainSignal{
    
    NSDictionary *param = [NSDictionary dictionary];
    
    NSString *path;
    
    //预售
    if (self.isPresell) {
        
        path = @"orderPresell/getVirtualOrderPresell.json";
        param = @{
                  kToken:[YCUserDefault currentToken],
                  @"productId":self.productId,
                  @"qty":self.qty,
                  @"productSpecId":self.productSpecId,
                  };
        
    }
    else
    {
        
        ///商品
        if (self.orderType == YCOrderTypeCommodity) {
            path = @"order/getVirtualOrder.json";
            param = @{
                      kToken:[YCUserDefault currentToken],
                      @"cartIdArrayJson":self.cartIdArrayJson,
                      @"userCouponId":@(self.shopCategory.userCouponId.intValue),
                      };
        }
        ///团拼
        else if (self.orderType == YCOrderTypeGroup) {
            
            path = @"groupBuy/toPay.json";
            param = @{
                      kToken:[YCUserDefault currentToken],
                      };
            
        }
    }
    
    NSMutableDictionary *dict = param.mutableCopy;
    [dict addEntriesFromDictionary:self.parameters];
    
    return [[ENGINE POST_shop_object:path parameters:dict parseClass:[YCAboutGoodsM class] parseKey:kContent ]doNext:^(YCAboutGoodsM * x){
        WSELF;
        if (self.orderType == YCOrderTypeGroup) {
            x.shopCarts = [NSMutableArray array];
            
            YCAboutGoodsM *aboutModel = [YCAboutGoodsM new];
            aboutModel.shopSpec = x.shopSpec;
            aboutModel.shopProduct = x.shopProduct;
            aboutModel.productPrice = [NSString stringWithFormat:@"%.2f",x.productTotalPrice.floatValue];
            aboutModel.isSelected = YES;
            aboutModel.productName = x.shopProduct.productName;
            
            aboutModel.qty = x.qty;
            
            [x.shopCarts addObject:aboutModel];
        }
        
        self.model = x;
        
        YCAboutGoodsM *m = x.shopCarts.firstObject;
        
        self.productId = m.shopProduct.productId;
        
        self.address = x.address;
        
        CellInfo *blank = [CellInfo cellInfoWithId:cellInset height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return RowHeight;
        } number:CellInfo_number_1];
        
        CellNumberBlock couponNumber = [CellInfo number:^NSInteger(NSInteger section) {
            SSELF;
            // 预售，不要优惠券
            if (self.isPresell || self.orderType == YCOrderTypeGroup) {
                return 0;
            }
            return 1;
        }];
        
        CellModelBlock modelBlock = [CellInfo model:^id _Nullable(NSIndexPath * _Nonnull indexPath) {
            return x;
        }];
        
        [self.cellInfos setArray:@[
                                   //地址
                                   [CellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            SSELF;
            if (self.orderType == YCOrderTypeGroup) { // 团拼地址
                return 138.0;
            }
            return 80.f;
        } number:CellInfo_number_1 model:^id _Nullable(NSIndexPath * _Nonnull indexPath) {
            SSELF;
            return self.address;
        }],
                                   //空白
                                   blank,
                                   //支付
                                   [CellInfo cellInfoWithId:cell1_0 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return SectionHight;
        } number:CellInfo_number_1 model:^id _Nullable(NSIndexPath * _Nonnull indexPath) {
            return @"支付方式";
        }],
                                   [CellInfo cellInfoWithId:cell1_1 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 54.f;
        } number:CellInfo_number_1],
                                   [CellInfo cellInfoWithId:cell1_2 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 54.f;
        } number:CellInfo_number_1],
                                   blank,
                                   [CellInfo cellInfoWithId:cell3 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 162.f;
        } number:^NSInteger(NSInteger section) {
            return x.shopCarts.count;
        } model:^id _Nullable(NSIndexPath * _Nonnull indexPath) {
            return x.shopCarts[indexPath.row];
        }],
                                   //blank,
                                   //备注
                                   
                                   [CellInfo cellInfoWithId:cell18 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 42;
        } number:CellInfo_number_1],
                                   blank,
                                   //优惠券
                                   [CellInfo cellInfoWithId:cell1_0 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return SectionHight;
        } number:couponNumber model:^id _Nullable(NSIndexPath * _Nonnull indexPath) {
            return @"使用优惠券";
        }],
                                   [CellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            SSELF;
            return self.shopCategory?120.f:0;
        } number:couponNumber model:^id _Nullable(NSIndexPath * _Nonnull indexPath) {
            SSELF;
            return self.shopCategory;
        }],
                                   [CellInfo cellInfoWithId:cell5 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 40.f;
        } number:couponNumber],
                                   blank,
                                   //价格计算
                                   [CellInfo cellInfoWithId:cell6 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 120.f;
        } number:CellInfo_number_1 model:modelBlock],
                                   [CellInfo cellInfoWithId:cell7 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 33.f;
        } number:CellInfo_number_1 model:modelBlock],
                                   blank,
                                   [CellInfo cellInfoWithId:cell8 height:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 33.f;
        } number:CellInfo_number_1],
                                   ]];
    }];
    
    
}


- (RACSignal *)onConfirmOrderSignal
{
    if (!self.address.userAddressId) {
        return [RACSignal errorString:@"请选择地址"];
    }
    
    NSDictionary *param;
    NSString *path;
    
    if (self.isPresell) {// 预售
        param = @{
                  kToken:[YCUserDefault currentToken],
                  @"userCouponId":@(self.shopCategory.userCouponId.intValue),
                  @"userAddressId":@(self.address.userAddressId.intValue),
                  @"payActionType":@(self.payType+1),
                  @"productId":self.productId,
                  @"qty":self.qty,
                  @"productSpecId":self.productSpecId,
                  @"productId":self.productSpecId,
                  };
        path = @"order/confirmOrderPresell.json";
        
    }
    
    else{
        
        if (self.orderType == YCOrderTypeCommodity) {
            
            param = @{
                      kToken:[YCUserDefault currentToken],
                      @"userCouponId":@(self.shopCategory.userCouponId.intValue),
                      @"cartIdArrayJson":self.cartIdArrayJson,
                      @"userAddressId":self.address.userAddressId,
                      @"payActionType":@(self.payType+1),
                      @"description":self.descriptions,
                      };
            
            path = @"order/confirmOrder.json";
        }
        
        ///团拼
        else if (self.orderType == YCOrderTypeGroup) {
            param = @{
                      kToken:[YCUserDefault currentToken],
                      @"groupBuyId":self.Id,
                      @"payType":@(self.payType+1),
                      };
            path = @"groupBuy/confirmGroupBuyOrder.json";
        }
    }
    
    return [self payPath:path parameters:param];
    
}



@end
