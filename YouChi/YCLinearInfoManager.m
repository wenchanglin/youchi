//
//  YCCellDataManager.m
//  YouChi
//
//  Created by water on 16/6/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLinearInfoManager.h"
#import "YCLinearView.h"
#import "YCLinearInfo.h"

@interface YCLinearInfoManager ()
@end

@implementation YCLinearInfoManager

-(instancetype)initLinearInfoWithLinearInfos:(NSArray<YCLinearInfo *> *)linearInfos linearView:(YCLinearView *)linearView
{
    _linearInfos = linearInfos;
    __block CGFloat h = 0;
    [linearInfos enumerateObjectsUsingBlock:^(YCLinearInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        h += obj.height;
    }];
    _height = h;
    return [self init];
}

- (instancetype)initLinearInfoWithLinearInfos:(NSArray *)linearInfos
{
    return [self initLinearInfoWithLinearInfos:linearInfos linearView:nil];
}

- (void)addLinearInfo:(YCLinearInfo *)info
{
    _linearInfos = [_linearInfos arrayByAddingObject:info];
    _height += info.height;
}
@end
