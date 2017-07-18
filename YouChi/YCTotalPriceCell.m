//
//  YCTotalPriceCell.m
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import "YCTotalPriceCell.h"
#import "YCCatolog.h"
#import "YCAboutGoodsM.h"
@implementation YCTotalPriceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    if (model.isOrderDetail) {
        YCMyOrderM *m = (id)model;
        self.price.text = [NSString stringWithFormat:@"%.2f",m.realPayMoney.floatValue];
    }else{// 确认订单
        self.price.text = [NSString stringWithFormat:@"%.2f",model.actualityPayTotal.floatValue];
    }
}

@end
