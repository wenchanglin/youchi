//
//  YCYouMiExchangeVM.m
//  YouChi
//
//  Created by 李李善 on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouMiExchangeVM.h"

@implementation YCYouMiExchangeVM
-(instancetype)init{
    if (self==[super init]) {
        self.title = @"友米兑换";
        
        WSELF;
        [[self.didBecomeActiveSignal filter:^BOOL(id value) {
            return [YCUserDefault standardUserDefaults].isMoneyUserValid;
        }] subscribeNext:^(id x) {
            [[ENGINE POST_shop_object:@"user/getUserInfo.json" parameters:@{kToken:[YCUserDefault currentToken],} parseClass:[YCLoginUserM class] parseKey:kContent]subscribeNext:^(YCLoginUserM * x) {
                self.appUser = x;
            }];
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



-(NSInteger)numberOfItemsInSection:(NSInteger)section{
    return (self.modelsProxy.count>0)?self.modelsProxy.count:0;
}
-(NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    return cell0;
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 168.f;
}

-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.modelsProxy[indexPath.row];
}

-(RACSignal *)mainSignal
{
    return [[ENGINE POST_shop_array:@"product/getYoumiProductList.json" parameters:@{kToken:[YCUserDefault currentToken],} parseClass:[YCAboutGoodsM class] pageInfo:self.pageInfo]doNext:^(id x) {
       
       
       if (self.nextBlock) {
           self.nextBlock(x);
           self.pageInfo.loadmoreId = @(0);
       }
   }];
}



@end
