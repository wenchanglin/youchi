//
//  YCYCCreateGroupPurchaseVM.h
//  YouChi
//
//  Created by 李李善 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import <YYKit/YYKit.h>
#import "YCCreateGroupPurchaseM.h"
#import "YCRecipientAddressM.h"
#import "YCGroupPurchaseVM.h"




@interface YCCreateGroupPurchaseVM :YCGroupPurchaseVM
///前一个界面传来的商品策略
PROPERTY_STRONG NSArray *shopProductStrategys;

///是否是支付界面(可取消团拼界面)
@property(nonatomic,assign) BOOL isPayGroup;
/**
 *  编辑开团人字符串
 *
 *  @param number 多少开团人
 *
 *  @return 编辑好的字符串
 */
-(NSMutableAttributedString *)onOpenGroupPeopleWithNumber:(NSInteger)number;
/**
 *  编辑参团人字符串
 *
 *  @param number 多少参团人
 *
 *  @return 编辑好的字符串
 */
-(NSMutableAttributedString *)onJoinPeopleWithNumber:(NSInteger)number;
/**
 *  选择规格网络更新价格
 *
 *  @return 规格价格信号
 */
-(RACSignal *)onSelectSpecChangePrice;


- (instancetype)initWithProductId:(NSNumber *)productId productSpecId:(NSNumber *)productSpecId qty:(NSNumber *)qty;

- (instancetype)initWithProductId:(NSNumber *)productId;
@end
