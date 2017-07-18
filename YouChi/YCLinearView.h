//
//  YCCellManager.h
//  YouChi
//
//  Created by water on 16/6/15.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCLinearInfoManager.h"
#import "UIView+YC.h"
#import <YYKit.h>

@class YCLinearInfo;

@interface YCLinearView<subViewType : UIView *> : UIView

@property (strong,nonatomic,readonly) NSArray<subViewType > *subInfoviews;
@property (strong,nonatomic,readonly) YCLinearInfoManager *linearInfoManager;

- (void )addLinearSubview:(subViewType )subview;
- (void )removeLinearSubview:(subViewType )subview;

- (void )updateWithlinearInfoManager:(YCLinearInfoManager *)linearInfoManager;

@end

