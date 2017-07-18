//
//  YCTicklingVM.m
//  YouChi
//
//  Created by 朱国林 on 15/7/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTicklingVM.h"

@implementation YCTicklingVM

- (void)dealloc
{
    //   ok
}
- (RACSignal *)sendSignal:(NSString *)title advice:(NSString *)advice
{
    return [ENGINE POSTBool:apiGGFeedback parameters:@{
                                                       kToken:[YCUserDefault currentToken],
                                                       @"title":title,
                                                       @"description":advice}];
}

@end
