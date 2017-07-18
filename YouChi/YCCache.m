//
//  YCCache.m
//  YouChi
//
//  Created by sam on 15/5/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCache.h"

@implementation YCCache

/*
 创建单利
 */


+ (YCCache *)sharedCache {
    static YCCache *_standardUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardUserDefaults = [[self alloc]init];
    });
    
    
    return _standardUserDefaults;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


/*
 根据loginId获取对应的数据库
 1:close 是否打开数据库
 2:useCache 是否缓存
 3:encoder 编码
 4:decoder 解码
 */

- (void)openDataBaseByLoginId:(NSString *)loginId
{
    [_dataBase close];
    _dataBase = [LevelDB databaseInLibraryWithName:loginId];
    _dataBase.useCache = YES;
    _dataBase.encoder = ^ NSData * (LevelDBKey *key, id object) {
        return [NSKeyedArchiver archivedDataWithRootObject:object];
    };
    
    
    _dataBase.decoder = ^ id (LevelDBKey *key, NSData * data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    };
}


/*
关闭数据库
 */

- (void)closeDataBase
{
    [_dataBase close];
    _dataBase = nil;
}
@end
