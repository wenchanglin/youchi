//
//  YCSheZhiVM.h
//  YouChi
//
//  Created by sam on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCLoginM.h"
#import "YCViewModel.h"
#import "YCPersonalProfileVM.h"
@interface YCSettingVM : YCViewModel
///我的主页信息
@property (nonatomic,strong) YCPersonalProfileVM *viewModel;
- (RACSignal *)logoutSignal;
@end
