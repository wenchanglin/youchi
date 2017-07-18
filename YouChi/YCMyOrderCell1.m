//
//  YCMyOrderCell1.m
//  YouChi
//
//  Created by 朱国林 on 15/12/26.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCView.h"
#import "YCMyOrderCell1.h"
#import "YCAboutGoodsM.h"

@implementation YCMyOrderCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)update:(YCMyOrderM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    self.vOrderNumView.YCOrderState = model.orderStatus.intValue;
    
    
    self.vOrderNumView.lOrderNumber.text = model.orderNo;

}




@end
