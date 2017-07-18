//
//  YCYouMiExchangePayCell.m
//  YouChi
//
//  Created by 李李善 on 16/1/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouMiExchangePayCell.h"
#import "YCAboutGoodsM.h"
@implementation YCYouMiExchangePayCell



///这里的数据不是不是用“兑换商品请求”的数据，而是用"友米兑换"界面的数据
-(void)update:(YCShopSpecM *)model atIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat much =model.antPrice.floatValue;
///name:商品名字 much:商品数量 price:商品单价 weight:商品份量 image:商品图片
    [self.commodityView onUpdataCommodityName:model.productName Much:1 Price:[NSString stringWithFormat:@"%.1f",much] Weight:model.specName Image:model.productImagePath];
    self.lMuch.text = [NSString stringWithFormat:@"小计:%.1f",[model.specMoneyPrice floatValue]];
    self.commodityView.ant.hidden = NO;

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
