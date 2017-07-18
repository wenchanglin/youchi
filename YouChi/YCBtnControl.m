//
//  YCBtnControl.m
//  YouChi
//
//  Created by 朱国林 on 15/8/25.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCBtnControl.h"
#import "YCView.h"
#import "UIButton+MJ.h"
@implementation YCBtnControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc{
    //    ok
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}
- (void)awakeFromNib
{

    //[self _init];
}
- (void)_init{

    _segments = [NSMutableArray array];
    self.backgroundColor = KBGCColor(@"d0d0d0");
}

/// 设置按钮
- (void)insertBtnWithTitle:(NSString *)title {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor whiteColor];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleLabel.numberOfLines = 2;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:KBGCColor(@"#272636") forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(option:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    [_segments addObject:btn];
    [self setNeedsLayout];
}

#pragma mark --绑定按钮方法
- (void)option:(UIButton *)sender{
    
    NSUInteger idx = [_segments indexOfObject:sender];
    
    self.selectedSegmentIndex = idx ;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    float ww = CGRectGetWidth(self.bounds);
    float hh = CGRectGetHeight(self.bounds);

    float w = (ww - (_segments.count -1) * 1)/_segments.count;
    float h = hh;
    
    for (int n = 0; n<_segments.count; n++) {
        
        UIButton *btn = _segments[n];
        btn.frame = CGRectMake(n *(1 + w), 0, w, h);
    }
}
@end
