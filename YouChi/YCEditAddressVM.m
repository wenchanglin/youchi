//
//  YCEditAddressVM.m
//  YouChi
//
//  Created by sam on 16/7/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCEditAddressVM.h"

@implementation YCEditAddressVM
SYNTHESIZE_M;
GETTER_LAZY_SUBJECT(addressDidUpdateSignal);

- (instancetype)initWithModel:(YCRecipientAddressM *)aModel
{
    _isEdit = (aModel != nil);
    return [super initWithModel:aModel];
}

-(NSString *)title
{
    if (self.isEdit) {
        return @"编辑地址";
    }else {
        return @"添加新地址";
    }
}


///获取省份列表
-(RACSignal *)getProvinceList
{
    return [[ENGINE POST_shop_array:@"address/getProvinceList.json" parameters:nil parseClass:[YCRecipientAddressM class] pageInfo:nil] doNext:^(NSArray *x) {
        _provinceS = x;
        
    }];
}



///获取城市列表
-(RACSignal *)getCityListWithFrmoProvince:(NSNumber *)provinceId
{
    return [[ENGINE POST_shop_array:@"address/getCityListByProvinceId.json" parameters:@{@"provinceId":@(provinceId.intValue)} parseClass:[YCRecipientAddressM class] pageInfo:nil] doNext:^(NSArray *x) {
        _cityS =x;
        
    }];
}


///获取区列表
-(RACSignal *)getTownListWithFrmoCity:(NSNumber *)cityId
{
    return [[ENGINE POST_shop_array:@"address/getTownListByCityId.json" parameters:@{@"cityId":@(cityId.intValue)} parseClass:[YCRecipientAddressM class] pageInfo:nil] doNext:^(NSArray *x) {
        _townS =x;
        
    }];
}

-(RACSignal *)addAddressSignal
{
    WSELF;
    NSDictionary *param = @{
                            
                            kToken:[YCUserDefault currentToken],
                            @"provinceId":self.provinceModel.provinceId,
                            @"cityId":self.cityModel.cityId,
                            @"townId":self.districtModel.townId,
                            @"receiverAddress":[self.detailAddress stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"receiverPhone":[self.phoneNumber stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"receiverName":[self.consigneeName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"receiverZip":[self.postcode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            } ;
    
    
    return [[ENGINE POST_shop_object:@"address/addUserAddress.json" parameters:param parseClass:[YCRecipientAddressM class] parseKey:kContent]
            flattenMap:^RACStream *(YCRecipientAddressM *m) {
                SSELF;
                return [[self setDefaultAddress:m.userAddressId]mapReplace:m];
            }];
}

-(RACSignal*)updateAddressSignal
{
    YCRecipientAddressM *m = self.model;
    CHECK_SIGNAL(!m, @"无数据，出错");
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken],
                            @"provinceId":m.provinceId,
                            @"cityId":m.cityId,
                            @"townId":m.townId,
                            @"receiverAddress":[m.receiverAddress stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"receiverPhone":[m.receiverPhone stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"receiverName":[m.receiverName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"receiverZip":[m.receiverZip stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"addressId":m.userAddressId,
                            } ;
    
    return [[ENGINE POST_shop_object:@"address/updateUserAddress.json" parameters:param parseClass:[YCRecipientAddressM class] parseKey:kContent]
            flattenMap:^RACStream *(YCRecipientAddressM *m) {
                return [[self setDefaultAddress:m.userAddressId]mapReplace:m];
            }];
    
    
}


@end
