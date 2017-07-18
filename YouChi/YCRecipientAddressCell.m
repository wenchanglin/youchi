//
//  YCRecipientAddressCell.m
//  YouChi
//
//  Created by 朱国林 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRecipientAddressCell.h"
#import "YCRecipientAddressM.h"
#import "YCAboutGoodsM.h"
@implementation YCRecipientAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

// 确认订单，订单详情，地址列表用到这个cell 分几个判断
- (void)update:(YCRecipientAddressM *)model atIndexPath:(NSIndexPath *)indexPath{
    
    _imgChoose.hidden = !model.isDefault.boolValue;
    
    if (_isArrow ) {
        _imgChoose.hidden = NO;
        _imgChoose.image = [UIImage imageNamed:@"箭头"];
        _ChooseWidth.constant = 10;
        _ChooseHeight.constant = 15;
    }
    NSString *userName = model.receiverName?:@"";
    NSString *userPhone = model.receiverPhone?:@"";
    NSString *userprovince= model.provinceName?:@"";
    NSString *usercity = model.cityName?:@"";
    NSString *usertown = model.townName?:@"";
    NSString *userAddress = model.receiverAddress?:@"";

    NSString *detalAddress = [NSString stringWithFormat:@"收货地址：%@%@%@%@",userprovince,usercity,usertown,userAddress]; // 地址列表专用
    
    if (model.city == nil &&model.townName == nil) {  // 确认订单，订单详情的地址专用
        
        detalAddress = [NSString stringWithFormat:@"收货地址：%@  %@",model.address,model.receiverZip];
    }
    
    
    
    
    // 确认订单 若没有地址信息，显示添加地址
    if (_isHiddenMsg && model.city == nil &&model.townName == nil&&model.receiverName == nil) {
        
        _lRecipientName.hidden = _lRecipientNum.hidden = _lRecipientAddress.hidden = _imgChoose.hidden = _imgMap.hidden =YES;
        self.nonView.hidden = NO;
    }
    
    _lRecipientName.text = [NSString stringWithFormat:@"收货人：%@",userName];
    _lRecipientNum.text = userPhone;
    _lRecipientAddress.text = detalAddress;
    

}



//- (void)updateWith:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath{
//
//    
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
