//
//  YCJoinGroupNumCell.m
//  YouChi
//
//  Created by ant on 16/5/26.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCJoinGroupNumCell.h"
#import "YCMyOrderM.h"
@implementation YCJoinGroupNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.joinGroupNumVoew yc_initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)update:(YCMyOrderM *)model atIndexPath:(NSIndexPath *)indexPath
{
    YCShopOrderGroupBuySubs *m = model.shopGroupBuySubs[indexPath.row];
    
    if (m.isMe.boolValue && !m.isPay.boolValue) { // 自己未付款
        
        m.isPay = @(YCGroupPayStateSelfNotPay);
    }
    
    if (m.isMe.boolValue && (model.orderStatus.intValue == 2 || model.orderStatus.intValue == 4)) {
        
        m.isPay = @(YCGroupPayStateCancel);
    }
    

    [self.joinGroupNumVoew onUpdataUserImg:m.appUser.imagePath userName:m.appUser.nickName price:m.price.floatValue spe:m.shopSpec.specName count:m.qty.intValue groupPayState:m.isPay.intValue];
    
}

@end
