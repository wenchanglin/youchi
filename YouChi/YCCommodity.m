//
//  YCCommodity.m
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCView.h"
#import "YCCommodity.h"
#import <Masonry/Masonry.h>
#import <EDColor/EDColor.h>
#import "YCMarcros.h"

@interface YCCommodity ()

/// X字
@property(nonatomic,strong) UILabel *X;
@end

@implementation YCCommodity

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}


-(void)_init{
    
//    UIControlContentHorizontalAlignmentLeft
    self.Y.font = self.commodityPrice.font = KFontBold(16);
    self.Y.textColor = self.commodityPrice.textColor = KBGCColor(@"#F24941");
    
    self.X.textColor = self.commodityMuch.textColor = self.commodityWeight.textColor = self.commoditySpecifications.textColor = self.commodityName.textColor = KBGCColor(@"#232133");
    
    self.commodityPrice.textAlignment = self.X.textAlignment =self.Y.textAlignment = NSTextAlignmentRight;
    self.commodityMuch.textAlignment = NSTextAlignmentRight;
    self.commodityName.textAlignment =self.commoditySpecifications.textAlignment = self.commodityWeight.textAlignment =NSTextAlignmentLeft;
    
    self.X.font =self.commodityMuch.font = self.commodityWeight.font = self.commoditySpecifications.font = KFont(11);
    
    ///图片
    [self.commodityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.height.equalTo(@68);
    }];
    ///名字
    [self.commodityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityImage.mas_top);
        make.left.equalTo(self.commodityImage.mas_right).offset(9);
        make.height.equalTo(@15);
    }];
    ///规格文字
    [self.commoditySpecifications mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityName.mas_bottom).offset(9);
        make.left.equalTo(self.commodityName.mas_left);
        make.height.equalTo(@11);
        make.width.equalTo(@28);
    }];
    
    ///数量
    [self.commodityMuch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commoditySpecifications.mas_centerY);
        make.right.equalTo(self).offset(-12);
        make.height.equalTo(@12);
//        make.width.equalTo(@30);
    }];
    
    
    ///X
    [self.X mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commodityMuch.mas_centerY);
        make.right.equalTo(self.commodityMuch.mas_left).offset(-1);
        make.height.equalTo(self.commodityMuch);
        make.width.equalTo(@10);
    }];

    
    ///规格描述
    [self.commodityWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commoditySpecifications.mas_top);
        make.left.equalTo(self.commoditySpecifications.mas_right).offset(-2);
        make.right.equalTo(self.X.mas_left).offset(-15);
    }];
    
    
    ///单价
    [self.commodityPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commodityName.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-11);
        make.height.equalTo(@16);
        
    }];
    
    ///Y字
    [self.Y mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commodityPrice.mas_centerY);
        make.right.equalTo(self.commodityPrice.mas_left).offset(-2);
        make.height.equalTo(self.commodityPrice);
    }];

    [self.ant mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commodityPrice.mas_centerY);
        make.left.equalTo(self.commodityName.mas_right);
        make.right.equalTo(self.commodityPrice.mas_left).offset(-5);
        make.height.width.equalTo(@15);

    }];
    
    
}





///商品名称
-(UILabel *)commodityName{
    if (!_commodityName) {
        _commodityName = [UILabel new];
        _commodityName.text = @"精选小番茄";
        _commodityName.font = KFontBold(13);
        [self addSubview:_commodityName];
    }
    return _commodityName;
}

///商品单价 ¥50
-(UILabel *)commodityPrice{
    if (!_commodityPrice) {
        _commodityPrice = [UILabel new];
        _commodityPrice.text = @"70";
        
        [self addSubview:_commodityPrice];
    }
    return _commodityPrice;
}

///¥字
-(UILabel *)Y{
    if (!_Y) {
        _Y = [UILabel new];
        _Y.text = @"¥";
//        _Y.backgroundColor = [UIColor redColor];
        [self addSubview:_Y];
    }
    return _Y;
}

- (UIImageView *)ant{

    if (!_ant) {
        _ant = [UIImageView new];
        _ant.image = [UIImage imageNamed:@"小友米"];
        [self addSubview:_ant];
        _ant.hidden = YES;
    }
    return _ant;
}

///商品数量 x10
-(UILabel *)commodityMuch{
    if (!_commodityMuch) {
        _commodityMuch = [UILabel new ];
        _commodityMuch.text = @"10";
        [self addSubview:_commodityMuch];
    }
    return _commodityMuch;
}

///X字
-(UILabel *)X{
    if (!_X) {
        _X = [UILabel new];
        _X.text = @"x";
        [self addSubview:_X];
    }
    return _X;
}


///商品份量 200g/份
-(UILabel *)commodityWeight{
    if (!_commodityWeight) {
        _commodityWeight = [UILabel new ];
        _commodityWeight.text = @"200/份";
         _commodityWeight.numberOfLines = 2;
        [self addSubview:_commodityWeight];
    }
    return _commodityWeight;
}

///商品规格
-(UILabel *)commoditySpecifications{
    if (!_commoditySpecifications) {
        _commoditySpecifications = [UILabel new ];
        _commoditySpecifications.text = @"规格:";
        [self addSubview:_commoditySpecifications];
    }
    return _commoditySpecifications;
}
///商品图片
-(UIImageView *)commodityImage{
    if (!_commodityImage) {
        _commodityImage = [UIImageView new ];
        _commodityImage.contentMode =UIViewContentModeScaleAspectFill;
        _commodityImage.image =AVATAR_LITTLE;
        _commodityImage.layer.masksToBounds = YES;
        [self addSubview:_commodityImage];
    }
    return _commodityImage;
}

-(void)setHiddenMuch:(BOOL)hiddenMuch{
    if (_hiddenMuch != hiddenMuch)
    {
        _hiddenMuch = hiddenMuch;
        self.X.hidden = YES;
         self.commodityMuch.hidden = YES;
        [self setNeedsLayout];
    }

}

-(void)setHiddenY:(BOOL)hiddenY{
    if (_hiddenY != hiddenY)
    {
        _hiddenY = hiddenY;
        self.Y.hidden = YES;
        [self setNeedsLayout];
    }
    
}



-(void)setHiddenSpecifications:(BOOL)hiddenSpecifications{
    if (_hiddenSpecifications != hiddenSpecifications)
    {
        _hiddenSpecifications = hiddenSpecifications;
        self.commoditySpecifications.hidden = YES;
        ///  商品类型
        [self.commodityWeight mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commodityName.mas_left);
        }];

        [self setNeedsLayout];
    }
    
}







-(void)onUpdataCommodityName:(NSString *)name Much:(int)much Price:(NSString *)price Weight:(NSString *)weight Image:(NSString *)url{
    
    self.commodityName.text = name;
    self.commodityMuch.text = [NSString stringWithFormat:@"%d",much];
    self.commodityPrice.text = price;//[NSString stringWithFormat:@"%.2f",price.floatValue];
    self.commodityWeight.text = [NSString stringWithFormat:@" %@",weight];
    
    [self.commodityImage ycShop_setImageWithURL:url placeholder:PLACE_HOLDER];
    
    
    //_commodityPrice 在Masonry不会自适应宽度，才出此下策,原因不明~
    
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [self.commodityPrice.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [self.commodityPrice mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(labelsize.width+3));
    }];
    
    CGSize labelsize2 = [self.commodityMuch.text sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [self.commodityMuch mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(labelsize2.width+3));
    }];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
