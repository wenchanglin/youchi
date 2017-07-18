//
//  YCRecipientAddressM.h
//  YouChi
//
//  Created by 李李善 on 15/12/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"

@interface YCRecipientAddressM : YCBaseModel
/**
 consigneeName:名字
 phoneNumber:电话号码
 address:收货地址
 postcode 邮编号码
 detailAddress详细地址
 province 省份
 city  城市
 district 区
  详细地址
 */

@property(nonatomic,strong) NSString *consigneeName,*phoneNumber,*address,*postcode,*province,*city,*district,*detailAddress,*productName;

@property (nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSString *cityName,*provinceName,*receiverAddress,*receiverName,*receiverPhone,*receiverZip,*townName;
@property (nonatomic,strong)NSNumber *userAddressId,*provinceId,*cityId,*townId,*isDefault;


/**
 *  完整的详细地址（处理过）
 */
@property(nonatomic,strong) NSString *completeAddress;
/**
 *  完整的联系人（处理过）
 */
@property(nonatomic,strong) NSString *completeName;
@end
