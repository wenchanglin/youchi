//
//  YCRankView.m
//  YouChi
//
//  Created by sam on 15/5/24.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCView.h"
#import "YCRankView.h"
#import <Masonry/Masonry.h>
@implementation YCRankView
- (void)dealloc{
    //ok
}
- (void)prepareForInterfaceBuilder
{
//    [self awakeFromNib];
}
- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.opaque = YES;
    
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.center.equalTo(self);
        
    }];
}


- (UILabel *)desc
{
    if (!_desc) {
        _desc = [UILabel new];
        _desc.textColor = KBGCColor(@"#d09356");
        _desc.font = [UIFont systemFontOfSize:12];
        //_desc.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_desc];
    }
    return _desc;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation YCTimeView
- (void)dealloc{
    //ok
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.img.image = [UIImage imageNamed:@"吃货营-切_29"];
    self.desc.text = @"2015.6.4";//[NSDate date].description;
    self.desc.textColor =[UIColor colorWithRed:165.f/255.f green:224.f/255.f blue:90.f/255.f alpha:1];
}

@end