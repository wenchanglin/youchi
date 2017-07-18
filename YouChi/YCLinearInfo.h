//
//  YCViewInfo.h
//  YouChi
//
//  Created by water on 16/6/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTextLayout.h"
@class YYLabel;

@interface YCLinearInfo : NSObject
- (instancetype)linearInfoWidth:(CGFloat )width;
@property (assign,nonatomic,readonly) CGFloat height;
@property (assign,nonatomic,readonly) CGFloat width;
@end


@interface YCLinearInfoStatic : YCLinearInfo

- (instancetype)linearInfoWidth:(CGFloat)width height:(CGFloat )height;

@end

@interface YCLinearInfoRatio : YCLinearInfo

- (instancetype)linearInfoWidth:(CGFloat)width ratio:(CGFloat )ratio;

@end

@interface YCLinearInfoText : YCLinearInfo

-(instancetype)linearInfoWidth:(CGFloat)width textLayout:(YYTextLayout *)layout;

@end