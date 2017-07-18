//
//  YCMessageM.m
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMessageM.h"

@implementation YCMessageM
-(void)dealloc{
    //    ok
    
}
+ (YCMessageM *)creatImg:(NSString *)img content:(NSString *)content pushClass:(Class )pushClass{
    YCMessageM *m = [[self alloc]init];
    m.img = img;
    m.content = content;
    m.pushClass = pushClass;
    return m;    
}
@end
