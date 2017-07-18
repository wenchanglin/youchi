//
//  YCMyInitiateGroupPurchaseView.h
//  YouChi
//
//  Created by 朱国林 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <YYKit/YYKit.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "YCMyInitiateGroupM.h"

/// 我发起的团拼View
@interface YCMyInitiateGroupPurchaseView : UIView


/// 团拼图片
@property(nonatomic,strong)UIImageView *imgGroupPurchase;
/// 团拼人数
@property(nonatomic,strong)YYLabel *lGroupPurchaseNum;
/// 団拼名称
@property(nonatomic,strong)UILabel *lName;
/// 团拼打折/第2级优惠
@property(nonatomic,strong)UILabel *lDiscount;
/// 打折图标
@property(nonatomic,strong)UIImageView *imgDiscountIcon;
/// 打折还差几人
@property(nonatomic,strong)UILabel *lDiscountLeft;
/// 团拼3人起团
@property(nonatomic,strong)UILabel *lInitialNum;
/// 団拼图标
@property(nonatomic,strong)UIImageView *imgGroupIcon;
/// 扫码
@property(nonatomic,strong)UIButton *bQrCode;
/// 发起买单
@property(nonatomic,strong)UIButton *bInitiatePay;

@property(nonatomic,strong)UIView *redLine;

@property(nonatomic,assign)BOOL isMyJoin;

/**
 * img 图片
 * count 団拼人数
 * name 団拼产品
 * leftCount 还差几人
 * how 几折
 * nextDiscount 下一级优惠
 */

//-(void)onUpdataImgGroupPurchase:(NSURL *)img count:(int) count name:(NSString *)name discountCountLeft:(int) leftCount discount:(float) how nextDiscount:(float) nextDiscount;

- (void)onUpdataInitiateGroup:(YCMyInitiateGroupM *)m;

@end
