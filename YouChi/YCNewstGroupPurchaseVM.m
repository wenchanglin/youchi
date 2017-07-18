//
//  YCNewstGroupPurchaseVM.m
//  YouChi
//
//  Created by 朱国林 on 16/5/12.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouChiShopVC.h"
#import "YCNewstGroupPurchaseVM.h"

@implementation YCNewstGroupPurchaseVM

- (NSInteger)numberOfSections{

    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{

    return self.modelsProxy.count;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{

    return cell0;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCNewstGroupM *m = self.modelsProxy[indexPath.row];
    
    return m.height;

}


- (RACSignal *)mainSignal{

    
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    return [[ENGINE POST_shop_array:@"groupBuy/getNewGroupBuyProductList.json" parameters:param parseClass:[YCNewstGroupM class] pageInfo:self.pageInfo] doNext:^(NSArray<YCNewstGroupM *> *x) {
        
        
        if (self.nextBlock) {
//            NSMutableArray *att = [NSMutableArray new];
//            [att addObjectsFromArray:x];
//            [att addObjectsFromArray:x];
//            [att addObjectsFromArray:x];
//            [att addObjectsFromArray:x];
//            x = att;
            
            [x enumerateObjectsUsingBlock:^(YCNewstGroupM * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
                [m setupModel];
            }];
            
            self.insertBackSection = 0;
            self.nextBlock(x);
            self.pageInfo.loadmoreId = @(0);
            
            
        }
        
    } ];
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{

    YCNewstGroupM *m = self.modelsProxy[indexPath.row];
    
    return m;
}


@end
