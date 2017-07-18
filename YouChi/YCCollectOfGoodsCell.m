//
//  YCCollectOfGoodsCell.m
//  YouChi
//
//  Created by 朱国林 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfGoodsCell.h"
#import "YCView.h"
#import "YCAboutGoodsM.h"
@implementation YCCollectOfGoodsCell

- (void)awakeFromNib {
    // Initialization co
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

}

-(void)update:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath{

    
    [_imgGoogs ycShop_setImageWithURL:model.shopProduct.imagePath placeholder:PLACE_HOLDER];
    
    _lDesc.text = model.shopProduct.brief;
    _lGoodsName.text = model.shopProduct.productName;
    _lGoodsPrice.text = [NSString stringWithFormat:@"%.2f",model.shopProduct.shopPrice.floatValue]; // model.shopProduct.marketPrice.floatValue
    _lOldGoodsPrice.text = [NSString stringWithFormat:@"%.2f",model.shopProduct.marketPrice.floatValue];
    
    if (model.shopProduct.showQty.intValue == 0) {
        _lShippingTag.text = @"缺货";
        _lShippingTag.hidden = NO;
    }
    
    if (model.shopProduct.isQtyExist.intValue == 1) {
        
        _lShippingTag.text = @"已下架";
        _lShippingTag.hidden = NO;
    }
}


@end
