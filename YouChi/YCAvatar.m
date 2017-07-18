//
//  YCAvatar.m
//  YouChi
//
//  Created by sam on 15/8/26.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCAvatar.h"
#import <Masonry/Masonry.h>
#import "YCAvatarImageView.h"
@implementation YCAvatar
{
    UIImageView *_circle;
    CAShapeLayer *round;
}
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
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


- (void)_init
{
    
    _circle = [UIImageView new];
    _circle.contentMode = UIViewContentModeScaleAspectFill;
    _circle.image = [UIImage imageNamed:@"yuan"];
    [self addSubview:_circle];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _circle.frame = self.bounds;
    
    
}

@end
