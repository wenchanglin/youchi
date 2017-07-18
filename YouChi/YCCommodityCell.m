//
//  YCCommodityCell.m
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommodityCell.h"
#import "YCCatolog.h"
@implementation YCCommodityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    [super update:model atIndexPath:indexPath];
        
    self.vGoodsName.commodityName.hidden = YES;
}

@end
