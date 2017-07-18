//
//  YCPersonalProfileM.h
//  YouChi
//
//  Created by sam on 15/5/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"

@interface YCPersonalProfileM : YCBaseModel
@property (nonatomic,assign) BOOL isMyProfile;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,assign) Class pushClass;
+ (YCPersonalProfileM *)create:(NSString *)title :(NSString *)image :(Class )pushClass;
@end
