//
//  YCCenterButton.m
//  YouChi
//
//  Created by sam on 16/1/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCenterButton.h"
#define kYCCenterButtonTitleSpace 30
@implementation YCCenterButton

-(void)layoutSubviews {
    [super layoutSubviews];
}

- (CGRect)imageRectForContentRect:(CGRect)bounds
{
    CGFloat w = CGRectGetWidth(bounds);
    return CGRectMake(0, 0, w, w);
}

- (CGRect)titleRectForContentRect:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(CGRectGetWidth(bounds), 0, 0, 0));
}
@end


@implementation YCCenterFitButton

-(void)layoutSubviews {
    [super layoutSubviews];
}

- (CGRect)imageRectForContentRect:(CGRect)bounds
{
    CGFloat w = CGRectGetWidth(bounds);
    return CGRectMake(0, 0, w, w);
}

- (CGRect)titleRectForContentRect:(CGRect)bounds
{
    CGFloat w = CGRectGetWidth(bounds);
    CGFloat h = CGRectGetHeight(bounds);
    CGFloat fontHeight = 16;
    return CGRectMake(0, h-fontHeight, w, fontHeight);
}
@end