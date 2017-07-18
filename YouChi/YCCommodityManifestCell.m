//
//  YCCommodityManifestCell.m
//  YouChi
//
//  Created by 李李善 on 15/12/26.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommodityManifestCell.h"
#import "YCMyOrderM.h"
@implementation YCCommodityManifestCell

- (void)awakeFromNib {
 
    _commodityView.backgroundColor = KBGCColor(@"#f4f4f4");
}


- (void)update:(YCMyOrderM *)model atIndexPath:(NSIndexPath *)indexPath
{
    
    YCShopOrderProductM *m = model.shopOrderProducts[indexPath.row];
    NSString *price;
    if (!m.isMoneyPay.boolValue) {
        YCShopSpecM *shopSpecModel =m.shopSpec;
        _commodityView.Y.font  = KFontBold(14);
        _commodityView.Y.text = @"友米";
        price =[NSString stringWithFormat:@"%.2f",shopSpecModel.antPrice.floatValue];
        
    }else{
        _commodityView.Y.font  = KFontBold(16);
        _commodityView.Y.text = @"￥";
        price = [NSString stringWithFormat:@"%.2f",m.shopSpec.specMoneyPrice.floatValue];
    }
    
    
    [_commodityView onUpdataCommodityName:m.shopProduct.productName Much:m.qty.intValue Price:price Weight:m.shopSpec.specName Image:m.shopProduct.imagePath];
    
    /*
    //`order_status` int(1) NOT NULL DEFAULT '0' COMMENT '订单状态。0，未审核；1，已审核；2，已取消(订单未付款直接取消)；3，无效＝商家行为；4=未付款已过期;5=已完成;6=已退款;7=取消审核中(订单已付款,取消的时候需要审核),8=部分付款/部分结算/待发货(团拼订单),9=全部结算(团拼订单,弃用)',
    
     // 预售商品时 加入购物车隐藏
    if (model.isPresell.boolValue) {
        self.orderStatueView.bAddToCart.hidden = YES;
    }
    
    //订单完成
    if (model.orderStatus.intValue == 5){
        
        //self.orderStatueView.YCOrderButton = YCOrderButtonFinish;  // 已收货  加入购物车  晒单评价   申请退货
        //已申请退货／退款
        if (m.isRefund.boolValue) {
            self.orderStatueView.bApplyRefund.hidden = YES;
            self.orderStatueView.bViewTheReturn.hidden = NO;
            //self.orderStatueView.YCOrderButton = YCOrderButtonIsReFund; // 退货状态    查看退货 加入购物车
            
//            if (model.isPresell.boolValue) { // 预售商品时 加入购物车隐藏
//                self.orderStatueView.YCOrderButton = YCOrderButtonIsPresellIsReFund;
//            }
        } else {
            self.orderStatueView.bApplyRefund.hidden = NO;
            self.orderStatueView.bViewTheReturn.hidden = YES;
        }
        
//        else if (model.isPresell.boolValue) { // 预售商品时  加入购物车隐藏
//            //self.orderStatueView.YCOrderButton = YCOrderButtonIsPresell;
//        }
    }
    else {
        
        self.orderStatueView.YCOrderButton = YCOrderButtonAddToCart; // 其他状态   加入购物车
        
        if (model.isPresell.boolValue) { // 预售商品时 加入购物车隐藏
            self.orderStatueView.YCOrderButton = YCOrderButtonNone;
        }
    }
    */
    
    if (model.orderStatus.intValue == 5){
        
        self.orderStatueView.YCOrderButton = YCOrderButtonFinish;  // 已收货  加入购物车  晒单评价   申请退货
        
        if (model.isPresell.intValue ==1) { // 预售商品时  加入购物车隐藏
            self.orderStatueView.YCOrderButton = YCOrderButtonIsPresell;
        }
    }
    else {
        
        self.orderStatueView.YCOrderButton = YCOrderButtonAddToCart; // 其他状态   加入购物车
        
        if (model.isPresell.intValue ==1) { // 预售商品时 加入购物车隐藏
            self.orderStatueView.YCOrderButton = YCOrderButtonNone;
        }
    }
    
    if (m.isRefund.intValue && model.orderStatus.intValue == 5) {
        
        self.orderStatueView.YCOrderButton = YCOrderButtonIsReFund; // 退货状态    查看退货 加入购物车
        
        if (model.isPresell.intValue == 1) { // 预售商品时 加入购物车隐藏
            self.orderStatueView.YCOrderButton = YCOrderButtonIsPresellIsReFund;
        }
        return;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
