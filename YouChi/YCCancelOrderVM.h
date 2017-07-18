//
//  YCCancelOrderVM.h
//  YouChi
//
//  Created by 朱国林 on 16/2/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import "YCViewModel.h"
#import "YCAboutGoodsM.h"

@interface YCCancelOrderVM : YCPageViewModel
@property(strong,nonatomic)YCMyOrderM *model;
@property(strong,nonatomic)NSNumber *orderId;
PROPERTY_STRONG RACSubject *cancelOrderUpdateSignal;
@end
