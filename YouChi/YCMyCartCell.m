//
//  YCMyCartCell.m
//  YouChi
//
//  Created by 朱国林 on 15/12/28.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCAboutGoodsM.h"
#import "YCMyCartCell.h"
#import <Masonry/Masonry.h>
@implementation YCMyCartCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)update:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    _model = model;
    [_vCommodity onUpdataCommodityName:model.productName Much:model.qty.intValue Price:[NSString stringWithFormat:@"%.2f",[model.shopSpec.specMoneyPrice floatValue]] Weight:model.shopSpec.specName Image:model.shopProduct.imagePath];
    
    
    //价值
    float f = model.shopSpec.specMoneyPrice.floatValue;
    //
    int count = model.qty.intValue;
    float total = f *count;
    self.eachGoodsPirce = total;
    _vTotalPrice.much.text = [NSString stringWithFormat:@"%@",model.qty];
    _vTotalPrice.price.text = [NSString stringWithFormat:@"%.2f",self.eachGoodsPirce]; 
    _vGoodsName.btnSelect.selected = model.isSelected;
    
    _vGoodsName.commodityName.text = model.shopProduct.categoryName;
    _vGoodsName.commodityName.width = 100;
    
    
    
    
    
//    _vGoodsName.commodityName.hidden = YES;
}



@end
