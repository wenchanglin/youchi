//
//  YCPersonalProfileM.m
//  YouChi
//
//  Created by sam on 15/5/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPersonalProfileM.h"

@implementation YCPersonalProfileM
- (void)dealloc{
//   ok 
}
+ (YCPersonalProfileM *)create:(NSString *)title :(NSString *)image :(Class)pushClass
{
    YCPersonalProfileM *m = [YCPersonalProfileM new];
    m.title = title;
    m.image = image;
    m.pushClass = pushClass;
    return m;
}
@end
