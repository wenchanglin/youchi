//
//  YCCommentM.h
//  YouChi
//
//  Created by 李李善 on 15/6/11.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import "YCCommentM.h"
#import "YCMeM.h"
@class YCTargetBodyM;
@interface YCUserCommentM : YCBaseModel

@property (nonatomic,strong) NSString *message,*pushUserName,*title,*url;
@property (nonatomic,strong) NSNumber *originalType,*messageId,*pushUserId,*userId;
@property (nonatomic,strong) NSString *pushUserImage;
@property (nonatomic,strong) NSAttributedString *attributedDesc;
@property (nonatomic,strong) YCTargetBodyM *targetBody;
@end

@interface YCTargetBodyM : YCBaseImageModel
@property (nonatomic,strong) NSString *name,*url;
@end
