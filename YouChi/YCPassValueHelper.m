//
//  YCPassValueHelper.m
//  YouChi
//
//  Created by sam on 15/5/29.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPassValueHelper.h"

@implementation YCDateFormatter

+ (YCDateFormatter  *)shareDateFormatter
{
    static YCDateFormatter *_standardUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardUserDefaults = [[self alloc]init];
    });
    
    
    return _standardUserDefaults;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _formatter  = [NSDateFormatter new];
        _formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
        //self.timeZone = [NSTimeZone localTimeZone];
    }
    return self;
}



- (NSDate *)dateFromNumber:(NSNumber *)number
{
    NSTimeInterval timeSeconds = number.doubleValue/1000;
    NSDate *date;
    if( timeSeconds>0){
        date = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    }else{
        date = [NSDate date];
    }
    return date;
}


- (NSString *)stringFromNumber:(NSNumber *)number
{
    NSTimeInterval timeSeconds = number.doubleValue/1000;
    NSString *dateString;
    NSDate *date;
    if( timeSeconds>0){
        date = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    }else{
        date = [NSDate date];
    }

    dateString = [_formatter stringFromDate:date];
    return dateString;
}



@end