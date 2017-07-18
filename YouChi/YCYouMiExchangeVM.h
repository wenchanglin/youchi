//
//  YCYouMiExchangeVM.h
//  YouChi
//
//  Created by 李李善 on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCAboutGoodsM.h"
#import "YCMeM.h"
@interface YCYouMiExchangeVM : YCPageViewModel

///用户信息
@property (nonatomic,strong) YCLoginUserM *appUser;



//-(RACSignal *)onGetMyMoney;
@end
