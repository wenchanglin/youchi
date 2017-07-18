//
//  YCMuchPrice.m
//  YouChi
//
//  Created by 李李善 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMuchPrice.h"
#import "UIButton+MJ.h"
#import <Masonry/Masonry.h>
#import <EDColor/EDColor.h>
#import "YCMarcros.h"
@implementation YCMuchPrice

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self ==[super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

-(void)_init{

    self.totalPrice.textAlignment = self.price.textAlignment = NSTextAlignmentRight;
    self.totalPrice.textColor = self.price.textColor = KBGCColor(@"#232133");
    self.totalPrice.font=self.price.font = KFontBold(12);
    
    
///  减按钮
    [self.btnReduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
///  数量
    [self.much mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnReduce);
        make.left.equalTo(self.btnReduce.mas_right).offset(6);
        make.width.height.equalTo(self.btnReduce);
    }];
/// 加按钮
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.much);
        make.left.equalTo(self.much.mas_right).offset(6);
        make.width.height.equalTo(self.much);
    }];

///  价格
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(self.btnAdd.mas_height);
        make.centerY.equalTo(self.btnAdd.mas_centerY);
    }];

///  总价提示
    [self.totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.price.mas_left).offset(-6);
        make.centerY.equalTo(self.price.mas_centerY);
        make.height.equalTo(self.price.mas_height);
    }];
}

-(UILabel *)totalPrice{
    if (!_totalPrice) {
        _totalPrice = [UILabel new];
        _totalPrice.text =@"小计: ¥";
        [self addSubview:_totalPrice];
    }
    return _totalPrice;
}

-(UILabel *)much{
    if (!_much) {
        _much = [UILabel new];
        _much.textAlignment = NSTextAlignmentCenter;
        _much.text = @"12";
        _much.font = KFont(15);
        _much.textColor = KBGCColor(@"#535353");
//        _much.backgroundColor = [UIColor greenColor];
        [self addSubview:_much];
    }
    return _much;
}
-(UILabel *)price{
    if (!_price) {
        _price = [UILabel new ];
        _price.text = @"12666";
        [self addSubview:_price];
    }
    return _price;
}
-(UIButton *)btnReduce{
    if (!_btnReduce) {
        _btnReduce = [UIButton onCearchButtonWithBackgroundImage:@"减" Title:nil Target:nil action:nil];
        _btnReduce.tag = 10;
        [self addSubview:_btnReduce];
    }
    return _btnReduce;
}
-(UIButton *)btnAdd{
    
    if (!_btnAdd) {
        _btnAdd = [UIButton onCearchButtonWithBackgroundImage:@"加" Title:nil Target:nil action:nil];
        _btnAdd.tag = 20;
        [self addSubview:_btnAdd];
    }
    return _btnAdd;
}

-(void)setHiddenBtnMuch:(BOOL)hiddenBtnMuch{
    if (_hiddenBtnMuch != hiddenBtnMuch) {
        _hiddenBtnMuch = hiddenBtnMuch;
        self.btnAdd.hidden = YES;
        self.btnReduce.hidden = YES;
        self.much.hidden = YES;
    }
}



@end
