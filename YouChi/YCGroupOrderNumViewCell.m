//
//  YCGroupOrderNumViewCell.m
//  YouChi
//
//  Created by ant on 16/5/27.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupOrderNumViewCell.h"
#import "YCMyOrderM.h"
@implementation YCGroupOrderNumViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)update:(YCMyOrderM *)model atIndexPath:(NSIndexPath *)indexPath{

    if (model.orderStatus.intValue == 9) { // 已经全部付款
     
        self.groupOrderNumView.groupOrderState = YCGroupOrderStateAllHadPay;
    }
    
    if (model.shippingStatus.intValue == 1) {   //  已发货
        
        self.groupOrderNumView.groupOrderState = YCGroupOrderStateHadSend;

    }
    
    [self.groupOrderNumView onUpdataRemainingNum:model.noPayCount.intValue];
}
@end
