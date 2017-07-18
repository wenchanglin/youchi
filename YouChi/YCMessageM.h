//
//  YCMessageM.h
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"

@interface YCMessageM : YCBaseImageModel
@property (strong, nonatomic) NSString *img;
@property (strong, nonatomic) NSString *content;
@property (nonatomic,assign) Class pushClass;
+ (YCMessageM *)creatImg:(NSString *)img content:(NSString *)content pushClass:(Class )pushClass;
@end
