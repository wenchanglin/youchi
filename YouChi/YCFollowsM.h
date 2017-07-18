//
//  YCGuanZhuM.h
//  YouChi
//
//  Created by 李李善 on 15/6/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCModel.h"
#import "YCLoginM.h"
@interface YCFollowsM : YCBaseModel

@property (nonatomic,strong) NSArray *followUserList,*fansUserList;
@property (nonatomic,assign) BOOL isHidden;
@property (nonatomic,strong) NSNumber *isFollow;
@end


@interface YCFollowUserListM: YCFollowsM;
@property (nonatomic,strong) NSString *followUserName,*followUserSignature,*followUserImage;
@property (nonatomic,strong) NSNumber * followUserId;



@end


@interface YCFansUserListM: YCFollowsM;
@property (nonatomic,strong) NSString *fansUserName,*fansUserSignature,*fansUserImage;
@property (nonatomic,strong) NSNumber * fansId;



@end
