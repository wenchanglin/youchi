//
//  YCLocationManager.m
//  YouChi
//
//  Created by sam on 15/6/16.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLocationManager.h"
#import "YCMarcros.h"

@implementation YCLocationInfo
- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self modelInitWithCoder:coder];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self modelEncodeWithCoder:coder];
}
@end

static NSString *YCLocationManagerLastInfo = @"YCLocationManagerLastInfo";
static NSString *YCLocationManagerLastDate = @"YCLocationManagerLastDate";
static NSString *YCLocationManagerLastCity = @"YCLocationManagerLastCity";

@interface YCLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) YCLocationInfo *locationInfo;

@property (nonatomic, strong) NSError *locationError;
@property (nonatomic, strong) YCLocationBlock locationBlock;
@end

@implementation YCLocationManager
+ (YCLocationManager *)sharedLocationManager{
    static YCLocationManager *_sharedManager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc]init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.locationManager = ({
            CLLocationManager *lm = [CLLocationManager new];
            lm.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            lm.distanceFilter = 10.0f;
            lm.delegate = self;
            lm;
        });
        
        self.locationInfo = ({
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSData *data = [ud objectForKey:YCLocationManagerLastInfo];
            YCLocationInfo *info = nil;
            if (data) {
                info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            } else {
                info = [YCLocationInfo new];
            }
            info;
        });
    }
    return self;
}


#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
   
    
    CLLocation *location = [locations lastObject];
    
    if (!self.locationInfo.lastLocation ) {
        self.locationInfo.lastLocation = location;
        self.locationInfo.lastDate = location.timestamp;
    }
    
    if (location.horizontalAccuracy <= 500) {
        self.locationInfo.lastLocation = location;
        self.locationInfo.lastDate = location.timestamp;
        
        __block BOOL isSucess = NO;
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                self.locationError = error;
            } else if (placemarks && placemarks.count>0) {
                for (CLPlacemark *placemark in placemarks) {
                    NSDictionary *address = [placemark addressDictionary];
                  
                    
                    NSString *province = address[@"State"];
                    if (province.length>0) {
                        isSucess = YES;
                        self.locationInfo.lastProvince = province;
                       
                        NSString *city = address[@"City"];
                        
                        if (city.length>0) {
                            isSucess = YES;
                            self.locationInfo.lastCity = city;
                            NSString *district = address[@"SubLocality"];
                            if (district.length>0) {
                                isSucess = YES;
                                self.locationInfo.lastDistrict = district;
                            } else {
                                self.locationError = error(@"获取市区失败");
                            }
                            
                        } else {
                            self.locationError = error(@"获取城市失败");
                        }
                    } else {
                        self.locationError = error(@"获取省份失败");
                    }
                    
                }
            }
            
           
            if (isSucess) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.locationInfo];
                [[NSUserDefaults standardUserDefaults]setObject:data forKey:YCLocationManagerLastInfo];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                self.locationBlock(nil,self.locationInfo);
            } else {

                self.locationBlock(self.locationError,nil);
            }
            

        }];
        
        
        
        
        
        [manager stopUpdatingLocation];
        
        
        
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch(status){
        //case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [manager stopUpdatingLocation];
            self.locationError = error(@"无法定位，请检查系统设置");
            self.locationBlock(self.locationError,nil);
            break;
        default:
            [manager startUpdatingLocation];
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.locationError = error;
    self.locationBlock(error,nil);
    [self.locationManager stopUpdatingLocation];
}

- (void)startUpdatingLocation:(YCLocationBlock )block {
    self.locationBlock = block;
    
    if ([self isLocationEnable]) {
        if (self.locationInfo.lastCity.length<=0 || [self.locationInfo.lastDate timeIntervalSinceNow] > 60*60*60) {
            [self.locationManager startUpdatingLocation];
        } else {
            self.locationBlock(nil,self.locationInfo);
        }
        
    } else {
        [self.locationManager startUpdatingLocation];
        
    }
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}

- (BOOL)isLocationEnable
{
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
        {
             if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.locationManager requestWhenInUseAuthorization];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
            }else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locationManager requestAlwaysAuthorization];//用这个方法，plist中需要NSLocationAlwaysUsageDescription
            }
            return NO;
        }
            break;
            
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            self.locationError = error(@"定位失败！");
            return NO;
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return YES;
        default:
            break;
    }
    return NO;
}

- (void)forceUpdatingLocation
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    [self.locationManager startUpdatingLocation];
    [self.locationManager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:30];
}
@end
