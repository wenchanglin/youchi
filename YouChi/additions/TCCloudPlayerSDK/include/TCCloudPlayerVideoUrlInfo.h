//
//  TCCloudPlayerVideoUrlInfo.h
//  TCCloudPlayerDemo
//
//  Created by ximilu on 15/4/16.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#ifndef _TCCloudVideoURL_h
#define _TCCloudVideoURL_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TCCloudPlayerVideoUrlInfo : NSObject

@property(nonatomic, strong) NSString *videoUrlTypeName; // 视频对应的类型描述，显示两个字(比如：高清,普通，流畅，源片等)
@property(nonatomic, strong) NSURL *videoUrl;

@end

#endif
