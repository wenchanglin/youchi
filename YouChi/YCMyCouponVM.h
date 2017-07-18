//
//  YCMyCouponVM.h
//  YouChi
//
//  Created by 朱国林 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCMyOrderVM.h"
#import "YCShopCategoryM.h"
@interface YCMyCouponVM : YCPageViewModel
///选择哪个接口
@property(nonatomic,assign) NSInteger selectRequest;
///数组接口
@property(nonatomic,strong) NSArray *requestS;


-(RACSignal *)onReceiveCouPon:(NSNumber *)couPonId;
@end
