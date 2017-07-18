//
//  YCRecommendMsgVC.h
//  YouChi
//
//  Created by 朱国林 on 15/8/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCSwitchTabControl.h"
#import "YCDiscoverVC.h"
#import "YCNewsVM.h"
#import "YCSwitchTabViewControl.h"



@interface YCNewsVCP : YCSwitchTabViewControl

@end

@interface YCNewsVC : YCTableViewController

@property(nonatomic,assign) NSInteger selectedSegmentIndex;
@end
