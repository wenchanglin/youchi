//
//  YCOrderDetailedVM.h
//  YouChi
//
//  Created by 李李善 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import "YCViewModel.h"
#import "YCAboutGoodsM.h"
#import "YCOrderNumView.h"
#import "YCMyOrderVC.h"

@interface YCOrderDetailedVM : YCAutoPageViewModel
@property(nonatomic,strong)YCMyOrderM *model;
@property (nonatomic,strong) NSNumber *orderStateType;
@property (nonatomic,strong) NSNumber *orderSendingState;
@property (nonatomic,strong) NSNumber *orderShippingState;
@property (nonatomic,strong) NSNumber *orderId;

PROPERTY_STRONG RACSubject *orderDetaileUpdateSignal;
-(instancetype)initWithIdx:(NSInteger)aId;
@end
