//
//  YCTextField.m
//  YouChi
//
//  Created by 李李善 on 15/8/9.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCView.h"
#import "YCTextField.h"
#import "YCMarcros.h"
#import <Masonry/Masonry.h>
@interface YCTextField()

@end

@implementation YCTextField
{
    NSMutableArray *_lines;
}


-(void)dealloc{
    //    ok
    
}
- (void)prepareForInterfaceBuilder{

}


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)_init
{
    NSMutableArray *arr = [NSMutableArray new];
    for (int n = 0; n < 2; n++) {
        UIView *layer = [self creatLine];
        [self addSubview:layer];
        [arr addObject:layer];
    }
    _lines = arr;
    /*
    UIView *v1 = arr[0];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.equalTo(self).dividedBy(2);
        make.width.mas_equalTo(0.5);
    }];
    
    UIView *v2 = arr[1];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.width.height.equalTo(v1);
    }];
    
    UIView *v3 = arr[2];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
     */
}


-(UIView *)creatLine {
    UIView *layer  = [UIView new];
    layer.backgroundColor = KBGCColor(@"#88888c");
    return layer;
}

-(void)setIsXHidden:(BOOL)isXHidden{
    if (_isXHidden != isXHidden) {
        _isXHidden = isXHidden;
        [self setNeedsLayout];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectInset(rect, 5, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    return CGRectInset(rect, 5, 0);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_isXHidden == NO) {
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    
    CGFloat offset = 0.5f *2;
    UIView *v1 = _lines[0];
    v1.frame = CGRectMake(0, h/1.5, offset, h/2);
    
    UIView *v2 = _lines[1];
    v2.frame = CGRectMake(0, h-offset, w, offset);
    }
}

- (void)lineColorSelected:(UIColor *)color{

    for (UIView *v in _lines) {
        v.backgroundColor = color;
    }
    
}

- (void)lineColorNormal:(UIColor *)color{

    for (UIView *v in _lines) {
        v.backgroundColor = color;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
