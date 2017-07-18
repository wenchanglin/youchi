//
//  YCLogisticsCell.m
//  YouChi
//
//  Created by 李李善 on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLogisticsDetailsCell.h"
#import "YCCatolog.h"
#import "YCMyOrderM.h"
@implementation YCLogisticsDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)update:(YCShopWuliuInfoM *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (model.kuaidiName == nil) {
        model.kuaidiName = @"快递";
    }
    self.lName.text = [NSString stringWithFormat:@"%@ 为你配送\n物流单号%@",model.kuaidiName,model.shippingNo];
    
    self.lLogisticsNumber.text = [NSString stringWithFormat:@"%@",model.shippingNo];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
