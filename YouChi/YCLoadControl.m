//
//  YCLoadView.m
//  YouChi
//
//  Created by sam on 15/6/15.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLoadControl.h"
#import <Masonry/Masonry.h>

@interface YCLoadControl   ()
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UILabel *desc;
@end
@implementation YCLoadControl


{
    BOOL isEnd;
}

- (void)dealloc{
    //ok
}
- (instancetype)initWithFrame:(CGRect)frame
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
    _desc = ({
        UILabel *l = [UILabel new];
        [self addSubview:l];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.top.bottom.equalTo(self);
        }];
        l;
    });
    
    _indicator = ({
        UIActivityIndicatorView *aiv = [UIActivityIndicatorView new];
        [self addSubview:aiv];
        [aiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_desc);
            make.right.equalTo(_desc.mas_left).offset(-10);
        }];
        aiv;
    });
    
    
}

+ (YCLoadControl *)creatDefaultLoadView
{
    YCLoadControl *lv = [[YCLoadControl alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    lv.indicator.hidesWhenStopped = YES;
    return lv;
}

- (void)showLoading
{
    self.desc.text = @"正在加载中";
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.indicator startAnimating];
}

- (void)hideLoading
{
    self.desc.text = @"亲，全部加载完毕";
    [self.indicator stopAnimating];
}

- (void)errorLoading
{
    self.desc.text = @"加载失败";
    [self.indicator stopAnimating];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
