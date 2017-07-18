//
//  YCCancelOrderComdityCell.m
//  YouChi
//
//  Created by 朱国林 on 16/4/6.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCancelOrderComdityCell.h"

@implementation YCCancelOrderComdityCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)update:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath{
    

    
    [self.vCommodity onUpdataCommodityName:model.shopProduct.productName Much:model.qty.intValue Price:[NSString stringWithFormat:@"%.2f",model.shopProduct.shopPrice.floatValue] Weight:model.shopSpec.specName Image:model.shopProduct.imagePath];
    
    float f = model.shopProduct.shopPrice.floatValue;
    int count = model.qty.intValue;
    float total = f *count;
    
    self.vTotalPrice.price.text = [NSString stringWithFormat:@"%.2f",total];;
    
    self.vGoodsName.commodityName.hidden = YES;
}

@end
