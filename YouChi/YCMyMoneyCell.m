
//
//  YCMyMoneyCell.m
//  YouChi
//
//  Created by 李李善 on 16/1/11.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyMoneyCell.h"
#import "YCMyMoneyM.h"
#import "YCCatolog.h"
@implementation YCMyMoneyCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)update:(YCMyMoneyM *)model atIndexPath:(NSIndexPath *)indexPath
{
    self.lAction.text = [self actionType:model.actionType];
    self.lMoney.text = model.money;
    self.lTime.text = model.createdDate;
    self.lInfo.text = model.actionDetails;
}

-(NSString *)actionType:(NSNumber *)type
{
    switch ([type intValue]) {
        case 1:
        {
            return @"充值";
        }
            break;
        case 2:
        {
            return @"消费";
        }
            break;
        default:{
            return @"退款";
        }
            break;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
