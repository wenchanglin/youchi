//
//  YCPeesonalProfileVM.m
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPersonalProfileVM.h"
#import "YCMessageVC.h"
#import "YCWebVC.h"
#import "YCTicklingVC.h"
#import "YCErweimaVC.h"
#import "YCPrivateBookingVC.h"
#import "YCMyWorksVC.h"
#import "YCMyCollectionVC.h"

#import "YCAboutYouChiVC.h"
#import "YCMyCartVC.h"
#import "YCMyOrderVC.h"
#import "YCMyCouponVC.h"
@implementation YCPersonalProfileVM

#pragma mark -
- (void)dealloc{
    //OK
}
- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.modelsProxy = @[
                             [YCPersonalProfileM create:@"我的购物车" :@"我的购物车" :[YCMyCartVC class]],
                             [YCPersonalProfileM create:@"我的订单" :@"我的订单" :[YCMyOrderVC class]],
                             [YCPersonalProfileM create:@"我的优惠劵" :@"我的优惠券" :[YCMyCouponVC class]],
                             [YCPersonalProfileM create:@"签到" :@"签到" :Nil],
                             [YCPersonalProfileM create:@"我的作品" :@"我的分享" :[YCMyWorksVC class]],
                             [YCPersonalProfileM create:@"我的收藏" :@"我的收藏" :[YCMyCollectionVC class]],
                             [YCPersonalProfileM create:@"扫一扫" :@"扫一扫我的" :[YCErweimaVC class]],
                             [YCPersonalProfileM create:@"致富秘籍" :@"致富秘籍" :[YCWebVC class]],
                             [YCPersonalProfileM create:@"意见反馈" :@"意见反馈" :[YCTicklingVC class]],
                             [YCPersonalProfileM create:@"邀请用户获得现金劵" :@"邀请好友" :[YCWebVC class]],
                             [YCPersonalProfileM create:@"关于我们" :@"关于我们" :[YCAboutYouChiVC class]],
                             ].mutableCopy;
    }
    

    RAC(self,appUser) = [[self.didBecomeActiveSignal filter:^BOOL(id value) {
        return [YCUserDefault standardUserDefaults].isCurrentUserValid;
    }] flattenMap:^RACStream *(id value) {
        return [[ENGINE POST_shop_object:apiGCurrentUserInfo  parameters:@{kToken:[YCUserDefault currentToken]} parseClass:[YCLoginUserM class] parseKey:nil]catchTo:[RACSignal empty]];
    }];
    self.appUser = [YCUserDefault currentUser].appUser;

    return self;
}


#pragma mark -


- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    return cell1;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

#pragma mark -签到
- (RACSignal *)signalSignup
{
    return [ENGINE POSTBool:apiGSignup  parameters:@{kToken:[YCUserDefault currentToken]}];
}
@end
