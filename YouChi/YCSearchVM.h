//
//  YCSearchVM.h
//  YouChi
//
//  Created by 李李善 on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCSearchM.h"
@interface YCSearchVM : YCPageViewModel
@property(nonatomic,strong) NSMutableArray  *historyArrs;
@property(nonatomic,strong) NSString  *searchText;
- (void)onSearch:(NSString *)search;
- (void)saveSearchHistory;
@end
