//
//  YCMyOrderCell.m
//  YouChi
//
//  Created by 朱国林 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import "YCMyOrderCell.h"
#import "YCAboutGoodsM.h"
#import "YCView.h"
@implementation YCMyOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}


-(void)update:(YCShopOrderProductM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    YCShopOrderProductM *m = model;
    NSString *price;
    if ([m.isMoneyPay intValue]==0) {
        _goodsAttribute.Y.font  = KFontBold(14);
        _goodsAttribute.Y.text = @"友米";
        price =[NSString stringWithFormat:@"%.2f",m.shopSpec.antPrice.floatValue];
        
    }else{
        _goodsAttribute.Y.font  = KFontBold(16);
        _goodsAttribute.Y.text = @"￥";
        price = [NSString stringWithFormat:@"%.2f",m.shopSpec.specMoneyPrice.floatValue];
    }
    
    [_goodsAttribute onUpdataCommodityName:model.shopProduct.productName Much:model.qty.intValue Price:[NSString stringWithFormat:@"%.2f",model.shopSpec.specMoneyPrice.floatValue] Weight:model.shopSpec.specName Image:model.shopProduct.imagePath];
        
}

@end
