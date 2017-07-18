//
//  YCRefundConditionVM.h
//  YouChi
//
//  Created by 李李善 on 16/1/23.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCMyOrderM.h"
@interface YCRefundConditionVM : YCPageViewModel

///是否是友米兑换
@property(nonatomic,assign) BOOL isYouMi;

///oldModel
@property(nonatomic,strong) YCShopOrderProductM *oldAboutGoodsM;
///NewModel
@property(nonatomic,strong) YCMyOrderM *aboutGoodsM;

///撤销退货申请
- (RACSignal *)onCancelRefundSignal;
- (RACSignal *)onCancelRefundSignalRefundId:(NSInteger)refundId;
@end
