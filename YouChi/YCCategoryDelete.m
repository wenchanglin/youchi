//
//  YCCategoryDelete.m
//  YouChi
//
//  Created by 李李善 on 15/12/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//


#import "YCCategoryDelete.h"
#import "UIButton+MJ.h"
#import <Masonry/Masonry.h>
#import <EDColor/EDColor.h>
#import "YCMarcros.h"
@implementation YCCategoryDelete

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}


-(void)_init{
    
    ///  选中按钮
    [self.btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self).offset(5);
        make.width.height.equalTo(@20);
    }];
    
    
    
    ///  商品类型
    [self.commodityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.priorityMedium(self.btnSelect.mas_right).offset(36);
        make.centerY.equalTo(self.btnSelect.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    ///  删除按钮
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.commodityName.mas_centerY);
        make.width.height.equalTo(self.btnSelect);
    }];
    
}


-(void)onUpdataCommodityName:(NSString *)name Selsct:(BOOL)select{
    
    self.commodityName.text = name;
    self.btnSelect.selected = select;
}






-(UILabel *)commodityName{
    if (!_commodityName) {
        _commodityName = [UILabel new];
        _commodityName.textAlignment = NSTextAlignmentLeft;
        _commodityName.font = KFontBold(12);
        
        [self addSubview:_commodityName];
    }
    return _commodityName;
}


-(UIButton *)btnSelect
{
    if (!_btnSelect) {
        _btnSelect =[UIButton onCearchButtonWithImage:@"未选择" SelImage:@"已选择" Title:nil Target:nil action:nil];
        _btnSelect.tag = 40;
        [self addSubview:_btnSelect];
    }
    return _btnSelect;
}


-(UIButton *)btnDelete
{
    if (!_btnDelete) {
        _btnDelete = [UIButton onCearchButtonWithImage:@"删除订单按钮" SelImage:nil Title:nil Target:nil action:nil];
        _btnDelete.tag = 30;
        [self addSubview:_btnDelete];
    }
    return _btnDelete;
}



-(void)setHiddenBtnSel:(BOOL)hiddenBtnSel
{
    if (_hiddenBtnSel != hiddenBtnSel)
    {
        _hiddenBtnSel = hiddenBtnSel;
        self.btnDelete.hidden = YES;
        self.btnSelect.hidden = YES;
        ///  商品类型
        [self.commodityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnSelect.mas_right).offset(-10);
        }];
        [self setNeedsLayout];
    }
}

- (void)setYcOrderStateTypeCell:(YCOrderStateTypeCell)ycOrderStateTypeCell{

    _ycOrderStateTypeCell = YCOrderStateOrderDetailCll;
    if (_ycOrderStateTypeCell == YCOrderStateOrderDetailCll) {

        
    }
    
}


@end