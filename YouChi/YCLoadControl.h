//
//  YCLoadView.h
//  YouChi
//
//  Created by sam on 15/6/15.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCLoadControl : UIControl
@property (nonatomic,strong,readonly) UIActivityIndicatorView *indicator;
@property (nonatomic,strong,readonly) UILabel *desc;
+ (YCLoadControl *)creatDefaultLoadView;

- (void)showLoading;
- (void)hideLoading;
- (void)errorLoading;
@end
