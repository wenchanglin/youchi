//
//  YCGoodsOrderVM.h
//  YouChi
//
//  Created by 朱国林 on 15/11/25.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCAboutGoodsM.h"
#import "YCViewModel.h"
#import "YCAboutGoodsM.h"
#import "Order.h"
#import "YCFixOrderM.h"
#import "YCViewModel+Logic.h"


@interface YCFixOrderVM : YCAutoPageViewModel
@property(nonatomic,strong)YCAboutGoodsM *model;


@property(nonatomic,strong,readonly) NSMutableArray *cartIdArray;
///团拼参数
@property(nonatomic,strong) NSMutableDictionary *param;
///订单种类
@property(nonatomic,assign) YCOrderType orderType;



///预售商品传值
@property(nonatomic,strong)NSNumber *qty;
@property(nonatomic,strong)NSNumber *productSpecId;

@property(nonatomic,assign)BOOL isPresell;

///商品ID数组
@property(nonatomic,strong) NSString *cartIdArrayJson;
@property(nonatomic,assign)YCPayType payType;

@property(nonatomic,assign) NSNumber * productId;
@property (strong,nonatomic) NSString *descriptions;

///地址参数
PROPERTY_STRONG YCRecipientAddressM *address;
///商品购物优惠卷---->从上一个界面传回来
PROPERTY_STRONG YCShopCategoryM *shopCategory;

-(instancetype )initWithCartIdArray:(NSArray<NSNumber *> *)cartIdArray ;

- (instancetype)initWithPresellProductId:(NSNumber *)productId qty:(NSNumber *)qty productSpecId:(NSNumber *)productSpecId;



///提交单
-(RACSignal *)onConfirmOrderSignal;
@end
