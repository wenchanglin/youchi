//
//  YCViewInfo.h
//  YouChi
//
//  Created by water on 16/6/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCChihuoyingM_1_2;

@interface YCViewInfo : NSObject

@property (assign,nonatomic) CGFloat height;
@property (strong,nonatomic) YCChihuoyingM_1_2 *model;
@property (assign,nonatomic,readonly) CGFloat cellH;


@end
