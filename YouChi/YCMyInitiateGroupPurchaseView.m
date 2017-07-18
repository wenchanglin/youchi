//
//  YCMyInitiateGroupPurchaseView.m
//  YouChi
//
//  Created by 朱国林 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCView.h"
#import "YCMyInitiateGroupPurchaseView.h"
#import "YCMyInitiateGroupM.h"

@implementation YCMyInitiateGroupPurchaseView

-(void)dealloc{
    //    ok
    
}


- (void)yc_initView
{
    [self _initGroupView];
}

- (void)_initGroupView{
    
    [self removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.borderWidth = 1;
    self.borderColor = [UIColor colorWithHexString:@"#b6b6b6"];
    
    // 发起买单
    [self.bInitiatePay mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(5);
        make.right.priorityMedium(self).offset(-5);
        make.bottom.equalTo(self).offset(-8);
        make.height.equalTo(@(40));
    }];
    
    // 发起二维码
    [self.bQrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bInitiatePay);
        make.right.equalTo(self.bInitiatePay);
        make.height.equalTo(@(40));
        make.bottom.equalTo(self.bInitiatePay.mas_top).offset(-9);
    }];
    
    // 团拼图标
    [self.imgGroupIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(9);
        make.bottom.equalTo(self.bQrCode.mas_top).offset(-13);
        make.width.equalTo(@(14));
        make.height.equalTo(@(14));
    }];
    
    // 3人起发团...
    [self.lInitialNum mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.imgGroupIcon.mas_right).offset(7);
        make.bottom.equalTo(self.imgGroupIcon).offset(-1);
        make.height.equalTo(@(12));
    }];
    
    // 打折图标
    [self.imgDiscountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.imgGroupIcon);
        make.bottom.equalTo(self.imgGroupIcon.mas_top).offset(-9);
        make.width.equalTo(@(14));
        make.height.equalTo(@(14));
    }];
    
    // 距离商品打折
    [self.lDiscountLeft mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.lInitialNum);
        make.bottom.equalTo(self.imgDiscountIcon).offset(0);
        make.height.equalTo(@(18));
        make.width.equalTo(@(150));
    }];
    
    // 商品名字
    [self.lName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.imgGroupIcon);
        make.bottom.equalTo(self.lDiscountLeft.mas_top).offset(-4);
        make.height.equalTo(@(16));
    }];
    
    // 红线
    [self.redLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.lName.mas_top).offset(-13);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(5));
    }];
    
    // 商品图标
    [self.imgGroupPurchase mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self.redLine.mas_top);
    }];
    
    // 9折
    [self.lGroupPurchaseNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgGroupPurchase);
        make.right.equalTo(self.imgGroupPurchase);
        make.height.equalTo(@(25));
        make.width.equalTo(@(100));
        
    }];
    
    // 开团人数
    [self.lDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self.lName);
        make.height.equalTo(@(22));
    }];
}

- (UIButton *)bInitiatePay{

    if (_bInitiatePay == nil) {
        
        _bInitiatePay = [UIButton new];
        [self addSubview:_bInitiatePay];
        
        _bInitiatePay.titleLabel.font = [UIFont systemFontOfSize:15];
        _bInitiatePay.cornerRadius = 2.f;
        [_bInitiatePay setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f24941"]] forState:UIControlStateNormal];
        [_bInitiatePay setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        
        _bInitiatePay.userInteractionEnabled = NO;
    }
    
    return _bInitiatePay;
}

- (UIButton *)bQrCode{

    if (_bQrCode == nil) {
        _bQrCode = [UIButton new];
        [self addSubview:_bQrCode];
        [_bQrCode setTitle:@"团拼二维码，邀请小伙伴们扫码参与" forState:UIControlStateNormal];
        _bQrCode.titleLabel.font = [UIFont systemFontOfSize:15];
        _bQrCode.cornerRadius = 2.f;
        _bQrCode.borderColor = [UIColor colorWithHexString:@"#d9d9d9"];
        _bQrCode.borderWidth = 0.8;
        [_bQrCode setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d8b76a"]] forState:UIControlStateNormal];
    }
    
    return _bQrCode;
}

// 团拼图标
- (UIImageView *)imgGroupIcon{

    if (_imgGroupIcon == nil) {
        
        _imgGroupIcon =[UIImageView new];
        [self addSubview:_imgGroupIcon];
        [_imgGroupIcon yc_setImageWithURL:nil placeholder:[UIImage imageNamed:@"团icaon"]];
    }
    
    return _imgGroupIcon;
}

// 3人起 开团
- (UILabel *)lInitialNum{

    if (_lInitialNum == nil) {
        
        _lInitialNum = [UILabel new];
        [self addSubview:_lInitialNum];
        _lInitialNum.textColor = KBGCColor(@"65656D");
        _lInitialNum.text = @"3人起团，最高折扣7折，还等什么";
        _lInitialNum.textAlignment = NSTextAlignmentLeft;
        _lInitialNum.font = [UIFont systemFontOfSize:12];
    }
    
    return _lInitialNum;
}

// 打折图标
- (UIImageView *)imgDiscountIcon{
    
    if (_imgDiscountIcon == nil) {
        
        _imgDiscountIcon =[UIImageView new];
        [self addSubview:_imgDiscountIcon];
        [_imgDiscountIcon yc_setImageWithURL:nil placeholder:[UIImage imageNamed:@"打折ICON"]];
    }
    
    return _imgDiscountIcon;
}

// 打折还差几人
- (UILabel *)lDiscountLeft{

    if (_lDiscountLeft == nil) {
        
        _lDiscountLeft = [UILabel new];
        [self addSubview:_lDiscountLeft];
    }
    
    return _lDiscountLeft;
}

// 团拼商品名字
- (UILabel *)lName{

    if (_lName == nil) {
        
        _lName = [UILabel new];
        [self addSubview:_lName];
        _lName.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _lName.text = @" ";
    }
    
    return _lName;
}

/// 红线
- (UIView *)redLine{
    
    if (_redLine == nil) {
        
        _redLine = [UIView new];
        [self addSubview:_redLine];
        _redLine.backgroundColor = [UIColor colorWithHexString:@"#A71F24"];
    }
    
    return _redLine;
}

/// 団拼图片
- (UIImageView *)imgGroupPurchase{
    
    if (_imgGroupPurchase == nil) {
        
        _imgGroupPurchase = [UIImageView new];
        _imgGroupPurchase.contentMode = UIViewContentModeScaleAspectFill;
                _imgGroupPurchase.backgroundColor = [UIColor orangeColor];
        [self addSubview:_imgGroupPurchase];
    }
    
    return _imgGroupPurchase;
}

/// 団拼人数
- (YYLabel *)lGroupPurchaseNum{
    
    if (_lGroupPurchaseNum == nil) {
        
        _lGroupPurchaseNum = [YYLabel new];
        [self addSubview:_lGroupPurchaseNum];
        _lGroupPurchaseNum.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _lGroupPurchaseNum;
}

/// 团拼打折/第2级优惠
- (UILabel *)lDiscount{
    
    if (_lDiscount == nil) {
        
        _lDiscount = [[UILabel alloc] init];
        [self addSubview:_lDiscount];

    }
    return _lDiscount;
}

/*
- (void)onUpdataInitiateGroup:(YCMyInitiateGroupM *)m{
    
    [self.imgGroupPurchase yc_setImageWithURL:IMAGE_HOST_SHOP(m.shopProduct.imagePath) placeholder:PLACE_HOLDER];
    self.lName.text = m.shopProduct.productName;
    
    /// 已有5人参团
    self.lGroupPurchaseNum.font = KFont(15);
    self.lGroupPurchaseNum.attributedText = m.jointCountAttr;
    self.lGroupPurchaseNum.textAlignment = NSTextAlignmentCenter;
    
    /// 距离打8折还差2人
    self.lDiscountLeft.textColor = [UIColor blackColor];
    self.lDiscountLeft.attributedText = m.nextDiscountAtt;
    
    /// 团拼打折/第2级优惠
    self.lDiscount.attributedText = m.nowDiscountAtt;
    
    /// 还差几人
    self.lInitialNum.text = m.shopProduct.brief;
    
    ///是否可以发起买单
    self.bInitiatePay.enabled = m.isEnough.boolValue;
    [_bInitiatePay setTitle:@"我要买单" forState:UIControlStateNormal];
    int lack = m.nowProductStrategy.gteCount.intValue - m.joinCount.intValue;
    if (lack>0) {
        [_bInitiatePay setTitle:[NSString stringWithFormat:@"还差%d人才能结算",lack] forState:UIControlStateDisabled];
    } else {
        [_bInitiatePay setTitle:@"已达到最大折扣" forState:UIControlStateDisabled];
    }
    
    
    
}
*/
@end
