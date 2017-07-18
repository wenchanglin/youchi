//
//  YCShopCategoryNameVM.h
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopSearchVM.h"
typedef enum {
    selsectRequsetTypeSub,///子
    selsectRequsetTypeSup,///父
    selsectRequsetTypeShop,///商城跳转过来
    
}selsectRequsetType;

@interface YCShopCategoryNameVM : YCShopSearchVM
///请求方式
@property(nonatomic,assign) selsectRequsetType requsetType;
///
@property(nonatomic,assign) NSInteger  orderType;

- (RACSignal *)onSearchSignal:(NSInteger)orderType;

@end
