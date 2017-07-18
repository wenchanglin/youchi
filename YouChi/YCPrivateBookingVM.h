//
//  YCPrivateBookingVM.h
//  YouChi
//
//  Created by sam on 15/5/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCPrivateBookingM.h"
#import "YCLocationManager.h"
#import "YCChihuoyingVM.h"

@interface YCPrivateBookingVM : YCChihuoyingVM
@property (nonatomic,assign) BOOL shouldUpdateState;
@property (nonatomic,strong) NSString *stateIds;
@property (nonatomic,strong) NSString *city;

@property (nonatomic,strong) YCLoginUserM *user;

- (RACSignal *)getPersonalHeaderSignal;
@end
