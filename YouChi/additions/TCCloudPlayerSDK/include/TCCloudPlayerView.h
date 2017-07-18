//
//  TCCloudPlayerView.h
//  QZone
//
//  Created by ximilu on 10/22/14.
//
//  视频播放view.

#ifndef _TCCloudPlayerView_h
#define _TCCloudPlayerView_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TCCloudPlayerShowAbleView.h"



typedef NS_ENUM(NSUInteger, TCCloudPlayerPauseReason)
{
    TCCloudPlayerPauseReason_manually,  // 手动暂停
    TCCloudPlayerPauseReason_system,    // 系统原因
    TCCloudPlayerPauseReason_limited,   // 播放到限制时间
};

typedef void(^onplaybackReadyBlock)(void);
typedef void(^onplaybackBeginBlock)(void);
typedef void(^onplaybackFailedBlock)(NSError* error);
typedef void(^onplaybackEndBlock)(void);

// isBottomHide : bottomView 是否是隐藏
typedef void(^SingleClickPlayBackViewBlock)(BOOL isBottomHide);
 
// isFullScreen : 是否是在全屏情况下点击 YES:全屏下点击 NO:非全屏下点击
typedef void(^ClickPlayBackViewBlock)(BOOL isFullScreen);

// 点击bottomview全屏按钮以及 : 是否是在全屏情况下点击 YES:进入全屏 NO:退出全屏
typedef void(^EnterOrExitFullScreenBlock)(BOOL isFullScreen);
    
typedef void(^onPlaybackPauseBlock)(UIImage* curVideoImg, TCCloudPlayerPauseReason reason);
    
    
@class TCCloudPlayerBottomView;
    
@interface TCCloudPlayerView : UIView
    

@property(nonatomic, readonly) TCCloudPlayerBottomView *bottomView;

@property(nonatomic, assign) BOOL isSilent;//是否静音播放，默认静音

@property(nonatomic, assign) BOOL isCyclePlay;//是否循环播放，默认循环播放

@property(nonatomic, assign) CGFloat luminance;//亮度(0-1)

@property(nonatomic, assign) Float64 limitTime;//限制播放时间(s)

// 准备播放回调
@property(nonatomic, copy) onplaybackReadyBlock playbackReadyBlock;
// 开始播放（暂停后恢复也会回调）
@property(nonatomic, copy) onplaybackBeginBlock playbackBeginBlock;
// 播放失败后都会回调
@property(nonatomic, copy) onplaybackFailedBlock playbackFailedBlock;
// 每次播放完成后都会回调
@property(nonatomic, copy) onplaybackEndBlock playbackEndBlock;
// 暂停回调
@property(nonatomic, copy) onPlaybackPauseBlock playbackPauseBlock;
// 点击显示隐藏bottomView回调
@property(nonatomic, copy) SingleClickPlayBackViewBlock singleClickblock;
// 点击视频时回调
@property(nonatomic, copy) ClickPlayBackViewBlock clickPlaybackViewblock;
// 退出或进入全屏播放
@property(nonatomic, copy) EnterOrExitFullScreenBlock enterExitFullScreenBlock;

@property(nonatomic, readonly)AVAsset *playerAsset; // AVPlayerItem对应的asset

@property(nonatomic, readonly)NSArray *videoUrls;   // TCCloudPlayerVideoUrlInfo

@property (nonatomic, readonly) BOOL isInFullScreen;    // bottomView是否在显示, YES:隐藏 NO:显示

@property (nonatomic, assign) BOOL isEnableRorateFullScreen;    // 是否支持旋转进行横竖屏切换, YES:支持 NO:不支持, 默认YES

/**
 * 全屏播放控件创建
 * @param frame : 竖屏情况下，
 */
- (instancetype)initWithNotFullFrame:(CGRect)frame;

// 替换默认的蒙层
- (void)setMaskShowView:(UIView<TCCloudPlayerShowAbleView> *)showView;

// 点击mask上的数据资源隐藏蒙层
- (void)onHideMaskWhenSelected:(NSInteger)selIndex;

// 是否在播放
-(BOOL)isPlaying;

// 播放
-(void)play;

// 暂停
-(void)pause;

// 拖动到seconds处播放
- (void)seekToTime:(NSInteger)seconds;

/*
 * 传入视频信息，并准备播放
 * @param videoUrls : 同一视频不同格式（标清，高清待）的信息，TCCloudPlayerVideoUrlInfo数组
 * @param defaultPlayIndex : 选videoUrls[defaultPlayIndex]视频播放
 * @param startTimeInSeconds : 从startTimeInSeconds处播放
 */
-(BOOL)setUrls:(NSArray*)videoUrls defaultPlayIndex:(NSInteger)defaultPlayIndex startTime:(Float64)startTimeInSeconds;

//设置视频的填充方式.默认值AVLayerVideoGravityResizeAspectFill
-(void)setVideoFillMode:(NSString *)fillMode;

// 当前播放时刻视频画面
- (UIImage *)getCurVideoImage;

// 当前播放时间
- (Float64)getCurVideoPlaybackTimeInSeconds;

// 当前播放的视频信息
- (id)currentUrl;

// 视频时长
- (Float64)duration;

// 强制进行全屏切换
- (void)forceToDeviceOrientation;

// bottomView显示与隐藏切换
- (void)reversionFullScreenState;

/*
 * SDK只提供水平布局(在bottomview上方水平居中显示)，外部处理按钮事件
 * @param buttons : 要添加的按钮（SDK只提供布局）
 * @param btnSize : 按钮大小
 * @param hormargin : 按钮间水平间间距
 */
- (void)addMaskView:(NSArray *)buttons size:(CGSize)btnSize;

// 设置BottomView 放大缩小按钮的放大与缩小图片
- (void)changeBottomFullImage:(UIImage *)amplifyImage notFullImage:(UIImage *)shrinkImage;


+ (void)setEnableCache:(BOOL)enable;

@end


#endif






















