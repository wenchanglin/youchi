//
//  YCAddShopCar.m
//  YouChi
//
//  Created by 李李善 on 16/1/14.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCView.h"
#import "YCAddShopCar.h"
#import "UIButton+MJ.h"
#import <Masonry/Masonry.h>
#import <EDColor/EDColor.h>
#import "YCMarcros.h"
#import <objc/runtime.h>
//#import "YCItemDetailM.h"

@implementation YCAddShopCar


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self ==[super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

-(void)_init{
    
    self.hasTopLine = YES;
    ///  减按钮
    [self.btnCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@27);
    }];
    
    ///  减按钮
    [self.btnReduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnCollection.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@25);
    }];
    ///  数量
    [self.much mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnReduce);
        make.left.equalTo(self.btnReduce.mas_right).offset(3);
        make.width.height.equalTo(self.btnReduce);
    }];
    /// 加按钮
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.much);
        make.left.equalTo(self.much.mas_right).offset(3);
        make.width.height.equalTo(self.much);
    }];

    
    ///  j加入购物车
    [self.btnAddShopCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@100);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    
    ///  立即购买
    [self.btnImmediatelyBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnAddShopCar);
        make.right.equalTo(self.btnAddShopCar.mas_left);
        make.bottom.equalTo(self.btnAddShopCar);
        make.width.equalTo(@80);
    }];
}


-(UILabel *)much{
    if (!_much) {
        _much = [UILabel new];
        _much.textAlignment = NSTextAlignmentCenter;
        _much.text = @"1";
        _much.font = KFont(15);
        _much.textColor = KBGCColor(@"#535353");
        //        _much.backgroundColor = [UIColor greenColor];
        [self addSubview:_much];
    }
    return _much;
}



-(UIButton *)btnCollection{
    if (!_btnCollection) {
        _btnCollection = [UIButton onCearchButtonWithImage:@"为收藏状态" SelImage:@"已收藏状态" Title:nil Target:self action:@selector(onShopCar:)];
        _btnCollection.tag = 5;
        [self addSubview:_btnCollection];
    }
    return _btnCollection;
}

-(UIButton *)btnReduce{
    if (!_btnReduce) {
        _btnReduce = [UIButton onCearchButtonWithBackgroundImage:@"减" Title:nil Target:self action:@selector(onShopCar:)];
        _btnReduce.tag = 10;
        [self addSubview:_btnReduce];
    }
    return _btnReduce;
}
-(UIButton *)btnAdd{
    
    if (!_btnAdd) {
        _btnAdd = [UIButton onCearchButtonWithBackgroundImage:@"加" Title:nil Target:self action:@selector(onShopCar:)];
        _btnAdd.tag = 15;
        [self addSubview:_btnAdd];
    }
    return _btnAdd;
}


-(UIButton *)btnImmediatelyBuy{
    
    if (!_btnImmediatelyBuy) {
        _btnImmediatelyBuy = [UIButton onCearchButtonWithImage:@"立即购买" SelImage:nil Title:@"立即购买" Target:self action:@selector(onShopCar:)];
        _btnImmediatelyBuy.titleLabel.font = [UIFont systemFontOfSize:12];
        _btnImmediatelyBuy.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _btnImmediatelyBuy.tag = 20;
        [self addSubview:_btnImmediatelyBuy];
    }
    return _btnImmediatelyBuy;
}

-(UIButton *)btnAddShopCar{
    
    if (!_btnAddShopCar) {
        _btnAddShopCar = [UIButton onCearchButtonWithImage:@"购物车" SelImage:nil Title:@"加入购物车" Target:self action:@selector(onShopCar:)];
        _btnAddShopCar.tag = 25;
        [_btnAddShopCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnAddShopCar.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _btnAddShopCar.titleLabel.font = [UIFont systemFontOfSize:12];
        _btnAddShopCar.backgroundColor = color_btnGold;
        [self addSubview:_btnAddShopCar];
    }
    return _btnAddShopCar;
}

-(void)onShopCar:(UIButton *)sender{
    
    NSUInteger idx = sender.tag;
    _selectInteger = idx;
    _selectButton = sender;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateBtnImmediatelyBuyConstraints{

    [self.btnImmediatelyBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
     
    }];
    
    self.btnReduce.hidden = YES;
    self.btnCollection.hidden = YES;
    self.btnAdd.hidden = YES;
    self.btnAddShopCar.hidden = YES;
    self.much.hidden = YES;
    self.btnAddShopCar.backgroundColor = [UIColor grayColor];
}

//-(void)onUpdateShopCarWithCollection:(BOOL)isCol {
//    self.btnCollection.selected = isCol;
//    
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
