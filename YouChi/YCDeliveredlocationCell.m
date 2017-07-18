//
//  YCDeliveredlocationCell.m
//  YouChi
//
//  Created by 李李善 on 15/12/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
// 

#import "YCDeliveredlocationCell.h"
#import "YCCatolog.h"
#import "YCMyOrderM.h"
@implementation YCDeliveredlocationCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)update:(YCMyOrderM *)model atIndexPath:(NSIndexPath *)indexPath
{
    _lReceiverAddress.text = [NSString stringWithFormat:@"收货地址: %@ ",model.receiverAddress];
    _lReceiverName.text = model.receiverName;
    _lReceiverPhone.text = model.receiverPhone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
