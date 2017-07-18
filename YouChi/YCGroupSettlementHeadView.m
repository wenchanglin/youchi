//
//  YCGroupSettlementHeadView.m
//  YouChi
//
//  Created by ant on 16/5/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <YYKit/YYKit.h>
#import "Masonry.h"
#import "YCView.h"
#import "YCGroupSettlementHeadView.h"


@implementation YCGroupSettlementHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self _init];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (void)_init{

    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
        make.height.equalTo(@(16));
        make.width.equalTo(@(14));
    }];
    
    [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(10));
        make.width.equalTo(@(7));
        make.right.equalTo(self).offset(-8);
        make.centerY.equalTo(self.icon);
    }];
    
    [self.bShipmentsRules mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.imgArrow.mas_left).offset(-5);
        make.centerY.equalTo(self.icon);
    }];
}

- (UIImageView *)icon{

    if (_icon == nil) {
        
        _icon = [UIImageView new];
        [self addSubview:_icon];
        
        _icon.image = [UIImage imageNamed:@"结算情况"];
    }
    
    return _icon;
}

- (UILabel *)lTitle{

    if (_lTitle == nil) {
        
        _lTitle = [UILabel newInSuperView:self];
        _lTitle.text = @"结算情况";
        _lTitle.font = [UIFont systemFontOfSize:13];
        _lTitle.textColor = [UIColor colorWithHexString:@"2f2d3e"];
        
    }
    
    return _lTitle;
}


- (UIImageView *)imgArrow{
    
    if (_imgArrow == nil) {
        
        _imgArrow = [UIImageView newInSuperView:self];
        _imgArrow.image = [UIImage imageNamed:@"结算与发货规则"];
    }
    
    return _imgArrow;
}

- (UIButton *)bShipmentsRules{

    if (_bShipmentsRules == nil) {
        
        _bShipmentsRules = [UIButton newInSuperView:self];
        [_bShipmentsRules setTitle:@"结算与发货规则" forState:UIControlStateNormal];
        [_bShipmentsRules setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _bShipmentsRules.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return _bShipmentsRules;
}

- (void)setIsHiddenIcon:(BOOL)isHiddenIcon{

    _isHiddenIcon = isHiddenIcon;
    
    if (isHiddenIcon == YES) {
        
        self.icon.hidden = YES;
        
        [self.lTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(14);
            make.centerY.equalTo(self);
        }];
        
        [self.imgArrow mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@(10));
            make.width.equalTo(@(7));
            make.right.equalTo(self).offset(-14);
            make.centerY.equalTo(self.icon);
        }];
    }
}

@end
