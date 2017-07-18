//
//  YCMyOrderVM.h
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import "YCViewModel.h"
#import "YCViewModel+Logic.h"
@interface YCMyOrderVM : YCPageViewModel
///商品ID数组
@property(nonatomic,strong) NSMutableArray *CartIds;
@property(nonatomic,assign)NSInteger integer;
-(instancetype)initWithIdx:(NSInteger)aId;

/// 马上支付
- (RACSignal *)onConfirmOrderSignal:(NSNumber *)orderId;
@end
