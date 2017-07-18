//
//  YCPageInfo.h
//  YouChi
//
//  Created by ZhiMin Deng on 15/6/15.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
typedef NS_ENUM(NSUInteger, YCLoadingStatus)
{
    YCLoadingStatusDefault = 0,
    YCLoadingStatusRefresh,
    YCLoadingStatusLoadMore,
};

@interface YCPageInfo : NSObject
@property (nonatomic,assign) BOOL firstPage,lastPage;
@property (nonatomic,assign) int newCount,number,numberOfElements,size,totalElements,totalPages;

@property (nonatomic,assign) int pageNo,pageSize;

@property (nonatomic,strong) id refreshId,loadmoreId;

@property (nonatomic,assign) YCLoadingStatus status;
@end
