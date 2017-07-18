//
//  YCPrivateDetailednessVM.h
//  YouChi
//
//  Created by 李李善 on 15/5/18.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCPrivateDetailednessM.h"
#import "YCPrivateBookingVM.h"
@interface YCPrivateDetailednessVM : YCPageViewModel
@property (nonatomic,strong) RACSignal *userStateSignal;
@property (nonatomic,strong) NSMutableArray *states;
@property (nonatomic,strong) YCPrivateBookingVM *privateBookingVM;

@property (nonatomic,assign) BOOL hasSelected;

- (RACSignal *)updateStateSignal;
@end
