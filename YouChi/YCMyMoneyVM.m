//
//  YCYouMiExchangeVM.m
//  YouChi
//
//  Created by 李李善 on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyMoneyVM.h"
#import "YCMyMoneyM.h"
#import "YCShopCategoryM.h"

@implementation YCMyMoneyVM
@synthesize appUser;

-(instancetype)init{
    if (self==[super init]) {
        self.title = @"我的余额";
        
       
        
        WSELF;
        [[self.didBecomeActiveSignal filter:^BOOL(id value) {
            return [YCUserDefault standardUserDefaults].isMoneyUserValid;
        }] subscribeNext:^(id x) {
            [self onGetMyMoney];
        }];
        
        [[RACSignal merge:@[RACObserve([YCUserDefault currentUser], appUser),[[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCUserDefaultUpdate object:nil] map:^id(NSNotification  *value) {
            YCLoginM *login = value.object;
            return login.appUser;
        }]]] subscribeNext:^(id x) {
            SSELF;
            self.appUser = x;
        }];
    }
    return self;
}


-(RACSignal *)onGetMyMoney{
  return [[ENGINE POST_shop_object:@"user/getUserInfo.json" parameters:@{kToken:[YCUserDefault currentToken],} parseClass:[YCLoginUserM class] parseKey:kContent ]doNext:^(YCLoginUserM * x) {
        YCUserDefault *ud = [YCUserDefault standardUserDefaults];
        YCLoginM *user = [YCUserDefault currentUser];
        user.appUser.balance = x.balance;
        [ud saveUser:user];
        [ud updateCurrentUser:user];
    }];
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(RACSignal *)mainSignal
{
    return [[ENGINE POST_shop_array:@"balance/getUserBalanceLog.json" parameters:@{kToken:[YCUserDefault currentToken],} parseClass:[YCMyMoneyM class] parseKey:kContent pageInfo:self.pageInfo]doNext:^(NSArray * x) {
       for (YCMyMoneyM *m in x) {
           if (m.actionMoney) {
               if ([m.actionType intValue]==1 ||[m.actionType intValue]==3) {
                   m.money = [NSString stringWithFormat:@"+%@元",m.actionMoney];
               }else{
                   m.money = [NSString stringWithFormat:@"-%@元",m.actionMoney];
               }
           }
       }
       if (super.nextBlock) {
           super.nextBlock(x);
           
       }
   }];
    
    
}


-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [super modelForItemAtIndexPath:indexPath];
}


@end
