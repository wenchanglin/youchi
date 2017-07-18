//
//  YCJuBaoVM.h
//  YouChi
//
//  Created by 李李善 on 15/6/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCChihuoyingM.h"
@interface YCAccusationVM: YCPageViewModel
@property (strong, nonatomic) NSAttributedString *name;
@property (strong, nonatomic) NSAttributedString *info;

@property(nonatomic,strong)YCChihuoyingM_1_2 * model;
@property(nonatomic,strong)NSMutableArray *reports;
- (RACSignal *)onJuBaoSignal:(NSArray *)reports;

@end
