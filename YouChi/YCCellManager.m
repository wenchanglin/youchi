//
//  YCCellManager.m
//  YouChi
//
//  Created by water on 16/6/15.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCellManager.h"
#import "YCCellManagerTopView.h"
#import "YCCellManagerFooterView.h"
#import "YCCellManagerMiddleView.h"
#import "YCCellManagerFrame.h"
#import "YCViewInfo.h"
#import "UIView+YC.h"

@interface YCCellManager ()

@property (weak,nonatomic) YCCellManagerFooterView *footerView;
@property (weak,nonatomic) YCCellManagerTopView *topView;
@property (weak,nonatomic) YCCellManagerMiddleView *middleView;

@end

static int h = 0;

@implementation YCCellManager

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        YCCellManagerTopView *topView = [[YCCellManagerTopView alloc] init];
        [self addSubview:topView];
        self.topView = topView;
        
        YCCellManagerMiddleView *middleView = [[YCCellManagerMiddleView alloc] init];
        [self addSubview:middleView];
        self.middleView = middleView;
        
        YCCellManagerFooterView *footerView = [[YCCellManagerFooterView alloc] init];
        [self addSubview:footerView];
        self.footerView = footerView;
    }
    return self;
}

-(void)setManagerFrame:(YCCellManagerFrame *)managerFrame{
    _managerFrame = managerFrame;
}

-(void)updateWithViewInfo:(NSArray *)infos{
    [self.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.viewInfo = infos[idx];
    }];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        h += obj.viewInfo.height;
    }];
    self.viewInfo.height = h;
}


@end
