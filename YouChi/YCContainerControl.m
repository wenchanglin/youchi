//
//  YCContainerControl.m
//  YouChi
//
//  Created by sam on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCContainerControl.h"
#include <stdio.h>

@interface YCContainerControl ()

@end
@implementation YCContainerControl

- (instancetype)initWithElementCount:(NSInteger)count block:(UIView *(^)(NSInteger))block
{
    self = [self init];
    [self _setElementCount:count block:block];
    return self;
}

- (void)_setElementCount:(NSInteger)count block:(UIView *(^)(NSInteger))block
{
    NSParameterAssert(block);
    [_elements makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *array = [NSMutableArray new];
    for (int n = 0; n < count; n++) {
        UIView *v = block(n);
        [self addSubview:v];
        [array addObject:v];
    }
    _elements = array.copy;
    [self setNeedsLayout];
}

- (void)setElementCount:(NSInteger)count block:(UIView *(^)(NSInteger))block
{
    [self _setElementCount:count block:block];
}

- (void)setElements:(NSArray<__kindof UIView *> *)elements
{
    [self _setElementCount:elements.count block:^UIView *(NSInteger idx) {
        return elements[idx];
    }];
}

- (void)setButtonImages:(NSArray<NSString *> *)images
{
    [self _setElementCount:images.count block:^UIView *(NSInteger idx) {
        UIButton *btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:images[idx]] forState:UIControlStateNormal];
        return btn;
    }];
}

- (void)setContainerControlType:(YCContainerControlType)containerControlType
{
    if (containerControlType != _containerControlType) {
        _containerControlType = containerControlType;
        [self setNeedsLayout];
    }
}

- (void)setEdge:(UIEdgeInsets)edge
{
    if (!UIEdgeInsetsEqualToEdgeInsets(edge, _edge)) {
        _edge = edge;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = _elements.count;
    
    if (count == 0) {
        return;
    }
    
    CGRect bound = UIEdgeInsetsInsetRect(self.bounds, _edge);
    if (count ==1) {
        [_elements.firstObject setFrame:bound];
        return;
    }
    
    
    CGFloat w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    CGFloat x = bound.origin.x, y = bound.origin.y;
    
    CGFloat height,width,gap = _gap;
    CGFloat gapWidthSum = (count-1)*gap;
 
    if (_containerControlType == YCContainerControlTypeVertical) {
        height = (h-gapWidthSum)/count;
        width = w;
        [_elements enumerateObjectsUsingBlock:^(UIView * _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
            v.frame = CGRectMake(x, idx*(height+gap)+y, width, height);
        }];
    } else {
        width = (w-gapWidthSum)/count;
        height = h;
        [_elements enumerateObjectsUsingBlock:^(UIView * _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
            v.frame = CGRectMake(idx*(width+gap)+x, y, width, height);
        }];
    }
    
}
@end


@implementation NSArray (container)

- (void)layoutByType:(YCContainerControlType)type edge:(UIEdgeInsets)edge gap:(CGFloat)gap inFrame:(CGRect)frame
{
    NSInteger count = self.count;
    CGRect bound = UIEdgeInsetsInsetRect(frame, edge);
    if (count == 0) {
        return;
    } else if (count ==1) {
        [self.firstObject setFrame:bound];
        return;
    }
    
    CGFloat w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    CGFloat x = bound.origin.x, y = bound.origin.y;
    
    CGFloat height,width;
    CGFloat gapWidthSum = (count-1)*gap;
    
    if (type == YCContainerControlTypeVertical) {
        height = (h-gapWidthSum)/count;
        width = w;
        [self enumerateObjectsUsingBlock:^(UIView * _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
            v.frame = CGRectMake(x, idx*(height+gap)+y, width, height);
        }];
    } else {
        width = (w-gapWidthSum)/count;
        height = h;
        [self enumerateObjectsUsingBlock:^(UIView * _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
            v.frame = CGRectMake(idx*(width+gap)+x, y, width, height);
        }];
    }
}

@end
