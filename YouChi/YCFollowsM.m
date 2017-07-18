    //
//  YCGuanZhuM.m
//  YouChi
//
//  Created by 李李善 on 15/6/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFollowsM.h"

@implementation YCFollowsM

- (void)dealloc{
    //ok
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"followUserList":[YCFollowUserListM class],
             @"fansUserList": [YCFansUserListM class],
             };
}

@end

#pragma mark ---------------------------------------------------------------------

#pragma mark --关注
@implementation YCFollowUserListM
-(void)dealloc{
    //    ok
    
}

@end



#pragma mark --粉丝
@implementation YCFansUserListM
-(void)dealloc{
    //    ok
    
}

@end

