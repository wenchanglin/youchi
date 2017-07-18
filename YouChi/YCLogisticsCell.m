//
//  YCLogisticsCell.m
//  YouChi
//
//  Created by 李李善 on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLogisticsCell.h"
#import "YCCatolog.h"
#import "YCMyOrderM.h"
@implementation YCLogisticsCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)update:(YCShopWuliuInfoM *)model atIndexPath:(NSIndexPath *)indexPath 
{
    if (!model) {
        
    }
    self.lPackege.text = [NSString stringWithFormat:@"包裹%zd物流情况",indexPath.row + 1];
    self.lLogisticsNumber.text = [NSString stringWithFormat:@"%@",model.shippingNo?model.shippingNo:@"0000"];

    
    [model.wuliuJson enumerateObjectsUsingBlock:^(YCKuaidi *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==0) {
            self.lNumber.text = obj.context;
        }
        else if (idx==1)
        {
           self.lNumber2.text = obj.context;
        }
        else if (idx==2){
             self.lNumber3.text = obj.context;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
