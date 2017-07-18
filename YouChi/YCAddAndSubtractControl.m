//
//  YCAddAndSubtractControl.m
//  YouChi
//
//  Created by 朱国林 on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "YCAddAndSubtractControl.h"
#import "UIButton+MJ.h"

@implementation YCAddAndSubtractControl

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

- (UILabel *)lNumber{
    
    if (!_lNumber) {
        _lNumber = [[UILabel alloc] init];
        _lNumber.textAlignment = NSTextAlignmentCenter;
        _lNumber.text = @"0";
        _lNumber.font = [UIFont systemFontOfSize:16];
        [self addSubview:_lNumber];
        
    };
    return _lNumber;
}

-(UIButton *)btnSubtract{
    if (!_btnSubtract) {
        _btnSubtract = [UIButton onCearchButtonWithBackgroundImage:@"减" Title:nil Target:self action:@selector(onSubtract)];
        _btnSubtract.tag = 10;
        [self addSubview:_btnSubtract];
    }
    return _btnSubtract;
}
-(UIButton *)btnAdd{
    
    if (!_btnAdd) {
        _btnAdd = [UIButton onCearchButtonWithBackgroundImage:@"加" Title:nil Target:self action:@selector(onAdd)];
        _btnAdd.tag = 20;
        [self addSubview:_btnAdd];
    }
    return _btnAdd;
}

- (void)_init{
    
    [self.lNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@25);
    }];
    
    [self.btnSubtract mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.lNumber.mas_left).offset(-2);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@25);
        
    }];

    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lNumber.mas_right).offset(2);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@25);

        
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
