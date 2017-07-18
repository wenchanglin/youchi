//
//  YCGroupOrderNumView.m
//  YouChi
//
//  Created by ant on 16/5/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupOrderNumView.h"

@implementation YCGroupOrderNumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self _init];
    }
    
    return self;
}

- (void)_init{

    self.backgroundColor = [UIColor whiteColor];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(0);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(14));
    }];
    
    [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.icon.mas_right).offset(5);
        make.centerY.equalTo(self).offset(-1);
    }];
}

- (UIImageView *)icon{

    if (_icon == nil) {
        
        _icon = [UIImageView new];
        [self addSubview:_icon];
        _icon.image = [UIImage imageNamed:@"团icaon"];
    }
    
    return _icon;
}

- (UILabel *)lTitle{

    if (_lTitle == nil) {
        
        _lTitle = [UILabel newInSuperView:self];
        _lTitle.text = @"商品已经发出，我们将会寄到统一地址";
        _lTitle.font = [UIFont systemFontOfSize:12];
        _lTitle.textColor = [UIColor colorWithHexString:@"ff9d00"];
        _lTitle.textAlignment = NSTextAlignmentLeft;
        _lTitle.numberOfLines = 1;
    }
    
    return _lTitle;
}

- (void)onUpdataRemainingNum:(int)count{


    if (self.groupOrderState == YCGroupOrderStateHadSend) {  // 已发货
        
        self.lTitle.attributedText = [self titleStr:@"商品已经发出，我们将会寄到统一地址 " attText:@" " attColor:@"ff4b3a" attFont:18];
        return;
    }
    
    if (self.groupOrderState == YCGroupOrderStateAllHadPay) { // 已全部付款
        
        self.lTitle.attributedText = [self titleStr:@"已经全部付款，请等待发货 " attText:@" " attColor:@"ff4b3a" attFont:18];
        
        return;
    }

    self.icon.image = [UIImage imageNamed:@"打折ICON"];
    NSString *numStr = [NSString stringWithFormat:@"%d",count];
    
    NSString *title = [NSString stringWithFormat:@"还差%@人，尚未结算",numStr];
    self.lTitle.textColor = [UIColor colorWithHexString:@"ff4b3a"];
    self.lTitle.attributedText = [self titleStr:title attText:numStr attColor:@"ff4b3a" attFont:18];
}


- (NSMutableAttributedString *)titleStr:(NSString *)str attText:(NSString *)changStr attColor:(NSString *)color attFont:(int )font{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    
    [text setColor:[UIColor colorWithHexString:color] range:[str rangeOfString:changStr]];
    [text setFont:[UIFont systemFontOfSize:font] range:[str rangeOfString:changStr]];
    
    return text;
}

@end
