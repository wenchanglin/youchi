//
//  YCCellManagerFrame.h
//  YouChi
//
//  Created by water on 16/6/17.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCChihuoyingM_1_2;

@interface YCCellManagerFrame : NSObject

@property (strong,nonatomic) YCChihuoyingM_1_2 *model;

@property (assign,nonatomic,readonly) CGRect topF;
@property (assign,nonatomic,readonly) CGRect topIconF;
@property (assign,nonatomic,readonly) CGRect userNameF;
@property (assign,nonatomic,readonly) CGRect topRightF;
@property (assign,nonatomic,readonly) CGRect signatureF;

@property (assign,nonatomic,readonly) CGRect middleViewF;
@property (assign,nonatomic,readonly) CGRect smallPictureF;
@property (assign,nonatomic,readonly) CGRect bigPictureF;
@property (assign,nonatomic,readonly) CGRect locationDescF;
@property (assign,nonatomic,readonly) CGRect addressIconF;
@property (assign,nonatomic,readonly) CGRect materialNameF;
@property (assign,nonatomic,readonly) CGRect materialDescF;


@property (assign,nonatomic,readonly) CGRect footerViewF;

@property (assign,nonatomic,readonly) CGFloat cellH;




@end
