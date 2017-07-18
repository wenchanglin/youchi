//
//  YCssss.m
//  YouChi
//
//  Created by 李李善 on 16/1/19.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCAvatarView.h"
#import "Masonry.h"
#import "UIButton+MJ.h"
#import "YCView.h"


#define YCNameFont 14
#define YCSignFont 12
#define YCLeft 5
@implementation YCAvatarView
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}



- (void) _init{
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 32/2;
    
//    self.sex.image = IMAGE(@"大友米");
    
    
 
    
    [self _updateConstraints];
}
- (void)_updateConstraints
{
#pragma mark-------头像
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(YCLeft);
        make.height.width.mas_equalTo(@56);
    }];
    
#pragma mark --名字
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_top).offset(5);
        make.left.equalTo(self.icon.mas_right).offset(2*YCLeft);
        
    }];
    
    
//#pragma mark --友米图片
//    [self.sex mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.name.mas_left);
//        make.top.equalTo(self.name.mas_bottom).offset(10);
//        make.width.height.equalTo(@15);
//    }];
    
#pragma mark --拥有多少个1897友米
    [self.sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left);
        make.bottom.equalTo(self).offset(-15);
    }];
    
}



- (YCAvatar *)icon{
    
    if (!_icon) {
        _icon = [YCAvatar new];
        _icon.userInteractionEnabled = YES;
        _icon.exclusiveTouch = YES;
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_icon];
        
    }
    return _icon;
};

- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] init];
        [_name setFont:KFontBold(YCNameFont)];
        _name.textColor = KBGCColor(@"#000000");
        [self addSubview:_name];
    }
    return _name;
}

- (UILabel *)sign{
    
    if (!_sign) {
        _sign = [[UILabel alloc] init];
        _sign.textColor = KBGCColor(@"#737373");
        _sign.font = [UIFont systemFontOfSize:YCSignFont];
        
        _sign.numberOfLines = 2;
        [self addSubview:_sign];
    }
    return _sign;
}

- (UIImageView *)sex{
    if (!_sex) {
        _sex = [[UIImageView alloc] init];
        _sex.image = [UIImage imageNamed:@"iconfont-nan"];
        [self addSubview:_sex];
    }
    return _sex;
}

- (void)updateAvatar:(NSURL *)icon Name:(NSString *)name hasYouMi:(NSString *)youmi{
  [self.icon.layer setImageWithURL:icon placeholder:AVATAR_LITTLE options:kImageOption completion:nil];
    self.name.text = name;
    self.sign.text = youmi;
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
