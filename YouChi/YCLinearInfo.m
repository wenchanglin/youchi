//
//  YCViewInfo.m
//  YouChi
//
//  Created by water on 16/6/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLinearInfo.h"
#import "YCChihuoyingM.h"

@interface YCLinearInfo ()
@property (assign,nonatomic,readwrite) CGFloat height;

@property (assign,nonatomic,readwrite) CGFloat width;

@end

@implementation YCLinearInfo
- (instancetype)linearInfoWidth:(CGFloat)width
{
    _width = width;
    return [self init];
}

@end


@interface YCLinearInfoStatic ()

@end
@implementation YCLinearInfoStatic


- (instancetype)linearInfoWidth:(CGFloat)width height:(CGFloat)height
{
    self.height = height;
    
    return [self linearInfoWidth:width];
}


@end

@implementation YCLinearInfoRatio

-(instancetype)linearInfoWidth:(CGFloat)width ratio:(CGFloat)ratio{
    self.height = width*ratio;
    return [self linearInfoWidth:width];
}

@end

@implementation YCLinearInfoText

-(instancetype)linearInfoWidth:(CGFloat)width textLayout:(YYTextLayout *)layout{
    self.height = layout.textBoundingSize.height;
    return [self linearInfoWidth:width];
}

@end