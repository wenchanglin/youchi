//
//  YCSheZhiM.m
//  YouChi
//
//  Created by 李李善 on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSheZhiM.h"

@implementation YCSheZhiM
- (void)dealloc
{
//    ok
}
+ (YCSheZhiM *)createPushClass:(Class)pushClass
{
    YCSheZhiM *m = [YCSheZhiM new];
    m.pushClass = pushClass;
    return m;
}
@end
//cornerRadius