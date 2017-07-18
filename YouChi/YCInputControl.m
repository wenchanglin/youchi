//
//  YCInputControl.m
//  YouChi
//
//  Created by sam on 15/8/27.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCInputControl.h"
#import <Masonry/Masonry.h>

@implementation YCInputControl

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
- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(8, 8, 8, 8);
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self).insets(inset);
        make.right.equalTo(self.send.mas_left).offset(-8);
    }];
    
    [self.send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self).insets(inset);
        make.width.mas_equalTo(52);
    }];
}

- (UITextField *)content
{
    if (!_content) {
        _content = [[UITextField alloc]init];
        _content.placeholder = @"请输入";
        [self addSubview:_content];
    }
    return _content;
}

- (UIButton *)send
{
    if (!_send) {
        _send = [UIButton buttonWithType:UIButtonTypeCustom];
        [_send setTitle:@"发表" forState:UIControlStateNormal];
        [self addSubview:_send];
    }
    return _send;
}

@end
