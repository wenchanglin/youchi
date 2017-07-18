//
//  YCOrderDetailGroupAddCell.m
//  YouChi
//
//  Created by ant on 16/5/26.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCRecipientAddressM.h"
#import "YCOrderDetailGroupAddCell.h"
#import "YCMyOrderM.h"
@implementation YCOrderDetailGroupAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(YCMyOrderM *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFixOrder) {
        YCRecipientAddressM *m = (id)model;
        
        [self.addressView onUpdataName:m.receiverName phone:m.receiverPhone address:[NSString stringWithFormat:@"%@%@%@%@",m.provinceName,m.cityName,m.townName,model.receiverAddress?:@""]];
        self.addressView.imgArrow.hidden = NO;
    }else{
        
        [self.addressView onUpdataName:model.receiverName phone:model.receiverPhone address:model.receiverAddress];
    }
}

@end
