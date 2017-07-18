//
//  YCMeM.h
//  YouChi
//
//  Created by Johnray on 15/6/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"

@interface YCMeM : YCBaseImageModel
@property (nonatomic,strong) NSNumber *age,*antCoin,*birthday,*createdBy,*currentExp,*fansCount,*followerCount,*isFollow,*lastModifiedBy,*lastModifiedDate,*levelId,*loginId,*phone,*sex,*status,*userState,*likeCount;

@property (nonatomic,strong) NSString *deletedBy,*deletedDate,*email,*hotGrade,*labelId,*signature,*nickName,*levelName;
@property (nonatomic,strong) NSString *qrcodePath,*userImage;
@end
