//
//  YCItemDetailVM.h
//  YouChi
//
//  Created by sam on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import "YCViewModel.h"
#import "YCItemDetailM.h"
#import <YYKit/YYKit.h>
#import "YCRecipientAddressVM.h"



@interface YCItemDetailVM : YCAutoPageViewModel

@property (nonatomic,strong) YCItemDetailM *model;

///友米兑换
@property(nonatomic,strong) YCShopOrderProductM *youMiModel;
///是否选择了规格“”
@property (nonatomic,assign) NSUInteger selectedshopSpecIndex;

///预售商品
@property(nonatomic,assign,readonly) BOOL isPresell;
///选择商品数量
@property(nonatomic,assign) NSInteger count;
///所有商品数量
@property(nonatomic,assign,readonly) NSInteger sum;

///规格ID
@property(nonatomic,strong,readonly) NSNumber *specId;

@property(nonatomic,assign,readonly) BOOL isYoumiPay;

@property(nonatomic,strong,readonly) NSString *videoPath;
/**
 *  商品图片排序
 *
 *  @param Images 图片数组
 */
-(void)onSequenceShopProductImages:(NSArray *)images;
/**
 *  编辑数组（包含配送地区和商品评价）
 *
 *  @param shopShipping 商品配送对象
 *  @param count        商品评论数
 *
 *  @return 数组
 */
-(NSArray *)onShopShipping:(YCShopSpecs*)shopShipping ShopComment:(int)count;


- (void)updateSelectCount;
- (RACSignal *)cartNumberSignal;
- (RACSignal *)presellSignal;

@end
