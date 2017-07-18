//
//  YCCommentM.m
//  YouChi
//
//  Created by 李李善 on 15/6/11.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCUserCommentM.h"

@implementation YCUserCommentM

- (void)dealloc
{
//   OK
}

@end


@implementation YCTargetBodyM
//@dynamic desc;
-(void)dealloc{
    //    ok
    
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"Id" : @"id",
             @"desc" : @"desc",
             };
}
@end