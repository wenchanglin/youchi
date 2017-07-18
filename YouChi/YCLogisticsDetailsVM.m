//
//  YCLogisticsDetailsVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLogisticsDetailsVM.h"

@implementation YCLogisticsDetailsVM

-(instancetype)initWithId:(id)aId{
    if (self ==[super initWithId:aId]) {
        
        self.title = @"物流情况";
        self.logisticsS =[NSMutableArray array];
        self.Id = aId;
    }
    return self;
    
}

- (NSInteger)numberOfSections{
    
    return 4;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0 )     return 2;
    else if (section == 1 )return self.Model.shopOrderProducts.count+1;
    else if (section == 2) return self.Model.wuliuJson.count;
    else  return 1;
        
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 )
    {
        if (indexPath.row==0) return cell1;
    }
    else if (indexPath.section==1){
        if (indexPath.row==0) return cell6;
    }
    else if (indexPath.section==2){
        if (self.Model.wuliuJson.count<2) {
              return cell2;
        }
        else{
            if (indexPath.row ==0) {
                return cell2;
            }
           
                if (indexPath.row==self.Model.wuliuJson.count-1){
                    return cell4;
                }
                
                return cell3;
            }
            
        }
    
    else{
        return cell5;
    }
    return cell0;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 )
    {if (indexPath.row==0) return 80.f;;
    }
    else if (indexPath.section==1){
        if (indexPath.row==0) return 91.f;;
    }
    else
    {
        return 80.f;
    }
    
    return 5.f;
}



- (RACSignal *)mainSignal{

    return [[ENGINE POST_shop_array:@"order/getCourierInfoById.json" parameters:@{@"wuliuId":self.Id,kToken:[YCUserDefault currentToken]} parseClass:[YCShopWuliuInfoM class] parseKey:kContent pageInfo:nil]doNext:^(YCShopWuliuInfoM* x){
        self.Model = x;
    }];
    
    
}



-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row != self.Model.shopOrderProducts.count) {
            YCShopOrderProductM *model =self.Model.shopOrderProducts[indexPath.row];
            return model;

        }
    }
   else if(indexPath.section==2){
       return  self.Model.wuliuJson[indexPath.row];
    }
    
    return self.Model;
}

@end
