//
//  YCCellDataManager.h
//  YouChi
//
//  Created by water on 16/6/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCLinearInfo,YCLinearView;
@interface YCLinearInfoManager : NSObject

- (instancetype)initLinearInfoWithLinearInfos:(NSArray *)linearInfos linearView:(YCLinearView *)linearView;
- (instancetype)initLinearInfoWithLinearInfos:(NSArray *)linearInfos;
- (void)addLinearInfo:(YCLinearInfo *)info;

@property (strong,nonatomic,readonly) NSArray<YCLinearInfo *> *linearInfos;
@property (nonatomic,assign,readonly) CGFloat height;//所有子view加起来的总高度

@property (weak,nonatomic,readonly) YCLinearView *linearView;

@end
