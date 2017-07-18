//
//  YCSupportGroupPurchaseVM.h
//  YouChi
//
//  Created by 李李善 on 16/5/17.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSupportGroupPurchaseM.h"
#import "YCCreateGroupPurchaseVM.h"
@interface YCSupportGroupPurchaseVM : YCCreateGroupPurchaseVM

@property(nonatomic,strong)NSString * price; // 最低价钱
@property(nonatomic,strong)NSNumber *productId;
/// 计算最低价钱
- (void)updatePrice:(NSInteger ) count;
- (RACSignal *)sponsorGroupBuy;
@end
