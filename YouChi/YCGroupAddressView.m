//
//  YCGroupAddressView.m
//  YouChi
//
//  Created by ant on 16/5/19.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupAddressView.h"

@implementation YCGroupAddressView

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        [self _init];
    }
    
    return self;
}

-(void)yc_initView{
    
}

- (void)_init{

    self.backgroundColor = [UIColor whiteColor];
    
    [self.imgMapIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(self);
        make.top.equalTo(self).offset(11);
        make.width.equalTo(@(13));
        make.height.equalTo(@(20));
    }];
    
    [self.lTitleAddress mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.imgMapIcon.mas_right).offset(10);
        make.centerY.equalTo(self.imgMapIcon);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(0.5));
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.imgMapIcon.mas_bottom).offset(11);
    }];
    
    [self.lName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(15));
        make.left.equalTo(self.imgMapIcon);
        make.top.equalTo(self.line.mas_bottom).offset(13);
    }];
    
    [self.lPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.lName);
        make.right.equalTo(self.line).offset(-20);
        
    }];
    
    [self.lAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lName.mas_bottom).offset(15);
        make.left.equalTo(self.lName);
        make.right.equalTo(self.line);
        make.height.equalTo(@(30));
    }];
    
    [self.imgAdd mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.equalTo(@(20));
        make.centerX.equalTo(self);
        make.top.equalTo(self.line.mas_bottom).offset(29);
    }];
    
    [self.lAddTitleAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.imgAdd);
        make.top.equalTo(self.imgAdd.mas_bottom).offset(8);
        
    }];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(5);
        make.width.equalTo(@(10));
        make.height.equalTo(@(20));
        make.centerY.equalTo(self.imgAdd).offset(5);
    }];
    
}

- (UIImageView *)imgMapIcon{

    if (_imgMapIcon == nil) {
        
        _imgMapIcon = [UIImageView newInSuperView:self];
        [_imgMapIcon setImageWithURL:nil placeholder:IMAGE(@"定位")];

    }
    
    return _imgMapIcon;
}

- (UILabel *)lTitleAddress{

    if (_lTitleAddress == nil) {
        _lTitleAddress = [UILabel newInSuperView:self];
        _lTitleAddress.font = KFont(15);
        _lTitleAddress.textColor = KBGCColor(@"333333");
        _lTitleAddress.text = @"统一收货地址";
        _lTitleAddress.textAlignment = NSTextAlignmentLeft;
    }
    
    return _lTitleAddress;
}
- (UIView *)line{

    if (_line == nil) {
        _line = [UIView newInSuperView:self];
        _line.backgroundColor = KBGCColor(@"b6b6b6");
    }
    
    return _line;
}

- (UILabel *)lName{

    if (_lName == nil) {
        
        _lName = [UILabel newInSuperView:self];
        _lName.font = KFont(15);
        _lName.textColor = KBGCColor(@"333333");
        _lName.textAlignment = NSTextAlignmentLeft;
        _lName.text = @"收件人：李大爷";
    }
    
    return _lName;
}

- (UILabel *)lPhone{

    if (_lPhone == nil) {
        
        _lPhone = [UILabel newInSuperView:self];
        _lPhone.font = KFont(14);
        _lPhone.textColor = KBGCColor(@"333333");
        _lPhone.textAlignment = NSTextAlignmentRight;
        _lPhone.text = @"123456781234";
    }
    
    return _lPhone;
}

- (UILabel *)lAddress{

    if (_lAddress == nil) {
        
        _lAddress = [UILabel newInSuperView:self];
        _lAddress.font = KFont(12);
        _lAddress.textColor = KBGCColor(@"333333");
        _lAddress.textAlignment = NSTextAlignmentLeft;
        _lAddress.text = @"收货地址： ";
        _lAddress.numberOfLines = 2;
    }
    
    return _lAddress;
}

- (UIImageView *)imgAdd{

    if (_imgAdd == nil) {
        
        _imgAdd = [UIImageView newInSuperView:self];
        _imgAdd.image = IMAGE(@"添加1");
    }
    
    return _imgAdd;
}

- (UILabel *)lAddTitleAddress{

    if (_lAddTitleAddress == nil) {
        
        _lAddTitleAddress = [UILabel newInSuperView:self];
        _lAddTitleAddress.font = KFont(15);
        _lAddTitleAddress.textColor = KBGCColor(@"333333");
        _lAddTitleAddress.textAlignment = NSTextAlignmentLeft;
        _lAddTitleAddress.text = @"添加地址";
        _lAddTitleAddress.numberOfLines = 2;
    }
    
    return _lAddTitleAddress;
    
}
- (UIImageView *)imgArrow{

    if (_imgArrow == nil) {
        
        _imgArrow = [UIImageView newInSuperView:self];
        _imgArrow.image = IMAGE(@"箭头");
        _imgArrow.hidden = YES;
    }
    
    return _imgArrow;
    
}

- (void)onUpdataName:(NSString *)name phone:(NSString *)phone address:(NSString *)address{

    if (name == nil) {
        
        self.lTitleAddress.text = @"请填写统一收货地址";
        self.lName.hidden = self.lPhone.hidden = self.lAddress.hidden = self.imgArrow.hidden = YES;
        self.imgAdd.hidden = self.lAddTitleAddress.hidden = NO;
    }
    
    else{
        self.lTitleAddress.text = @"统一收货地址";
        self.lName.text = [NSString stringWithFormat:@"收件人：%@",name];
        self.lPhone.text = phone;
        self.lAddress.text = [NSString stringWithFormat:@"收货地址：%@",address];
        self.lName.hidden = self.lPhone.hidden = self.lAddress.hidden = NO;
        self.imgAdd.hidden = self.lAddTitleAddress.hidden = YES;
    
    }
}

- (void)updateRecipientAddress:(YCRecipientAddressM *)m
{
    [self onUpdataName:m.receiverName phone:m.receiverPhone address:[NSString stringWithFormat:@"%@%@%@%@",m.provinceName,m.cityName,m.townName,m.receiverAddress?:@""]];
    self.imgArrow.hidden = NO;
}

- (void)updateMyOrder:(YCMyOrderM *)m
{
    [self onUpdataName:m.receiverName phone:m.receiverPhone address:m.receiverAddress];
}
@end
