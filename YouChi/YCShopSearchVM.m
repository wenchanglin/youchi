//
//  YCShopSearchVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopSearchVM.h"

@implementation YCShopSearchVM

-(NSInteger)numberOfItemsInSection:(NSInteger)section{
    
     return (self.modelsProxy.count>0)?self.modelsProxy.count:0;
}
-(NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    return cell0;
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.modelsProxy[indexPath.row];
}
- (RACSignal *)onSearchSignal:(NSInteger)orderType
{
    NSMutableDictionary *para = [NSMutableDictionary new];
    if (self.searchText.length>0) {
        [para addEntriesFromDictionary:@{@"productName":self.searchText}] ;
    }
    
    [para addEntriesFromDictionary:@{@"orderType":@(orderType)}];

    WSELF;
    return [[ENGINE POST_shop_array:@"product/searchProductByName.json" parameters:para parseClass:[YCShopCategoryM class] parseKey:kContent pageInfo:self.pageInfo]doNext:^(NSArray * x) {
        SSELF;
        
        for (YCShopCategoryM  * m in x) {
            YCShopCategorySubsM *smalModel = (id)m.shopKeyword;
            m.keyword =smalModel.keyword;
        }

        
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];
    
}

@end
