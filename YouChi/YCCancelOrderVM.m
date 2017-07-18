//
//  YCCancelOrderVM.m
//  YouChi
//
//  Created by 朱国林 on 16/2/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCancelOrderVM.h"

@implementation YCCancelOrderVM
@synthesize model;

GETTER_LAZY_SUBJECT(cancelOrderUpdateSignal);

-(instancetype)initWithModel:(id)aModel{
    if (self ==[super initWithModel:aModel]) {
    
        self.model = aModel;
        self.orderId = self.model.orderId;
    
    }
    return self;
}


- (NSInteger)numberOfSections{
    
    return self.model?4:0;;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{


    if (section == 1) {
        return self.model.shopOrderProducts.count;
    }
    
    return 1;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
    
        return 162.;
    }else if (indexPath.section == 2){
    
        return 121;
    }else
        
        return 37;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return cell0;
    }else if (indexPath.section == 1){
    
        return cell1;
    }else if (indexPath.section == 2){
    
        return cell2;
    }else
        return cell3;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return self.model;
    }
        
//    return m;
    return self.model.shopOrderProducts[indexPath.row];
}

@end
