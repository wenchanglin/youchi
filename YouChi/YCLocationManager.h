//
//  YCLocationManager.h
//  YouChi
//
//  Created by sam on 15/6/16.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <YYKit/YYKit.h>

@interface YCLocationInfo : NSObject<NSCoding>
///省份
@property (nonatomic, strong) NSString *lastProvince;
///城市
@property (nonatomic, strong) NSString *lastCity;
///区
@property (nonatomic, strong) NSString *lastDistrict;

@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, strong) CLLocation *lastLocation;
@end

typedef void(^YCLocationBlock)(NSError *error,YCLocationInfo *locationInfo);

@interface YCLocationManager : NSObject
@property (nonatomic, strong,readonly) CLLocationManager *locationManager;
@property (nonatomic, strong,readonly) YCLocationInfo *locationInfo;

@property (nonatomic, strong,readonly) NSError *locationError;

+ (YCLocationManager *)sharedLocationManager;
- (void)startUpdatingLocation:(YCLocationBlock )block;
- (void)stopUpdatingLocation;
- (void)forceUpdatingLocation;
@end


