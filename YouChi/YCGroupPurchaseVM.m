//
//  YCGroupPurchaseVM.m
//  YouChi
//
//  Created by 李李善 on 16/5/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupPurchaseVM.h"

@implementation YCGroupPurchaseVM


-(void)setAddressM:(YCRecipientAddressM *)AddressM{
    if (_AddressM != AddressM) {
        NSString *userName = AddressM.receiverName?:@"";
        NSString *userPhone = AddressM.receiverPhone?:@"";
        NSString *userprovince= AddressM.provinceName?:@"";
        NSString *usercity = AddressM.cityName?:@"";
        NSString *usertown = AddressM.townName?:@"";
        NSString *userAddress = AddressM.receiverAddress?:@"";
        
        NSString *detalAddress = [NSString stringWithFormat:@"收货地址：%@%@%@%@",userprovince,usercity,usertown,userAddress];
        AddressM.completeAddress=detalAddress;
        AddressM.completeName = [NSString stringWithFormat:@"收货人：%@",userName];
        AddressM.phoneNumber = userPhone;
        _AddressM = AddressM ;
    }
}


@end
