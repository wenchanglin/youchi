//
//  YCSuishoupaiVM.h
//  YouChi
//
//  Created by sam on 15/6/9.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCChihuoyingM.h"
@interface YCRandomPicturesVM : YCPageViewModel
///必要参数
@property (nonatomic,strong) NSString *desc,*materialName,*city;

///可选参数
@property (nonatomic,strong) NSNumber *longitude,*latitude;
@property (nonatomic,strong) NSString *country,*province,*area;


- (RACSignal *)signalUploadWith:(RACSubject *)msg;

@end

