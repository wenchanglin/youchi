//
//  TCCloudPlayerShowAbleView.h
//  TCCloudPlayerSDK
//
//  Created by AlexiChen on 15/8/19.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCCloudPlayerView;

@protocol TCCloudPlayerShowAbleView <NSObject>


@required
// 显示的宽度
- (CGFloat)width;

@optional

@property (nonatomic, weak) TCCloudPlayerView *playerView;

/*
 * @param videoTypes 当前播放器中的播放数据(TCCloudPlayerVideoUrlInfo数组)
 * @param curSelIndex 当前正在播放的资源在videoTypes的索引
 */
- (void)setVideoTyps:(NSArray *)videoTypes curSelIndex:(NSInteger)curSelIndex;

@end
