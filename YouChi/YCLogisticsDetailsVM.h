//
//  YCLogisticsDetailsVM.h
//  YouChi
//
//  Created by 李李善 on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCMyOrderM.h"
@interface YCLogisticsDetailsVM : YCPageViewModel

///是否是友米兑换
@property(nonatomic,assign) int isYouMi;
///物流数组
@property(nonatomic,strong) NSMutableArray  *logisticsS;

///model
@property(nonatomic,strong) YCShopWuliuInfoM *Model;


@end
