//
//  YCPriceCell.m
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPriceCell.h"
#import "YCCatolog.h"
#import "YCAboutGoodsM.h"
#import "YCMyOrderM.h"
@implementation YCPriceCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)update:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    if (model.isOrderDetail==YES) { // 我的订单里的订单详情
        YCMyOrderM *m = (id)model;
        
        self.price.text =[NSString stringWithFormat:@"%.2f",[m.orderMoneyTotal floatValue] ]; ///商品总额¥
        self.postage.text = [NSString stringWithFormat:@"%.2f",[m.postMoney floatValue] ];///运费¥
        self.coupon.text =[NSString stringWithFormat:@"%.2f",[m.favorableMoney floatValue] ];///优惠劵¥
        self.money.text =[NSString stringWithFormat:@"%.2f",[m.balanceMoney floatValue] ]; ///使用账号余额¥
        self.lHowPostage.text = [NSString stringWithFormat:@"运费（满%d包邮）",m.howManyFullShipping.intValue];//满多少包邮
        
        if (m.isTeamOrder.intValue) {
            self.postage.text = @"0.00";/// 团拼包邮
            self.lHowPostage.text = @"运费（团拼包邮）";//满多少包邮
            self.lCoupon.text = @"团拼优惠";
            self.coupon.text = [NSString stringWithFormat:@"%.2f",[m.groupCoupon floatValue]];///优惠¥
        }
        
    }else{  // 确认订单
    
        self.price.text = [NSString stringWithFormat:@"%.2f",[model.productTotalPrice floatValue] ];///商品总额¥
        self.postage.text = [NSString stringWithFormat:@"%.2f",[model.freightPrice floatValue]];///运费¥
        self.coupon.text = [NSString stringWithFormat:@"%.2f",[model.preferentialTotal floatValue]];///优惠劵¥
        self.money.text = [NSString stringWithFormat:@"%.2f",[model.accountPayTotal floatValue]];///使用账号余额¥
        self.lHowPostage.text = [NSString stringWithFormat:@"运费（满%d）包邮",model.howManyFullShipping.intValue];// 满多少包邮
        
        if (model.shopProduct.isTeamProduct.integerValue) {
            self.postage.text = @"0.00";/// 团拼包邮
            self.lHowPostage.text = @"运费（团拼包邮）";//满多少包邮
            self.lCoupon.text = @"团拼优惠";
            self.coupon.text = [NSString stringWithFormat:@"%.2f",[model.groupCoupon floatValue]];///优惠¥
        }
        
    }
    
    
}

/**
 *  freightPrice  邮费
 *  productTotalPrice  优惠价
    accountPayTotal  用户账户余额
    actualityPayTotal  实付总价
 *
 */



@end
