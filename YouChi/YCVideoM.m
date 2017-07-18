//
//  YCVideoM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCVideoM.h"

//@dynamic Id;

@implementation YCVideoM
-(void)dealloc{
    //    ok
    
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"descText" : @"description",
             @"Id" : @"id"
            };
}



@end
