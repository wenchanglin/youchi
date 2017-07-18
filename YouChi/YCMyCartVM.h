//
//  YCMyCartVM.h
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCAboutGoodsM.h"

@interface YCMyCartVM : YCPageViewModel

@property(strong,nonatomic)NSString *totalPrice;  // 总价钱 会变动 监听该属性
@property(assign,nonatomic)BOOL isAllSelected;    // 监听结算栏的全算按钮
@property(assign,nonatomic)BOOL isAllGoodsSelected;    // 监听商品是否全选
@property(strong,nonatomic)YCAboutGoodsM *model;  // 用于全选时记录的价钱


///商品ID数组
@property(nonatomic,strong) NSMutableArray *CartIds;



- (RACSignal *)updateMyCartWithProductId:(NSNumber *)productId productSpecId:(NSNumber *)productSpecId count:(NSNumber *) count;

@end
