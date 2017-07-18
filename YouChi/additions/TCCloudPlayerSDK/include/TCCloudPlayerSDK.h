//
//  TCCloudPlayerSDK.h
//  TCCloudPlayerSDK
//
//  Created by tencent on 15/4/13.
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//  sdk支持ios6及以上的系统版本，支持arm64。
//  需引入系统的 CoreMedia.framework 和 AVFoundation.framework


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TCCloudPlayerVideoUrlInfo.h"

extern NSString *TCCloudPlayStateChangeNotification; //注册此通知接受状态变化
//通知消息可能包含的选项
extern NSString *kTCCloudPlayState;         //当前状态 (0-停止,1-播放,2-暂停)
extern NSString *kTCCloudPlayPauseReason;   //暂停原因（0-手动,1-退后台,2-播放限时）
extern NSString *kTCCloudPlayTime;          //当前播放到的时间 (s)
extern NSString *kTCCloudPlayDuration;      //视频时长 (s)
extern NSString *kTCCloudPlayQaulity;       //清晰度（当前播放的URL信息）
extern NSString *kTCCloudPlayError;         //错误信息

@interface TCCloudPlayerSDK : NSObject

/*
 @abstract		播放视频某个视频
 @discussion
 @param         appID - 向腾讯云申请应用唯一标识
 @param			videoFileID － 视频文件的唯一标识。
 @param			videoName － 视频名称，显示在播放界面的标题位置。
 @param			videoUrls － TCCloudVideoURL 数组，包含该视频的各种清晰度的地址
 @param			limitedSeconds － 播放限时，播放到该时间点后自动停止并抛出通知
 @param			defaultPlayUrlsIndex － 默认开始播放的 videoUrls 数组下标
  @param		inViewController － 播放界面会在父窗口模态弹出进行播放
 */
+ (BOOL)playVideo:(NSString*)appID
      videoFileID:(NSString*)videoFileID
        videoName:(NSString *)videoName
        videoUrls:(NSArray *)videoUrls
   limitedSeconds:(CGFloat)seconds
defaultPlayUrlsIndex:(NSUInteger )defIndex
 inViewController:(UIViewController *)viewController;



/*
 其他参数同上
 @param		fromViewController － 从当前界面push到视频界面
 @param     inPortraitFrame - 竖屏情况下进入的rect,此时注意屏慕的宽度
 
 */
+ (BOOL)pushPlayVideo:(NSString*)appID
      videoFileID:(NSString*)videoFileID
        videoName:(NSString *)videoName
        videoUrls:(NSArray *)videoUrls
   limitedSeconds:(CGFloat)seconds
defaultPlayUrlsIndex:(NSUInteger )defIndex
   fromViewController:(UIViewController *)fromVC
          inPortraitFrame:(CGRect)rect;

/*
 * 其他参数同上
 * @param     customRorateVCClass - 自定义的TCCloudPlayerRorateViewController的子类
 */

+ (BOOL)pushPlayVideo:(NSString*)appID
          videoFileID:(NSString*)videoFileID
            videoName:(NSString *)videoName
            videoUrls:(NSArray *)videoUrls
       limitedSeconds:(CGFloat)seconds
 defaultPlayUrlsIndex:(NSUInteger )defIndex
   fromViewController:(UIViewController *)fromVC
 withCustomController:(Class)customRorateVCClass
      inPortraitFrame:(CGRect)rect;


/*
 * 其他参数同上
 * @param     enable - 设置是否允许播放器缓存视频
 *                     YES：播放器播放时缓存视频文件，关闭网络后可以使用缓存播放，退出播放界面后缓存清空
 *                     NO：不缓存视频，有系统控制，关闭网络后可能不能播放
 *
 */
+ (void)enablePlayerCacheVideo:(BOOL)enable;

@end
