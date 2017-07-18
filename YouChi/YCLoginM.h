//
//  YCLoginM.h
//  YouChi
//
//  Created by 李李善 on 15/5/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"

@interface YCLoginUserM : YCBaseImageModel
@property (nonatomic,strong) NSString *loginId,*password,*salt,*token,*email,*phone,*disabledStartTime,*disabledEndTime,*lockedTime,*nickName,*signature,*imageId,*levelName,*currentExp,*userState,*labelId,*sex,*inviteBy,*inviteCode,*lastModifiedBy,*platformId;

@property (nonatomic,strong) NSString *qrcodePath;
@property (nonatomic,strong) NSNumber *isDisabled,*isLocked,*isFollow;
@property (nonatomic,strong) NSNumber *followerCount,*fansCount,*age,*hotGrade,*antCoin,*levelId,*shareCount,*balance;
@property (nonatomic,strong) NSDate *birthDay;
@property (nonatomic,strong) NSArray *cheatsPhotoList;


@property (nonatomic,assign)BOOL isLogin;
@end


@interface YCLoginM : YCBaseModel
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) YCLoginUserM *appUser;
@end

/**
 
 {
 cheatsId = 71;
 createdDate = 1436164914000;
 id = 9;
 imageHeight = 1136;
 imagePath = "/upload/201507/06/small/4a39cd2e5534482187bb63c09d520279.jpg";
 imageWidth = 852;
 status = "<null>";
 
 },
 */