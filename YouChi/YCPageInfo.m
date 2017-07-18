//
//  YCPageInfo.m
//  YouChi
//
//  Created by ZhiMin Deng on 15/6/15.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPageInfo.h"

@implementation YCPageInfo
-(void)dealloc{
    //    ok
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageNo = 1;
        _pageSize = 10;
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    ;
}
@end
