//
//  TCCloudPlayerViewController.h
//  StitchedStreamPlayer
//
//  Created by ximilu on 15/4/13.
//
//

#ifndef _TCCloudPlayerViewController_h
#define _TCCloudPlayerViewController_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TCCloudPlayerSDK.h"
 
@class TCCloudPlayerView;
@interface TCCloudPlayerViewController: UIViewController
{
@protected
    TCCloudPlayerView* _playbackView;
//    BOOL _isInFullScreen;
    
    NSString* _strAppID;
    NSString* _videoFileID;
    NSString* _videoFileName;
    NSArray*  _videoUrls;
    NSUInteger _defPlayIndex;
    Float64    _startTimeInSeconds;
}

@property (nonatomic, assign) CGFloat limitedSeconds;
  
-(id)initWithAppID:(NSString*)strAppID;
-(BOOL)setVideoInfo:(NSString*)videoFileID videoFileName:(NSString*)videoFileName videoUrls:(NSArray *)videoUrls defaultPlayIndex:(NSUInteger)defaultPlayIndex startTime:(Float64)startTimeInSeconds;
//-(BOOL)play:(Float64)beginPlayTime;
//-(BOOL)pause;
//-(Float64)currentPlayTime;


// protected
- (void)initPlayerView;
//- (void)addPlayerCtrlView;


/*
 * SDK只提供水平布局，外部处理按钮事件
 * @param buttons : 要添加的按钮（SDK只提供布局）
 * @param btnSize : 按钮大小
 */
- (void)addMaskActionView;
- (void)addMaskView:(NSArray *)buttons size:(CGSize)btnSize;

@end

#endif
