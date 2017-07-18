//
//  YCEditAddressVM.h
//  YouChi
//
//  Created by sam on 16/7/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCRecipientAddressVM.h"
#import "YCViewModel+Logic.h"

@interface YCEditAddressVM : YCPageViewModel
///Model
PROPERTY_STRONG_M(YCRecipientAddressM);


/// consigneeName:名字
@property(nonatomic,strong) NSString *consigneeName;
///phoneNumber:电话号码
@property(nonatomic,strong) NSString *phoneNumber;
///postcode 邮编号码
@property(nonatomic,strong) NSString *postcode;
///province 省份
@property(nonatomic,strong) YCRecipientAddressM *provinceModel;
///city  城市
@property(nonatomic,strong) YCRecipientAddressM *cityModel;
///district 区
@property(nonatomic,strong) YCRecipientAddressM *districtModel;
///detailAddress 详细地址
@property(nonatomic,strong) NSString *detailAddress;


///省份数组
@property(nonatomic,strong,readonly) NSArray<YCRecipientAddressM *> *provinceS;
///城市数组
@property(nonatomic,strong,readonly) NSArray<YCRecipientAddressM *> *cityS;
///区数组
@property(nonatomic,strong,readonly) NSArray<YCRecipientAddressM *> *townS;

@property (nonatomic,assign,readonly) BOOL isEdit;

PROPERTY_STRONG RACSubject *addressDidUpdateSignal;

- (instancetype)initWithModel:(YCRecipientAddressM *)aModel NS_DESIGNATED_INITIALIZER;

-(RACSignal *)addAddressSignal;
-(RACSignal *)updateAddressSignal;

///获取省份列表
-(RACSignal *)getProvinceList;
///获取城市列表
-(RACSignal *)getCityListWithFrmoProvince:(NSNumber *)provinceId;
///获取区列表
-(RACSignal *)getTownListWithFrmoCity:(NSNumber *)cityId;
@end
