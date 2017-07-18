//
//  YCPlayerVC.h
//  YouChi
//
//  Created by sam on 15/9/17.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCViewController.h"
#import "TCCloudPlayerRorateViewController.h"
#import "TCCloudPlayerView.h"
#import "YCPlayerVM.h"
@interface YCPlayerVC : YCViewController
@property (nonatomic,strong) TCCloudPlayerView *player;
@property (nonatomic,strong) YCPlayerVM *viewModel;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong,readonly) NSString *fullUrlString;
- (instancetype)initWithFullUrlString:(NSString *)url;
@end
