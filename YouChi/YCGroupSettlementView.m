//
//  YCGroupSettlementView.m
//  YouChi
//
//  Created by ant on 16/5/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupSettlementView.h"

@implementation YCGroupSettlementView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)yc_initView
{
    [self _init];
}

- (void)_init{

    self.backgroundColor = [UIColor whiteColor];
    
    [self.imgUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.width.height.equalTo(@(50));
    }];
    
    [self.lUserName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.imgUser);
        make.left.equalTo(self.imgUser.mas_right).offset(13);
    }];
    
    /// ￥
    [self.lSymbol mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.lUserName);
        make.bottom.equalTo(self.imgUser);
    }];
    
    [self.lPrice mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.lSymbol.mas_right).offset(2);
        make.bottom.equalTo(self.lSymbol);
        
    }];
    
    /// 规格
    [self.lSpe mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.lPrice).offset(-2);
        make.left.equalTo(self.lPrice.mas_right).offset(2);
    }];
    
    [self.bPay mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.priorityMedium(self);
        make.centerY.equalTo(self.imgUser);
        make.width.equalTo(@(70));
    }];
    
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.equalTo(self.imgUser);
//        make.right.equalTo(self.bPay);
//        make.bottom.equalTo(self);
//        make.height.equalTo(@(0.5));
//    }];
}

- (UIImageView *)imgUser{

    if (_imgUser == nil) {
        _imgUser = [UIImageView new];
        [_imgUser backColor:[UIColor redColor]];
        [self addSubview:_imgUser];
    }
    
    return _imgUser;
}

- (UILabel *)lUserName{

    if (_lUserName == nil) {
        _lUserName = [UILabel newInSuperView:self];
        _lUserName.text = @"李晓珊";
        _lUserName.textColor = [UIColor colorWithHexString:@"2f2d3e"];
        _lUserName.font = [UIFont systemFontOfSize:13];
    }
    
    return _lUserName;
}

- (UILabel *)lSymbol{

    if (_lSymbol == nil) {
        _lSymbol = [UILabel newInSuperView:self];
        _lSymbol.text = @"￥";
        _lSymbol.textColor = [UIColor colorWithHexString:@"#e84c3d"];
        _lSymbol.font = [UIFont systemFontOfSize:15];
    }
    
    return _lSymbol;
}

- (UILabel *)lPrice{

    if (_lPrice == nil) {
        
        _lPrice = [UILabel newInSuperView:self];
        _lPrice.text = @"47.85";
        _lPrice.textColor = [UIColor colorWithHexString:@"#e84c3d"];
        _lPrice.font = [UIFont systemFontOfSize:15];
        
    }
    return _lPrice;
}

- (UILabel *)lSpe{

    if (_lSpe == nil) {
        
        _lSpe = [UILabel newInSuperView:self];
        _lSpe.text = @"(2个/盒)x 2";
        _lSpe.font = [UIFont systemFontOfSize:11];
        _lSpe.textColor = [UIColor colorWithHexString:@"#555555"];
    }
    return _lSpe;
}
- (UIView *)line{
    
    if (_line == nil) {
        _line = [UIView newInSuperView:self];
        _line.backgroundColor = [UIColor colorWithHexString:@"b6b6b6"];
    }
    return _line;
}

- (UIButton *)bPay{

    if (_bPay == nil) {
        _bPay = [UIButton newInSuperView:self];
        _bPay.titleLabel.font = [UIFont systemFontOfSize:12];
        _bPay.cornerRadius = 3;
        [_bPay setTitle:@"催他结算" forState:UIControlStateNormal];
        _bPay.backgroundColor = [UIColor colorWithHexString:@"eb4c3d"];
    }
    return _bPay;

}


- (void)setGroupPayState:(YCGroupPayState)groupPayState{

    if (_groupPayState !=groupPayState) {
        
        _groupPayState = groupPayState;
        
        UIColor *bgColor;
        NSString *title;
        
        if (groupPayState == YCGroupPayStateNotPay) {
            
            bgColor = [UIColor colorWithHexString:@"eb4c3d"];
            title = @"催ta结算";
            self.bPay.enabled = YES;
        }else if (groupPayState ==YCGroupPayStateHadPay){
            
            bgColor = [UIColor colorWithHexString:@"a9a9a9"];
            title = @"已经结算";
            self.bPay.enabled = NO;
            
        }else if (groupPayState ==YCGroupPayStateSelfNotPay){
            
            bgColor = [UIColor colorWithHexString:@"58d6bd"];
            title = @"结算";
            self.bPay.enabled = YES;
        }else if (groupPayState ==YCGroupPayStateCancel){
            
            bgColor = [UIColor colorWithHexString:@"a9a9a9"];
            title = @"订单已取消";
            self.bPay.enabled = NO;
        }else if (groupPayState ==YCGroupPayStateisQtyExist){
            
            bgColor = [UIColor colorWithHexString:@"a9a9a9"];
            title = @"商品已下架";
            self.bPay.enabled = NO;
        }


        
        self.bPay.backgroundColor = bgColor;
        [self.bPay setTitle:title forState:UIControlStateNormal];
    }

}

- (void)onUpdataUserImg:(NSString *)userImg userName:(NSString *)name price:(float)price spe:(NSString *)spe count:(int)count groupPayState:(YCGroupPayState)groupPayState{

    [self.imgUser ycNotShop_setImageWithURL:userImg  placeholder:AVATAR];
    
    self.lUserName.text = name;
    
    self.lPrice.text = [NSString stringWithFormat:@"%.2f",price];
    
    self.lSpe.text = [NSString stringWithFormat:@"(%@ x %d)",spe,count];
    
    self.groupPayState = groupPayState;
}

@end
