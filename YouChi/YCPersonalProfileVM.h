//
//  YCPeesonalProfileVM.h
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCPersonalProfileM.h"
#import "YCLoginM.h"
#import "YCFollowsM.h"
@interface YCPersonalProfileVM : YCPageViewModel
@property (nonatomic,strong) YCLoginUserM *appUser; ///用户信息
- (RACSignal *)signalSignup;
@end




