//
//  YCPurchaseQrCodeVM.m
//  YouChi
//
//  Created by 朱国林 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPurchaseQrCodeVM.h"

@implementation YCPurchaseQrCodeVM
@synthesize model;

- (NSInteger)numberOfSections{
    
    return self.model?3:0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 2;
    }
    
    return 1;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            return cell1;
        }
    }
    
    if (indexPath.section == 1) {
        
        
        return cell3;
        
    }
    
    if (indexPath.section == 2) {
        
        return cell2;
    }
    
    return cell0;
        
    
    
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
    
        if (indexPath.row == 1) {
            
            return 8;
        }
        
        return 208;
    }
    
    if (indexPath.section == 1) {
        
        return 138;
    }
    
    return 300;
}


- (RACSignal *)mainSignal{
    
    
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   @"groupBuyId":self.Id,
                                   }.mutableCopy;
    
    return [[ENGINE POST_shop:@"groupBuy/inviteJoinGroupBuy.json" parameters:param parseClass:[YCGroupQrCodeM class] parseKey:nil pageInfo:nil] doNext:^(YCGroupQrCodeM *x) {
        
        self.model = x;
        self.model.addStr = [NSString stringWithFormat:@"%@%@%@",x.shopUserAddress.provinceName,x.shopUserAddress.cityName,x.shopUserAddress.townName];
    } ];
}


- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return self.model;
}

@end
