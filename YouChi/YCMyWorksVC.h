//
//  YCMyshareVC.h
//  YouChi
//
//  Created by 朱国林 on 15/8/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//  int direction
#import "YCChihuoyingVC.h"
#import "YCViewController.h"
#import "YCSwitchTabControl.h"
@interface YCMyWorksVC : YCViewController

/// 选项
@property (weak, nonatomic) IBOutlet YCSwitchTabControl *option;

@end

@interface YCMyWorksOfScrollVC : YCChihuoyingVC
@property(nonatomic,assign)BOOL isAnimation;

#pragma mark --方向
@property(nonatomic,assign)int direction;
@end