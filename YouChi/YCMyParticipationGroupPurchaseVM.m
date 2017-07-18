//
//  YCMyParticipationGroupPurchaseVM.m
//  YouChi
//
//  Created by 朱国林 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved. groupBuy/myJoinGroupBuys.json
//
#import <YYKit/YYKit.h>
#import "YCMyParticipationGroupPurchaseVM.h"

@implementation YCMyParticipationGroupPurchaseVM


- (NSInteger)numberOfSections{
    
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    
    return self.modelsProxy.count;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell0;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    YCMyInitiateGroupM *m = self.modelsProxy[indexPath.row];
    return m.height;
}


- (RACSignal *)mainSignal{
    
    
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   
                                   }.mutableCopy;
    
    return [[ENGINE POST_shop_array:@"groupBuy/myJoinGroupBuys.json" parameters:param parseClass:[YCMyParticipationGroupM class] pageInfo:self.pageInfo] doNext:^(id x) {
        
        if (self.nextBlock) {
            
            for (YCMyParticipationGroupM *m in x) {
                
                [m setupModel];
                
            }
            
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
