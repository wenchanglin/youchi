//
//  YCYouMiExchangePayVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouMiExchangePayVM.h"
#import "YCRecipientAddressM.h"
@implementation YCYouMiExchangePayVM
-(instancetype)initWithModel:(id)aModel{
    if (self==[super initWithModel:aModel]) {
        self.title = @"确认兑换";
        self.AddressModel =aModel;
    }
    return self;
}
-(NSInteger)numberOfSections{
    return 2;
}
-(NSInteger)numberOfItemsInSection:(NSInteger)section{
    if (section==0) return 2.f;
    return 1.f;
}
-(NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return cell0;
        }
        return cell2; // 空格cell
    }
    return cell1;
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 80.f;
        }
        return 5.f;
    }
    return 140.f;
}


/**
 productId	y		long		商品id
 specId	    y		long		商品规格id
 qty	    y		long		数量
 userAddressId y		long		用户地址id
 */
- (RACSignal *)mainSignal{
    
  YCAboutGoodsM*m = self.AddressModel;
    YCRecipientAddressM *mdoel =self.AddressModel.address;
    
    return [ENGINE POST_shop_object:@"pay/antPay.json" parameters:@{@"productId":m.productId,@"specId":m.specId,@"qty":@(1),@"userAddressId":mdoel.userAddressId,kToken:[YCUserDefault currentToken],} parseClass:[YCAboutGoodsM class] parseKey:nil ];
}

-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.AddressModel;
}

@end
