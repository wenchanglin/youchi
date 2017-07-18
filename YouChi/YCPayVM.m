//
//  YCPayVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPayVM.h"

@implementation YCPayVM
-(instancetype)init{
    if (self==[super init]) {
        self.title = @"充值";
    }
    return self;
}


-(RACSignal *)onPay{
    
    return [[ENGINE POST_shop_object:@"balance/useRechargeCard.json" parameters:@{kToken:[YCUserDefault currentToken],@"rechargeCardNo":self.number} parseClass:[YCLoginUserM class] parseKey:kContent ]doNext:^(YCLoginUserM * x) {
    
//        YCUserDefault *ud = [YCUserDefault standardUserDefaults];
//        YCLoginM *user = [YCUserDefault currentUser];
//        user.appUser.balance = x.balance;
//        [ud saveUser:user];
//        [ud updateCurrentUser:user];
    }];
}

-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.modelsProxy[indexPath.row];
}

@end
