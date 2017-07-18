//
//  YCVideoVC.h
//  YouChi
//
//  Created by 朱国林 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCSwitchTabControl.h"
#import "YCVideoVM.h"
#import "YCDiscoverVC.h"
#import "YCSwitchTabViewControl.h"
@interface YCVideoVCP : YCSwitchTabViewControl

@end



@interface YCVideoVC : YCTableViewController

@property(nonatomic,assign) NSInteger selectedSegmentIndex;
@end
