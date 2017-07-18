//
//  YCMyCouponCell.m
//  YouChi
//
//  Created by 朱国林 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyCouponCell.h"
#import <Masonry/Masonry.h>
#import "YCMarcros.h"
#import "YCShopCategoryM.h"
#import "YCAboutGoodsM.h"
#import "YCView.h"
@implementation YCMyCouponCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//        是否领取完 true=已领完 false=未领完
//        是否已领取 true=当前用户已领取 false=当前用户未领取
//         当优惠卷全部领取完，用户没有优惠卷领取了
- (void)update:(id)model atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *btnTitle;
    NSString *title;
    NSString *imagPatn;
    ///友米兑换
    if (self.btnType == buttonTypeExchangeYouMi) {
        
        YCAboutGoodsM * m = model;
        btnTitle = @"兑现商品";
        imagPatn =m.imagePath;
        YCShopSpecM *model =m.shopSpecs.firstObject;
        CGFloat much =model.antPrice.floatValue;
        title= [NSString stringWithFormat:@"%.1f",much];
        
    }
    ///最新优惠卷和用户领取
    else{
        YCShopCategoryM * m = model;
        ///当是最新优惠卷的时候
        if (self.btnType ==buttonTypeCouponNewCoupon) {
            self.imgLabel.hidden = YES;
            
            if (m.isEnd.boolValue || (m.isEnd.boolValue &&m.isReceived.boolValue)) {
                self.btnChoose.enabled=NO;
                self.blackView.hidden = NO;
                btnTitle =@"已被抢完";
                [self.btnChoose setBackgroundColor:[UIColor grayColor]];
                
            }else if ( (!m.isEnd.boolValue) && m.isReceived.boolValue){
                
                self.btnChoose.enabled=NO;
                self.blackView.hidden = NO;
                btnTitle =@"已领取";
                [self.btnChoose setBackgroundColor:[UIColor grayColor]];
            }
            
            else{
                self.btnChoose.enabled=YES;
                self.blackView.hidden = YES;
                btnTitle =@"获取优惠劵";
                [self.btnChoose setBackgroundColor:color_btnGold];
            }
        }
        ///当是已领取优惠卷的时候
        else{
            UIImage *image;
            self.imgLabel.hidden = NO;
            if (m.isExpired.boolValue) {
                self.blackView.hidden = NO;
                btnTitle = @"已过期";
                image = IMAGE(@"已过期");
                [self.btnChoose setBackgroundColor:color_btnGold];
            }
            
            else if (m.isUsed.boolValue){
                self.blackView.hidden = NO;
                btnTitle =@"已使用";
                image = IMAGE(@"已使用");
                [self.btnChoose setBackgroundColor:color_btnGold];
            }else if (!m.isUsed.boolValue && !m.isExpired.boolValue){
                self.blackView.hidden = YES;
                btnTitle =@"可使用";
                image = IMAGE(@"未使用");
                [self.btnChoose setBackgroundColor:color_btnGold];
                
            }
            
            [self.btnChoose setTitleColor:KBGCColor(@"ffffff") forState:UIControlStateNormal];
            self.imgLabel.image  =image;
            self.btnChoose.enabled=NO;
            
            self.btnChoose.hidden = YES;
        }
        
        imagPatn = m.couponImagePath;
        if (!m.validDate) {
            m.validDate = @"";
        }
        title = [NSString stringWithFormat:@"有效期%@",m.validDate];
        
        
    }
    
    
    self.lTime.text = title;
    
    [self.imgCoupon ycShop_setImageWithURL:imagPatn placeholder:PLACE_HOLDER];
    [self.btnChoose setTitle:btnTitle forState:UIControlStateNormal];
    
}
//

-(void)setIsCoupon:(BOOL)isCoupon{
    if (_isCoupon != isCoupon) {
        _isCoupon = isCoupon;
        self.imgLabel.hidden = _isCoupon;
    }
    
}


@end
