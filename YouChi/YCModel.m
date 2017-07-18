//
//  YCModel.m
//  YouChi
//
//  Created by sam on 15/5/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import "YCPassValueHelper.h"
@implementation YCBaseModel
@synthesize shortCreateDate;
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"Id" : @"id",
             @"desc" : @"description",
             };
}

- (BOOL )modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *timestamp = dic[@"createdDate"];
    if ([timestamp isKindOfClass:[NSNumber class]]) {
        _createdDate = [[YCDateFormatter shareDateFormatter] stringFromNumber:timestamp];
    }
    
    if (!self.desc) {
        _desc = dic[@"desc"];
    }
    
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self modelInitWithCoder:coder];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self modelEncodeWithCoder:coder];
}

- (NSString *)shortCreateDate
{
    if (!shortCreateDate) {
        shortCreateDate = [[YCDateFormatter shareDateFormatter] stringFromNumber:(id)self.createdDate];
    }
    return shortCreateDate;
}
@end


@implementation YCBaseImageModel



@end

@implementation YCBaseUserImageModel



@end