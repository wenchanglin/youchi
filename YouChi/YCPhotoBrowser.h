//
//  YCPhotoBrowser.h
//  YouChi
//
//  Created by sam on 15/9/22.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>
typedef NSURL *(^YCPhotoBrowserBlock) (id model);
@interface YCPhotoBrowser : MWPhotoBrowser
@property (nonatomic,strong) YCPhotoBrowserBlock urlBlock;
- (void)setUrlBlock:(YCPhotoBrowserBlock)urlBlock;
- (id)initWithPageModels:(NSArray *)pageModels selectedIndex:(NSUInteger )selectedIndex;
@end
