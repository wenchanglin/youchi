//
//  YCCancelOrderCell.m
//  YouChi
//
//  Created by 朱国林 on 16/2/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCancelOrderCell.h"

@implementation YCCancelOrderCell

- (void)awakeFromNib {
    // Initialization code
    self.lReason.placeholder = @"请描述清楚您要取消订单的原因";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
