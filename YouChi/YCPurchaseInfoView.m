//
//  YCPurchaseInfoView.m
//  YouChi
//
//  Created by 朱国林 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCView.h"
#import "YCPurchaseInfoView.h"

@implementation YCPurchaseInfoView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



-(void)yc_initView{
    [self _init];
}

- (void)_init{
    
    self.backgroundColor = [UIColor whiteColor];
    /// 头像
    [self.imgUser mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(18);
        make.left.equalTo(self);
        make.width.height.equalTo(@(80));
    }];
    
    /// 名字
    [self.lUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgUser).offset(3);
        make.left.equalTo(self.imgUser.mas_right).offset(14);
    }];
    
    /// 团拼名称图标
    [self.imgIconTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lUserName);
        make.top.equalTo(self.lUserName.mas_bottom).offset(12);
        make.height.equalTo(@(17));
        make.width.equalTo(@(15));
    }];
    
    /// 团拼名字
    [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imgIconTitle.mas_right).offset(3);
        make.bottom.equalTo(self.imgIconTitle);
    }];
    
    /// 打折图标
    [self.imgDiscountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imgUser);
        make.top.equalTo(self.imgUser.mas_bottom).offset(15);
        make.width.height.equalTo(@(14));
    }];
    
    /// 打折
    [self.lDiscountLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imgDiscountIcon.mas_right).offset(7);
        make.bottom.equalTo(self.imgDiscountIcon);
    }];
    
    /// 团拼打折/第2级优惠
    [self.lDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.priorityMedium(self);
        make.centerY.equalTo(self.imgDiscountIcon);
    }];
    
    
    [self.numberOfPurchaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgDiscountIcon.mas_bottom).offset(15);
        make.left.equalTo(self);
        make.right.priorityMedium(self);
        make.height.equalTo(@(66));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imgUser);
        make.right.equalTo(self.lDiscount);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(self.numberOfPurchaseView.mas_top);
    }];
}

- (UIImageView *)imgUser{
    
    if (_imgUser == nil) {
        
        _imgUser = [UIImageView new];
        [self addSubview:_imgUser];
        _imgUser.image = AVATAR;
    }
    
    return _imgUser;
}

- (UILabel *)lUserName{
    
    if (_lUserName == nil) {
        
        _lUserName = [UILabel new];
        [self addSubview:_lUserName];
        _lUserName.font = [UIFont systemFontOfSize:15];
        _lUserName.textColor = [UIColor colorWithHexString:@"#333333"];
        
    }
    
    return _lUserName;
}

/// 图标
- (UIImageView *)imgIconTitle{
    
    if (_imgIconTitle == nil) {
        
        _imgIconTitle = [UIImageView new];
        [self addSubview:_imgIconTitle];
        _imgIconTitle.image = [UIImage imageNamed:@"团拼攻略"];
    }
    
    return _imgIconTitle;
}

/// 标题
- (UILabel *)lTitle{
    
    if (_lTitle == nil) {
        
        _lTitle = [UILabel new];
        [self addSubview:_lTitle];
        _lTitle.font = [UIFont systemFontOfSize:12];
        _lTitle.textAlignment = NSTextAlignmentLeft;
        _lTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        
    }
    
    return _lTitle;
}

/// 打折图标
- (UIImageView *)imgDiscountIcon{
    
    if (_imgDiscountIcon == nil) {
        
        _imgDiscountIcon = [UIImageView new];
        [self addSubview:_imgDiscountIcon];
        _imgDiscountIcon.image = [UIImage imageNamed:@"打折ICON"];
    }
    
    return _imgDiscountIcon;
}

/// 距离7折还差3人
- (UILabel *)lDiscountLeft{
    
    if (_lDiscountLeft == nil) {
        
        _lDiscountLeft = [UILabel new];
        [self addSubview:_lDiscountLeft];
        _lDiscountLeft.font = [UIFont systemFontOfSize:12];
        _lDiscountLeft.textColor = [UIColor colorWithHexString:@"65656e"];
        _lDiscountLeft.textAlignment = NSTextAlignmentRight;
    }
    
    return _lDiscountLeft;
}


/// 团拼打折/第2级优惠
- (UILabel *)lDiscount{
    
    if (_lDiscount == nil) {
        
        _lDiscount = [[UILabel alloc] init];
        [self addSubview:_lDiscount];
        _lDiscount.textColor = [UIColor colorWithHexString:@"#a81f24"];
        _lDiscount.textAlignment = NSTextAlignmentRight;
    }
    return _lDiscount;
}

- (UIView *)line{
    
    if (_line == nil) {
        
        _line = [UIView new];
        [self addSubview:_line];
        _line.backgroundColor = [UIColor colorWithHexString:@"#b6b6b6"];
    }
    return _line;
}

- (YCNumberOfPurchaseView *)numberOfPurchaseView{
    
    if (_numberOfPurchaseView == nil) {
        
        _numberOfPurchaseView = [YCNumberOfPurchaseView new];
        [_numberOfPurchaseView yc_initView];
        [self addSubview:_numberOfPurchaseView];
    }
    
    return _numberOfPurchaseView;
}

- (void)onUpdataImgUser:(NSString *)imgUser userName:(NSString *)userName title:(NSString *)title discountLeftCount:(int)count discount:(float) how rank:(NSString*) rank numberOfPurchaseList:(NSArray *)List{
    [self onUpdataImgUser:imgUser userName:userName title:title discountLeftCount:count leftRank:7.f discount:how rank:rank numberOfPurchaseList:List];
}

-(void)onUpdataImgUser:(NSString *)imgUser userName:(NSString *)userName title:(NSString *)title discountLeftCount:(int)count leftRank:(float)leftRank discount:(float)discount rank:(NSString *)rank numberOfPurchaseList:(NSArray *)List{
    
    [self.imgUser yc_setImageWithURL:IMAGE_HOST_NOT_SHOP(imgUser) placeholder:AVATAR];
    //TODO:显示图片地址方法改了一下
    
    self.lUserName.text = userName;
    
    NSString *titleStr = [NSString stringWithFormat:@"发起了%@团拼",title];
    self.lTitle.attributedText = [self titleStr:titleStr attText:title attColor:[UIColor colorWithHexString:@"#c40000"] attFont:[UIFont systemFontOfSize:12]];
    
    
    NSString *countStr = [NSString stringWithFormat:@"%d",count];
    
    if (count == 0) { // 当达到最高折扣时
        NSString *countText = [NSString stringWithFormat:@"已经达到最高折扣啦 "];
        self.lDiscountLeft.attributedText = [self
                                             titleStr:countText attText:@" " attColor:KBGCColor(@"ff4b3a") attFont:KFont(18)];
    }else{
    
        NSString *countText = [NSString stringWithFormat:@"距离%.1f折还差%@人",leftRank *10,countStr];
        self.lDiscountLeft.attributedText = [self
                                             titleStr:countText attText:countStr attColor:KBGCColor(@"ff4b3a") attFont:KFont(18)];
    }
    
    NSString *discountAttStr = [NSString stringWithFormat:@"%.1f折",discount*10];
    NSString *discounStr = [NSString stringWithFormat:@"%@/%@",discountAttStr,rank];
    self.lDiscount.attributedText = [self titleStr:discounStr attText:discountAttStr attColor:KBGCColor(@"#c4191f") attFont:[UIFont fontWithName:@"HiraKakuProN-W6" size:22]];
    
    [self.numberOfPurchaseView onUpdataAvatar:List];
}


- (NSMutableAttributedString *)titleStr:(NSString *)str attText:(NSString *)changStr attColor:(UIColor *)color attFont:(UIFont *)font{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    
    if (changStr == nil) {
        
        changStr = @" ";
    }
    
    [text setColor:color range:[str rangeOfString:changStr]];
    [text setFont:font range:[str rangeOfString:changStr]];
    
    return text;
}



- (void)updateWithItem:(YCItemDetailM *)item
{
    YCLoginUserM *appUser = item.appUser;
    [self.imgUser yc_setImageWithURL:IMAGE_HOST_NOT_SHOP(appUser.imagePath) placeholder:AVATAR];
    //TODO:显示图片地址方法改了一下
    
    self.lUserName.text = appUser.nickName;
    
    
    NSString *title = item.shopProduct.productName;
    int count = item.gapCount.intValue;
    
    NSString *titleStr = [NSString stringWithFormat:@"发起了%@团拼",title];
    self.lTitle.attributedText = [self titleStr:titleStr attText:title attColor:[UIColor colorWithHexString:@"#c40000"] attFont:[UIFont systemFontOfSize:12]];
    float leftRank = item.nextProductStrategy.discount.floatValue;
    float discount = item.nowProductStrategy.discount.floatValue;
    NSString *rank = item.nowProductStrategy.strategyName;
    
    if (item.nextProductStrategy) {
        NSString *countStr = [NSString stringWithFormat:@"%d",count];
        NSString *countText = [NSString stringWithFormat:@"距离%.1f折还差%@人",leftRank *10,countStr];
        self.lDiscountLeft.attributedText = [self
                                             titleStr:countText attText:countStr attColor:KBGCColor(@"ff4b3a") attFont:KFont(18)];
    } else {
        self.lDiscountLeft.text = @"已达到最高折扣";
    }
    
    NSString *discountAttStr = [NSString stringWithFormat:@"%.1f折",discount*10];
    NSString *discounStr = [NSString stringWithFormat:@"%@/第%@",discountAttStr,rank];
    self.lDiscount.attributedText = [self titleStr:discounStr attText:discountAttStr attColor:KBGCColor(@"#c4191f") attFont:[UIFont fontWithName:@"HiraKakuProN-W6" size:22]];
    
    [self.numberOfPurchaseView onUpdataAvatar:item.shopGroupBuySubs];
}
@end
