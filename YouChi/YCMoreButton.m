//
//  YCMoreButton.m
//  YouChi
//
//  Created by sam on 15/9/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMoreButton.h"
#import "YCView.h"
@implementation YCMoreButton
- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ;
    
    
    }
    return self;
}

+ (YCMoreButton *)creatDefaultMoreButton
{
    YCMoreButton *mb = [[YCMoreButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    mb.titleLabel.font = [UIFont systemFontOfSize:10];
    [mb setTitleColor:[UIColor colorWithHex:0xd09356] forState:UIControlStateNormal]; 
    [mb setTitle:@"点击查看更多评论 >>" forState:UIControlStateNormal];
    return mb;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
