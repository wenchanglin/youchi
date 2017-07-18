//
//  YCTicklingVM.h
//  YouChi
//
//  Created by 朱国林 on 15/7/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"

@interface YCTicklingVM : YCViewModel
- (RACSignal *)sendSignal:(NSString *)title advice:(NSString *)advice;

@end
