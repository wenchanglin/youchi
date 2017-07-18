//
//  YCProfileButtonsView.m
//  YouChi
//
//  Created by ZhiMin Deng on 15/10/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCProfileButtonsView.h"
#import "YCView.h"

@implementation YCProfileButtonsView
{
    NSMutableArray *_btns;
}

-(void)dealloc{
    //    ok
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    _btns = [NSMutableArray array];
    self.userInteractionEnabled = YES;
    self.backgroundColor = KBGCColor(@"#c6c6c6");
}

- (void)setProfileButtonsCount:(int)profileButtonsCount
{
    if (_profileButtonsCount != profileButtonsCount) {
        _profileButtonsCount = profileButtonsCount;
        [_btns makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_btns removeAllObjects];

        for (int n = 0; n < profileButtonsCount; n++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.numberOfLines = 2;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:KBGCColor(@"#272636") forState:UIControlStateNormal];
            btn.enabled = YES;
            btn.userInteractionEnabled = YES;
            [_btns addObject:btn];
            [self addSubview:btn];
        }
        [self setNeedsLayout];
    }
}

- (NSArray *)profileButtons
{
    return _btns.copy;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat ww = CGRectGetWidth(self.bounds);
    CGFloat hh = CGRectGetHeight(self.bounds);
    const int offset = 0.5;
    CGFloat w = (ww - (self.profileButtonsCount-1) * offset)/self.profileButtonsCount;

    [_btns enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.frame = CGRectMake((w+1)*idx, 0, w, hh);
    }];
}


@end
