//
//  YCPrivateBookingM.h
//  YouChi
//
//  Created by sam on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import "YCChihuoyingM.h"

@class YCPrivateBookinguserStateListM;

@interface YCPrivateBookingM : YCBaseImageModel
@property (nonatomic,strong) NSArray *materials,*userStateList;
@property (nonatomic,strong) NSString *aqi,*humidity,*temperature,*jieqi;
@property (nonatomic,assign) CGFloat cellHeight;
@end


@interface YCPrivateBookinguserStateListM : YCBaseImageModel
@property (nonatomic,strong) NSURL *roundImagePath,*squareImagePath;
@end