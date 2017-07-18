//
//  YCSearchDetailVM.h
//  YouChi
//
//  Created by 李李善 on 15/8/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCChihuoyingM.h"
#import "YCWorksOfyouChiVM.h"
@interface YCSearchDetailVM : YCPageViewModel

@property(nonatomic,strong) YCChihuoyingM_1_2 *model;

@property (nonatomic, assign)BOOL isSearch;
@property(nonatomic,strong) NSString * searchText;
- (RACSignal  *)searchText:(NSString *)Text;
@end

@interface YCSearchYouchiVM : YCChihuoyingOtherVM
@property (nonatomic,strong) YCSearchDetailVM *viewModel;
@end
