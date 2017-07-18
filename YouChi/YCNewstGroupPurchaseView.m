//
//  YCNewstGroupPurchaseView.m
//  YouChi
//
//  Created by 朱国林 on 16/5/12.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <YYKit/YYKit.h>
#import "YCNewstGroupPurchaseView.h"
#import "YCView.h"

@implementation YCGroupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        WSELF;
        _groupPurchaseImage = [YCView newInSuperView:self];
        CALayer *redLine = [CALayer new];
        [self.layer addSublayer:redLine];
        
        _groupPurchaseNum = (id)[YYLabel newInSuperView:_groupPurchaseImage];
        
        YCView *v1 = [YCView newInSuperView:self];
        _lName = (id)[YYLabel newInSuperView:v1];
        _lOriginalpricel = (id)[UILabel newInSuperView:v1];
        
        _lBrief = [YYLabel newInSuperView:self];
        
        redLine.backgroundColor = [UIColor colorWithHexString:@"#A71F24"].CGColor;
        
        [_groupPurchaseImage setLayoutBlock:^(YCView *__weak view, CGRect frame) {
            SSELF;
            self.groupPurchaseNum.frame = frame;
            self.groupPurchaseNum.width = frame.size.width/ 3;
            self.groupPurchaseNum.height = 25;
            self.groupPurchaseNum.top = 1;
            self.groupPurchaseNum.right = view.right-1;
            
            redLine.frame = frame;
            redLine.height = 5;
            redLine.bottom = view.bottom;
            
        }];
        
        [v1 setLayoutBlock:^(YCView *__weak view, CGRect frame) {
            SSELF;
            self.lName.frame = frame;
            self.lOriginalpricel.frame = frame;
            
            [self.lOriginalpricel sizeToFit];
            self.lOriginalpricel.right = view.right;
            self.lOriginalpricel.centerY = frame.size.height/2;
            
            self.lName.width = frame.size.width - self.lOriginalpricel.width;
        }];
    }
    return self;
}

- (void)yc_initView
{
    self.borderWidth = 1;
    self.borderColor = [UIColor colorWithHexString:@"#b6b6b6"];
    
    _groupPurchaseImage.contentMode = UIViewContentModeScaleAspectFill;
    
    _groupPurchaseNum.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    _lName.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _lName.text = @"";
    _lBrief.numberOfLines = 0 ;
}
@end


@implementation YCNewstGroupPurchaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc{
    //    ok
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bOpenGroup = [UIButton newInSuperView:self];

        
    }
    return self;
}

- (void)yc_initView
{
    [super yc_initView];
    
    [_bOpenGroup setTitle:@"确认开团" forState:UIControlStateNormal];
    _bOpenGroup.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bOpenGroup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bOpenGroup setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F24941"]] forState:UIControlStateNormal];
    _bOpenGroup.cornerRadius = 2.f;
    
    #pragma mark --约束自下往上
   
}


- (void)updateWithLastestGroupon:(YCNewstGroupM *)m
{
    WSELF;
    //[self.groupPurchaseImage ycShop_setImageWithURL:m.imagePath placeholder:PLACE_HOLDER];
    [self.groupPurchaseImage.layer setImageWithURL:IMAGE_HOST_SHOP(m.imagePath) placeholder:PLACE_HOLDER options:YYWebImageOptionSetImageWithFadeAnimation manager:nil progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        
        SSELF;
        CGSize size = self.groupPurchaseImage.size;
        return [image imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];
    } completion:nil];
    
    self.groupPurchaseNum.attributedText = m.groupCountAttr;
    
    self.lName.text = m.productName;
    
    self.lOriginalpricel.attributedText = m.priceAttr;
    
    self.lBrief.textLayout = m.briefLayout;
    
    [self updateWithlinearInfoManager:m.infoMgr];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bOpenGroup.frame = UIEdgeInsetsInsetRect(self.bOpenGroup.frame, UIEdgeInsetsMake(0, 5, 8, 5));
}
@end

@implementation YCMyGroupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bQrCode = [UIButton newInSuperView:self];
        _bInitiatePay = [UIButton newInSuperView:self];
    }
    return self;
}

- (void)yc_initView
{
    [super yc_initView];
    _bInitiatePay.titleLabel.font = [UIFont systemFontOfSize:15];
    _bInitiatePay.cornerRadius = 2.f;
    [_bInitiatePay setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f24941"]] forState:UIControlStateNormal];
    [_bInitiatePay setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    _bInitiatePay.userInteractionEnabled = NO;
    
    [_bQrCode setTitle:@"团拼二维码，邀请小伙伴们扫码参与" forState:UIControlStateNormal];
    _bQrCode.titleLabel.font = [UIFont systemFontOfSize:15];
//    _bQrCode.cornerRadius = 2.f;
//    _bQrCode.borderColor = [UIColor colorWithHexString:@"#d9d9d9"];
//    _bQrCode.borderWidth = 0.8;
    [_bQrCode setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d8b76a"]] forState:UIControlStateNormal];
    [_bInitiatePay setTitle:@"我要买单" forState:UIControlStateNormal];
}

- (void)updateWithLastestGroupon:(YCMyInitiateGroupM *)m
{
    WSELF;
    //[self.groupPurchaseImage ycShop_setImageWithURL:m.shopProduct.imagePath placeholder:PLACE_HOLDER];
    [self.groupPurchaseImage.layer setImageWithURL:IMAGE_HOST_SHOP(m.shopProduct.imagePath) placeholder:PLACE_HOLDER options:YYWebImageOptionSetImageWithFadeAnimation manager:nil progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        
        SSELF;
        CGSize size = self.groupPurchaseImage.size;
        return [image imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];
    } completion:nil];
    self.groupPurchaseNum.attributedText = m.groupCountAttr;
    
    self.lName.text = m.shopProduct.productName;
    self.lOriginalpricel.attributedText = m.priceAttr;
    
    self.lBrief.textLayout = m.briefLayout;
    
    ///是否可以发起买单
    self.bInitiatePay.enabled = m.isEnough.boolValue;
    
    int lack = m.nowProductStrategy.gteCount.intValue - m.joinCount.intValue;
    if (lack>0) {
        [_bInitiatePay setTitle:[NSString stringWithFormat:@"还差%d人才能结算",lack] forState:UIControlStateDisabled];
    } else {
        [_bInitiatePay setTitle:@"已达到最大折扣" forState:UIControlStateDisabled];
    }
    
    [self updateWithlinearInfoManager:m.infoMgr];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 5, 8, 5);
    self.bQrCode.frame = UIEdgeInsetsInsetRect(self.bQrCode.frame, insets);
    self.bInitiatePay.frame = UIEdgeInsetsInsetRect(self.bInitiatePay.frame, insets);
}

@end

@implementation YCMyParticipationGroupView
{
    CALayer *line;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _numberOfPurchase = [YCNumberOfPurchaseView newInSuperView:self];
        line = [CALayer new];
        [_numberOfPurchase.layer addSublayer:line];
        line.backgroundColor = [UIColor lightGrayColor].CGColor;
        
        line.height = 1;
    }
    return self;
}

- (void)yc_initView
{
    [super yc_initView];
    [self.bInitiatePay setTitle:@"退出团拼" forState:UIControlStateNormal];
    self.bInitiatePay.userInteractionEnabled = YES;
    [_numberOfPurchase yc_initView];
}

- (void)updateWithLastestGroupon:(YCMyInitiateGroupM *)m
{
    [super updateWithLastestGroupon:m];
    [_numberOfPurchase onUpdataAvatar:m.shopGroupBuySubs];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    line.width = self.bounds.size.width;

}
@end