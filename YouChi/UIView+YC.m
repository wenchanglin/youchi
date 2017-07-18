//
//  UIView+YC.m
//  YouChi
//
//  Created by water on 16/6/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "UIView+YC.h"
#import <objc/runtime.h>
#import "YCViewInfo.h"

static char const kViewInfo;

@implementation UIView (YC)

@dynamic viewInfo;


-(void)setViewInfo:(YCViewInfo *)viewInfo{
    objc_setAssociatedObject(self, &kViewInfo, viewInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(YCViewInfo *)viewInfo{
    return objc_getAssociatedObject(self, &kViewInfo);
}


@end
