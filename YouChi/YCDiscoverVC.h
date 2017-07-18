//
//  YCDiscoverVC.h
//  YouChi
//
//  Created by 朱国林 on 15/8/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewController.h"
#import "YCSwitchTabControl.h"
@interface YCDiscoverVC : YCViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet YCSwitchTabControl *tabControl;
- (IBAction)onNewsAndVideo:(YCSwitchTabControl *)sender;


@property (weak, nonatomic) IBOutlet YCSwitchTabControl *discTab;


@end
