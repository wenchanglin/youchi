//
//  YCGuopinDetailM.h
//  YouChi
//
//  Created by sam on 15/6/12.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import "YCCommentM.h"
@interface YCGuopinDetailM : YCBaseImageModel
@property (nonatomic,strong) NSString *categoryName,*effect,*userName,*levelName,*suitableFor,*difficulty,*nutrition,*taboo,*name;
@property (nonatomic,strong) NSNumber *categoryId,*commentCount,*humidityFlag,*likeCount,*matchCount,*maxSpendTime,*minSpendTime,*isApprovaled,*levelId;
@property (nonatomic,strong) NSURL *userImage;
@property (nonatomic,strong) NSArray *youchiList,*recipeMaterialList,*recipeStepList,*recipeCommentList;
@end


@interface YCGuopinDetailrecipeMaterialListM : YCBaseImageModel
@property (nonatomic,strong) NSString *materialName,*quantity,*userName,*levelName;
@property (nonatomic,strong) NSNumber *seqNo;
@end