//
//  TCCloudPlayerRorateViewController.h
//  TCCloudPlayerSDK
//
//  Created by James on 15/7/24.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "TCCloudPlayerViewController.h"

@interface TCCloudPlayerRorateViewController : TCCloudPlayerViewController

// notFullScreenFrame 为竖屏的时候显示的区域
// 横屏显示在整个Viewcontroller.view里面
- (instancetype)initWithAppID:(NSString*)strAppID inFrame:(CGRect)notFullScreenFrame;

// 添加播放器界面
- (void)addPlayerView;

// 添加非播放器界面
- (void)addOtherNoPlayerView;

// 强制横竖屏切换
- (void)forceSwitchScreen;

//// 强制锁屏
//- (void)lockScreenRorate;




@end
