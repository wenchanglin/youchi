//
//  YCSelectCityVM.h
//  YouChi
//
//  Created by sam on 15/10/20.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCRandomPicturesVM.h"


@interface YCSelectCityVM : YCPageViewModel
@property(nonatomic,strong) YCRandomPicturesVM *viewModel;
@property(nonatomic,strong) NSString *selCity;///字符串
@property(nonatomic,strong) RACSubject *selectCity;
-(RACSignal *)signalSearchWithCity:(NSString *)city;
@end
