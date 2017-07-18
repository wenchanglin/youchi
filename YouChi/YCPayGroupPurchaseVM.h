//
//  YCPayGroupPurchaseVM.h
//  YouChi
//
//  Created by 李李善 on 16/5/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//


#import "YCGroupPurchaseVM.h"
#import "YCPayGroupPurchaseM.h"
typedef enum : NSUInteger {
    YCGroupPurchaseSponsor,//发起人
    YCGroupPurchaseMember,//团员
} YCGroupPurchase;


@interface YCPayGroupPurchaseVM :YCGroupPurchaseVM
///从统一发货跳转过来的
@property (nonatomic,assign) BOOL isSponsor;
///判断是发起人还是团员
@property(nonatomic,assign) YCGroupPurchase groupPeople;
///model
@property(nonatomic,strong) YCPayGroupPurchaseM *model;

@property (strong,nonatomic) NSString *price;

@property(nonatomic,assign) NSInteger buyCount;

@property(nonatomic,strong)NSNumber * orderId;



/**
 *  催他结算
 
 *  payUserId 对方ID
 
 *  @return 催他结算信号
 */
-(RACSignal *)onUrgePay:(NSNumber *)payUserId groupBuyId:(NSNumber *)groupBuyId ;
-(RACSignal *)onCancelOtherKickUserId:(NSNumber *)userId;



- (void)updataBuyCount;

@end
