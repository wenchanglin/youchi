//
//  YCRegisterVM.h
//  YouChi
//
//  Created by 李李善 on 15/5/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"

@interface YCRegisterVM : YCPageViewModel
@property (nonatomic,strong) NSString *loginId,*smsCode,*password;
@property (nonatomic,assign) BOOL isCodeValid;
- (RACSignal *)registerAndLoginSignal;
- (RACSignal *)getSmsCodeSignal;
//- (RACSignal *)checkSmsCodeSignal;
@end
