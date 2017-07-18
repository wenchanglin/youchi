//
//  YCRecipientAddressVM.h
//  YouChi
//
//  Created by 朱国林 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCRecipientAddressM.h"
#import "YCLocationManager.h"


//typedef void(^onSelcetPickerView)(NSInteger row);
//typedef void(^onLocation)(NSInteger row,NSNumber *iD);
@interface YCRecipientAddressVM : YCPageViewModel
PROPERTY_STRONG RACSubject *addressChangedSignal;
PROPERTY_STRONG RACSubject *addressDeletedSignal;

//- (RACSignal *)shareInView:(UIViewController *)vc title:(NSString *)msg text:(NSString *)text image:(UIImage *)img url:(NSString *)url shareId:(NSNumber *)shareId  type:(YCShareType )type;

/**
 *  provinceId:省份ID
 *  cityId:城市ID
 *  townId:县级ID
 *  receiverAddress:详细地址
 *  receiverPhone:电话
 *  receiverName:姓名
 *  receiverZip:邮政编码
 */
//-(RACSignal*)addAddress;


//-(RACSignal*)updateAddress;
//WithProvinceId:(NSNumber *)provinceId cityId:(NSNumber *)cityId townId:(NSNumber *)townId receiverAddress:(NSString *)receiverAddress receiverPhone:(NSString*)receiverPhone receiverName:(NSString *)receiverName receiverZip:(NSString *)receiverZip;


@end
