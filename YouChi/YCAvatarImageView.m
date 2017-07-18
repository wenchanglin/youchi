//
//  YCAvatarImageView.m
//  YouChi
//
//  Created by sam on 15/11/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCAvatarImageView.h"
#import <Masonry/Masonry.h>
@implementation YCAvatarImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    UIImage *img = [UIImage imageNamed:@"yuan"];
    UIImageView *iv = [[UIImageView alloc]initWithImage:img];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
