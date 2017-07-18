//
//  YCLoginM.m
//  YouChi
//
//  Created by 李李善 on 15/5/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLoginM.h"
#import "YCPassValueHelper.h"
#import "YCChihuoyingM.h"
@implementation YCLoginUserM
-(void)dealloc{
    //    ok
    
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self modelInitWithCoder:aDecoder];
}

- (BOOL )modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *birthDay = dic[@"birthDay"];
    if ([birthDay isKindOfClass:[NSNumber class]]) {
        _birthDay = [[YCDateFormatter shareDateFormatter] dateFromNumber:birthDay];
    }
    
    return YES;
}

- (NSString *)signature
{
    if (!_signature) {
        return @"该用户还没有签名";
    }
    return _signature;
}


@end







@implementation YCLoginM
- (void)dealloc{
    //    OK
}

@end
