//
//  YCPurchaseInfoView.h
//  YouChi
//
//  Created by 朱国林 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCNumberOfPurchaseView.h"
#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import "Masonry.h"
#import "YCMyInitiateGroupM.h"
#import "YCItemDetailM.h"

/// 扫一扫界面用户View,发起了。。。团拼，距离。。。还差。。。人，。。。折／。。。级优惠
@interface YCPurchaseInfoView : UIView

/// 用户头像
@property(nonatomic,strong)UIImageView *imgUser;
/// 用户名字
@property(nonatomic,strong)UILabel *lUserName;
/// 团拼名称图标
@property(nonatomic,strong)UIImageView *imgIconTitle;
/// 团拼产品名称
@property(nonatomic,strong)UILabel *lTitle;
/// 打折图标
@property(nonatomic,strong)UIImageView *imgDiscountIcon;
/// 打折还差几人
@property(nonatomic,strong)UILabel *lDiscountLeft;
/// 团拼打折/第2级优惠
@property(nonatomic,strong)UILabel *lDiscount;
/// 分割线
@property(nonatomic,strong)UIView *line;
/// 参与人数View
@property(nonatomic,strong)YCNumberOfPurchaseView *numberOfPurchaseView;


/**
 * imgUser 用户头像
 * userName 用户名字
 * title 团拼产品名称
 * count 打折还差几人
 * List  参与人数
 * how 几折
 * rank 几级
 **/

-(void)onUpdataImgUser:(NSString *)imgUser userName:(NSString *)userName title:(NSString *)title discountLeftCount:(int)count discount:(float) how rank:(NSString*) rank numberOfPurchaseList:(NSArray *)List;

-(void)onUpdataImgUser:(NSString *)imgUser userName:(NSString *)userName title:(NSString *)title discountLeftCount:(int)count leftRank:(float)leftRank discount:(float) how rank:(NSString*) rank numberOfPurchaseList:(NSArray *)List;

/**
 * imgUser 用户头像
 * userName 用户名字
 * title 团拼产品名称
 * gapCount 打折还差几人
 * List  参与人数
 * nowM 本级折扣
 * nextM 下级折扣
 **/

- (void)onUpdataImgUser:(NSString *)imgUser userName:(NSString *)userName title:(NSString *)title gapCount:(int)gapCount nowDiscount:(YCNowProductStrategyM *)nowM nextDiscount:(YCNowProductStrategyM *)nextM numberOfPurchaseList:(NSArray *)List;

///传入团拼model
- (void)updateWithItem:(YCItemDetailM *)item;
@end
