//
//  UIView+Layout.m
//  YouChi
//
//  Created by sam on 15/12/30.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "UIView+Layout.h"
#import <objc/runtime.h>

const char *kLinearLayoutEdge = "kLinearEdge";
const char *kLinearLayoutSize = "kLinearSize";
@implementation UIView (Layout)
- (UIEdgeInsets )linearLayoutEdge
{
    return [objc_getAssociatedObject(self, kLinearLayoutEdge) UIEdgeInsetsValue];
}

- (void)setLinearLayoutEdge:(UIEdgeInsets)linearLayoutEdge
{
    objc_setAssociatedObject(self, kLinearLayoutEdge, [NSValue valueWithUIEdgeInsets:linearLayoutEdge], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)linearLayoutSize
{
    return [objc_getAssociatedObject(self, kLinearLayoutSize) CGSizeValue];
}

- (void)setLinearLayoutSize:(CGSize)linearLayoutSize
{
    objc_setAssociatedObject(self, kLinearLayoutSize, [NSValue valueWithCGSize:linearLayoutSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation NSArray (Layout)

- (void)linearLayoutByType:(LayoutType)type inFrame:(CGRect)frame
{
    if (self.count == 0) {
        return;
    }
    
    __block CGFloat x = frame.origin.x;
    __block CGFloat y = frame.origin.y;
    
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    [self enumerateObjectsUsingBlock:^(UIView*  _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSParameterAssert([v isKindOfClass:[UIView class]]);
        CGRect frame = CGRectZero;
        CGSize size = v.linearLayoutSize;
        if (type == LayoutTypeVertical) {
            frame = CGRectMake(x, y, w, size.height>0?size.height:v.bounds.size.height);
            y += frame.size.height;
        }
        
        else if (type == LayoutTypeHorizen) {
            frame = CGRectMake(x, y, size.width>0?size.width:v.bounds.size.width, h);
            x += frame.size.width;
        }
        
        UIEdgeInsets insets = v.linearLayoutEdge;
        CGRect rect = UIEdgeInsetsInsetRect(frame, insets);
        v.frame = rect;
        
    }];
}

@end