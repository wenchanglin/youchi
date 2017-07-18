//
//  YCGroupSettlementView.h
//  YouChi
//
//  Created by ant on 16/5/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved. specifi  YCGroupPayState
//
#import <YYKit/YYKit.h>
#import "Masonry.h"
#import "YCView.h"
#import <UIKit/UIKit.h>
#import "YCDefines.h"

/// 结算View
@interface YCGroupSettlementView : UIView
@property(nonatomic,strong)UIImageView *imgUser;
@property(nonatomic,strong)UILabel *lUserName;
@property(nonatomic,strong)UILabel *lSymbol;
@property(nonatomic,strong)UILabel *lPrice;
@property(nonatomic,strong)UILabel *lSpe;
@property(nonatomic,strong)UILabel *lCount;
@property(nonatomic,strong)UIButton *bPay;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,assign) YCGroupPayState groupPayState;
/**
 * userImg 用户图片
 * name 名字
 * price 价钱
 * spe 规格
 * count 数量
 * groupPayState 支付状态
 **/
- (void)onUpdataUserImg:(NSString *)userImg userName:(NSString *)name price:(float)price spe:(NSString *)spe count:(int)count groupPayState:(YCGroupPayState) groupPayState;
@end
