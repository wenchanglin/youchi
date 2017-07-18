//
//  YCNotificationM.h
//  YouChi
//
//  Created by 李李善 on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"

@interface YCNotificationM : YCBaseImageModel
@property (nonatomic,strong) NSString  *message,*originalAction,*originalType,*createdBy,*lastModifiedBy,*lastModifiedDate,*status,*deletedBy,*deletedDate,*pushUser,*title,*user;
@property (nonatomic,strong) NSNumber *firstPage,*lastPage,*numberOfElements,*size,*totalElements,*totalPages;
@property (nonatomic,assign) CGFloat cellHeight;
- (void)onSetupHeightWithWidth:(float)width;
@end
