//
//  YCMyInitiateGroupPurchaseVM.m
//  YouChi
//
//  Created by 朱国林 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <YYKit/YYKit.h>
#import "YCMyInitiateGroupPurchaseVM.h"

@implementation YCMyInitiateGroupPurchaseVM

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
    
    
    YCMyInitiateGroupM *m = self.modelsProxy[indexPath.row];
    
    return m.height;
}

- (RACSignal *)mainSignal{
    
    
    NSDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   
                                   };
    
    return [[ENGINE POST_shop_array:@"groupBuy/mySponsorGroupBuys.json" parameters:param parseClass:[YCMyInitiateGroupM class] pageInfo:self.pageInfo] doNext:^(id x) {
        
        
        if (self.nextBlock) {
            [x enumerateObjectsUsingBlock:^(YCMyInitiateGroupM * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
                [m setupModel];
            }];
            
            self.insertBackSection = 0;
            self.nextBlock(x);
            self.pageInfo.loadmoreId = @(0);
        }
        
    } ];
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YCMyInitiateGroupM *m = self.modelsProxy[indexPath.row];
    
    return m;
}

@end
