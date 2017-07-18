//
//  YCAvatarInforView.m
//  YouChi
//
//  Created by 朱国林 on 15/8/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCAvatarControl.h"
#import "Masonry.h"
#import "YCView.h"
#import "YCCommentM.h"
#import "YCLoginM.h"
#import "YCAvatarImageView.h"
#import "YCAvatar.h"
#import "UIButton+MJ.h"
#define YCNameFont 14
#define YCSignFont 12
#define YCLeft 5
#define YCTop 2.2


@implementation YCAvatarControl

-(void)dealloc{
    //    ok
    
}

- (instancetype)init{

    if (self = [super init]) {
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


- (void) _init{
    _iconHeight= self.frame.size.height-5*2;
    _isSexHidden = YES;
    _isSignHidden = NO;
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
//    self.exclusiveTouch = YES;
//    self.userInteractionEnabled = YES;
//    self.enabled = YES;
    
    self.sex.hidden =_isSexHidden;
    self.sign.hidden =_isSignHidden;
    self.sign.numberOfLines = 2;
    self.isClipAvatar = YES;
    
    [self _updateConstraints];
}

- (void)_updateConstraints
{
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.height.width.equalTo(self.mas_height);
    }];
    
#pragma mark --名字
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_top);
        make.left.equalTo(self.icon.mas_right).offset(2*YCLeft);
    }];
    
#pragma mark --性别
    [self.sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(YCLeft);
        make.centerY.equalTo(self.name);
        make.width.height.equalTo(self.name.mas_height);
    }];
    
    
    
#pragma mark --签名
    [self.sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(YCTop);
        make.left.equalTo(self.name.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}
//
-(void)setIconHeight:(CGFloat)iconHeight
{
    if (_iconHeight != iconHeight)
    {
        _iconHeight=iconHeight;
        return;
    }
    
}


- (YCAvatar *)icon{

if (!_icon) {
    _icon = [YCAvatar new];
//    _icon.userInteractionEnabled = YES;
//    _icon.exclusiveTouch = YES;
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

- (void)setIsClipAvatar:(BOOL)isClipAvatar
{
if (_isClipAvatar != isClipAvatar)
{
    _isClipAvatar = isClipAvatar;
//    self.icon.avatarCircle.hidden = isClipAvatar;
//    [self setNeedsLayout];
}
}

///隐藏性别
-(void)setIsSexHidden:(BOOL)isSexHidden
{
    if (_isSexHidden != isSexHidden)
    {
        _isSexHidden = isSexHidden;
        self.sex.hidden = isSexHidden;
        [self setNeedsLayout];
    }
}
///隐藏签名
-(void)setIsSignHidden:(BOOL)isSignHidden
{
    if (_isSignHidden != isSignHidden)
    {
        _isSignHidden = isSignHidden;
        self.sign.hidden = isSignHidden;
        [self setNeedsLayout];
    }
}



- (void)updateComment:(YCLoginUserM *)m{
    
    [_icon yc_setImageWithURL:m.imagePath placeholder:AVATAR ];
    _name.text = m.nickName;
    _sign.text = m.signature;
}

- (void)updateAvatarControlWith:(NSString * )icon name:(NSString *)name sign:(NSString *)sign sex:(id)sex
{
    [_icon ycNotShop_setImageWithURL:icon placeholder:AVATAR];
    _name.text = name;
    _sign.text = sign;
    
    if (sex) {
        _sex.image = SEX_IMAGE([sex boolValue]);
    }
}

- (void)updateAvatarControlWith:(NSString *)icon name:(NSString *)name sign:(NSString *)sign
{
    [self updateAvatarControlWith:icon name:name sign:sign sex:nil];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.icon.frame, point)) {
        return self;
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_isClipAvatar) {
        CGFloat height = CGRectGetHeight(self.icon.frame);
        self.icon.cornerRadius = height/2;
    }else {
        self.icon.cornerRadius = 0;
    }
    self.sex.hidden =_isSexHidden;
    self.sign.hidden = _isSignHidden;
    
}
@end






@implementation YCCenterAvatarControl

-(void)dealloc{
    //    ok
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    //[self _init];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        self.iconHeight= self.frame.size.height-5*2;
    }
    return self;
}

- (void) _init{
    
    
    CGFloat iconMargin =  YCLeft;
    
    self.backgroundColor = [UIColor clearColor];
//    self.opaque = YES;
//    self.userInteractionEnabled = YES;
//    self.enabled = YES;
    
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(iconMargin);
        make.height.width.mas_equalTo(@32);
    }];
    
#pragma mark --名字
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon.mas_centerY);
        make.left.equalTo(self.icon.mas_right).offset(2*YCLeft);
        
    }];
    
#pragma mark --时间
    [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.name.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-2*YCLeft-1);
    }];
    
}

- (UILabel *)timer{
    
    if (!_timer) {
        _timer = [[UILabel alloc] init];
        _timer.textColor = KBGCColor(@"#737373");
        _timer.font = [UIFont systemFontOfSize:YCSignFont];
        _timer.numberOfLines = 1;
        _timer.textAlignment = NSTextAlignmentLeft;
        _timer.text =@"2015-08-8";
        [self addSubview:_timer];
    }
    return _timer;
}



- (void)updateAvatarControlWith:(NSURL *)icon name:(NSString *)name timer:(NSString *)timer{
    
}

@end


@interface YCExchangeAvatarControl ()

@end

@implementation YCExchangeAvatarControl

-(void)dealloc{
    //    ok
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void) _init{
    
    self.iconHeight= self.frame.size.height-5*2;
    self.backgroundColor = [UIColor whiteColor];
//    self.opaque = YES;
//    self.exclusiveTouch = YES;
//    self.userInteractionEnabled = YES;
//    self.enabled = YES;
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 32/2;
    
    self.sex.image = IMAGE(@"大友米");
    
    //self.icon.image = IMAGE(@"btn_weixin");
    
//    self.name.text = @"asdasdsad";
//    self.sign.text = @"asdasdasdsa12345678";

    [self _updateConstraints];
}

- (UIButton *)btnAchieveYouMi{
    
    if (!_btnAchieveYouMi) {
        _btnAchieveYouMi = [UIButton onCearchButtonWithBackgroundImage:nil Title:@"如何获取友米?" Target:self action:@selector(onGetYouMi:)];
        [_btnAchieveYouMi setTitleColor:KBGCColor(@"#232133") forState:UIControlStateNormal];
        _btnAchieveYouMi.titleLabel.font = KFont(11);
        _btnAchieveYouMi.titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_btnAchieveYouMi];
    }
    return _btnAchieveYouMi;
}
- (void)updateAvatar:(NSURL *)icon Name:(NSString *)name hasYouMi:(NSInteger)youmi{
    //[self.icon sd_setImageWithURL:icon placeholderImage:AVATAR options:kImageOption];
    [self.icon.layer setImageWithURL:icon placeholder:AVATAR options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    self.name.text = name;
    self.sign.text = [NSString stringWithFormat:@"我拥有%ld个友米",(long)youmi];
    
    
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
    
    
#pragma mark --友米图片
    [self.sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left);
        make.top.equalTo(self.name.mas_bottom).offset(10);
        make.width.height.equalTo(@15);
    }];
    
#pragma mark --拥有多少个1897友米
    [self.sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sex.mas_right).offset(5);
        make.centerY.equalTo(self.sex.mas_centerY);
    }];
    
    
#pragma mark --如何获取友米?
    [self.btnAchieveYouMi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@24);
    }];
}


-(void)onGetYouMi:(UIButton *)button{
[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end



