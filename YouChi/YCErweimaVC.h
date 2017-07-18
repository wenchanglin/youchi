//
//  YCErweimaVC.h
//  YouChi
//
//  Created by sam on 15/6/15.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCGroupPurchaseMainVC.h"
#import "YCViewController.h"
#import <CDZQRScanningViewController/CDZQRScanningViewController.h>
static NSString *YCErweimaDidScanCode = @"YCErweimaDidScanCode";
@interface YCErweimaVC : YCViewController

@end


@interface YCQRScanningViewController : CDZQRScanningViewController
@property (nonatomic,assign) BOOL isScanning;
@end
