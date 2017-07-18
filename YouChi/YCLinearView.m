//
//  YCCellManager.m
//  YouChi
//
//  Created by water on 16/6/15.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLinearView.h"
#import "YCCellManagerTopView.h"
#import "YCCellManagerFooterView.h"
#import "YCCellManagerMiddleView.h"
#import "YCLinearInfo.h"
#import "UIView+YC.h"
#import "YCChihuoyingM.h"

@interface YCLinearView ()

@end


@implementation YCLinearView
{
    NSMutableArray *__subviews;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        __subviews = [NSMutableArray new];
    }
    return self;
}


-(void)yc_initView{
}

- (NSArray<UIView *> *)subviews
{
    return __subviews;
}

- (void)addLinearSubview:(UIView *)subview
{
    [__subviews addObject:subview];
}

- (void)updateWithlinearInfoManager:(YCLinearInfoManager *)linearInfoManager
{
    _linearInfoManager = linearInfoManager;
    [self setNeedsLayout];
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    [__subviews addObject:view];
}

- (void)removeLinearSubview:(UIView *)subview
{
    [__subviews removeObject:subview];
}

-(void)layoutSubviews{
    //[super layoutSubviews];
    //CGFloat width = CGRectGetWidth(self.bounds);
    __block CGFloat hy = 0;
    NSArray<YCLinearInfo *> *linearInfos = _linearInfoManager.linearInfos;
    NSParameterAssert(linearInfos.count == __subviews.count);
    for (int i = 0; i < __subviews.count; i++) {
        UIView *obj = __subviews[i];
        YCLinearInfo *info = linearInfos[i];
        
//        if (!width && width != obj.width) {
//            NSLog(@"实际宽度跟预设的宽度不一样");
//        }
        
        obj.frame = CGRectMake(0, hy, info.width, info.height);
        
        hy += info.height;
        
    }

}

@end
