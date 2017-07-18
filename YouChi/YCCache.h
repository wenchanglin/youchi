//
//  YCCache.h
//  YouChi
//
//  Created by sam on 15/5/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LevelDB.h>
#import <LDBWriteBatch.h>

#define DATA_BASE ([YCCache sharedCache].dataBase)
@interface YCCache : NSObject
@property (nonatomic,strong,readonly) LevelDB *dataBase;
+ (YCCache *)sharedCache;
- (void)openDataBaseByLoginId:(NSString *)loginId;
- (void)closeDataBase;
@end
