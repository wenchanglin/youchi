//
//  YCPassValueHelper.h
//  YouChi
//
//  Created by sam on 15/5/29.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PASS (YCPassValueHelper *)[YCPassValueHelper shareHelper]


@interface YCDateFormatter : NSObject
+ (YCDateFormatter  *)shareDateFormatter;
@property (nonatomic,strong,readonly) NSDateFormatter *formatter;
- (NSDate *)dateFromNumber:(NSNumber *)number;
- (NSString *)stringFromNumber:(NSNumber *)number;

@end