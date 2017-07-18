//
//  YCYouMiExchangeVM.h
//  YouChi
//
//  Created by 李李善 on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//


#import "YCYouMiExchangeVM.h"
#import "YCLoginM.h"
@interface YCMyMoneyVM : YCYouMiExchangeVM
///用户信息
@property (nonatomic,strong) YCLoginUserM *appUser;

-(RACSignal *)onGetMyMoney;


@end
