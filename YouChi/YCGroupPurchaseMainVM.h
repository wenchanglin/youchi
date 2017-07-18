//
//  YCGroupPurchaseMainVM.h
//  YouChi
//
//  Created by 李李善 on 16/5/14.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCPayGroupPurchaseM.h"

#import <YYKit/YYKit.h>
#import "YCGroupPurchaseMainM.h"
#import "YCRecipientAddressM.h"
#import "YCViewModel.h"
#import "YCCreateGroupPurchaseVM.h"


///------------
/// 宏的定义
///------------
#define YCCreateGroupTop 8

@interface YCGroupPurchaseMainVM : YCCreateGroupPurchaseVM
///是否我点进来发起的
@property(nonatomic,assign)BOOL isSponsor;
@property(nonatomic,assign)BOOL isQrCode;
@property (strong,nonatomic) NSString *price;
@property(nonatomic,strong)NSNumber * orderId;

/**
 *  model
 */
//@property(nonatomic,strong) YCGroupPurchaseMainM *model;


/**
 *  解散团拼
 *
 *  @return 解散信号
 */
-(RACSignal *)ondissolveGroupBuy;
/**
 *  结算前 ，修改发货地址
 *
 *  @return 修改发货地址信号
 */
-(RACSignal *)onModifyGroupBuyAddress;

- (RACSignal *)joinGroup;


@end
