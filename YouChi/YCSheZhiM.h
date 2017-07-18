//
//  YCSheZhiM.h
//  YouChi
//
//  Created by 李李善 on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"

@interface YCSheZhiM : YCBaseModel
@property (nonatomic,assign) Class pushClass;
+ (YCSheZhiM *)createPushClass:(Class)pushClass;
@end
