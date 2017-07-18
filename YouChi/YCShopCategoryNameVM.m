//
//  YCShopCategoryNameVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopCategoryNameVM.h"
#import "YCShopCategoryM.h"
@implementation YCShopCategoryNameVM
-(instancetype)init{
    if (self==[super init]) {
        self.title = @"品类名称";
    }
    return self;
}

- (RACSignal *)mainSignal
{
    return [self onSearchSignal:self.orderType];
}

- (RACSignal *)onSearchSignal:(NSInteger)orderType{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    if(self.requsetType ==selsectRequsetTypeSub){
       self.urlString = @"product/getProductListByCategorySubId.json";
        [para addEntriesFromDictionary:@{@"categorySubId":self.Id}] ;
    }
    else if(self.requsetType ==selsectRequsetTypeSup)
    {    self.urlString = @"product/getProductListByCategoryParId.json";
        [para addEntriesFromDictionary:@{@"categoryId":self.Id}] ;
    }
    else if (self.requsetType ==selsectRequsetTypeShop){  
        
        self.urlString = @"product/getAllShopProductListByMoneyPay.json";
        [para addEntriesFromDictionary:@{@"categoryId":self.Id}] ;
    }
    
    [para addEntriesFromDictionary:@{@"orderType":@(orderType)}];
    
    
    
    WSELF;
    return [[ENGINE POST_shop_array:self.urlString parameters:para parseClass:[YCShopCategoryM class] pageInfo:self.pageInfo ]doNext:^(NSArray * x) {
        SSELF;
        self.insertBackSection = 0;
        if (self.nextBlock) {
            self.nextBlock(x);
            YCShopCategoryM *m = x.firstObject;
            self.title = m.categorySubName;
        }
        self.pageInfo.loadmoreId = @(0);
        
        
    }];
    
}

@end
