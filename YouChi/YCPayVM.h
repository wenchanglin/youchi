//
//  YCPayVM.h
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"

@interface YCPayVM : YCPageViewModel
///充值号码
@property(nonatomic,strong) NSString *number;
-(RACSignal *)onPay;
@end
