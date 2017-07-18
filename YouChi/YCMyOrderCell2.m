//
//  YCMyOrderCell2.m
//  YouChi
//
//  Created by 朱国林 on 15/12/26.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import "YCMyOrderCell2.h"
#import "YCAboutGoodsM.h"
@implementation YCMyOrderCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



-(void)update:(YCMyOrderM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *totalPrice;
    NSString *isMoneyPay;
    
    if (model.isMoneyPay.boolValue) {
        
        totalPrice= [NSString stringWithFormat:@"%.2f",model.realPayMoney.floatValue] ;
        isMoneyPay = @"实付金额:";
    }
    else{
        
        self.vOrderPayView.lSymbol.hidden = YES;
        YCAboutGoodsM *m = model.shopOrderProducts.firstObject;
        totalPrice = [NSString stringWithFormat:@"%.2f",m.shopSpec.antPrice.floatValue];
        isMoneyPay = @"实付友米:";
    }
    
#pragma mark --支付状态
    if (model.payStatus.intValue == 0) { // 未付款，未发货   =>取消订单 马上支付
        
        self.vOrderPayView.YCGoodsState = YCGoodsStateNotSend;
        
    }else {
        
#pragma mark --发货状态
        if (model.shippingStatus.intValue == 0) {      // 未发货,已付款 =>申请退款
            
            self.vOrderPayView.YCGoodsState = YCGoodsStateNotSendAndHadPay;
            
            if (model.isPresell.boolValue) {      // 预售时  =>申请退款隐藏
                self.vOrderPayView.YCGoodsState = YCGoodsStateNon;
            }
            
        }else if (model.shippingStatus.boolValue){ // 已发货  =>确认收货
            
            self.vOrderPayView.YCGoodsState = YCGoodsStateHadSend;
            
        }else{                                         // 其他状态 =>全部隐藏
            
            self.vOrderPayView.YCGoodsState = YCGoodsStateNon;
        }
    }
    
#pragma mark - buchong
    
    
#pragma mark --订单状态
    if (model.orderStatus.intValue >= 2 && model.orderStatus.intValue!=8) {// 未审核跟已审核的不隐藏按钮  其他全部隐藏(已过期，已完成，失效等)
        
        self.vOrderPayView.YCGoodsState = YCGoodsStateNon;
        
        if (model.orderStatus.intValue == 2||model.orderStatus.intValue == 5) { // 可删除
            
            self.vOrderPayView.YCGoodsState = YCGoodsStateDelete;
        }
    }
    
    self.vOrderPayView.lPayText.text =isMoneyPay;
    self.vOrderPayView.lPaySumOrder.text = totalPrice;
    
}



@end
