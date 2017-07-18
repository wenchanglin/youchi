//
//  YCMyOrderVC.h
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCDiscoverVC.h"
#import "YCMyOrderVM.h"
#import "YCSwitchTabViewControl.h"
@interface YCMyOrderVCP : YCSwitchTabViewControl

@end
@interface YCMyOrderVC : YCBTableViewController
@property(nonatomic,assign)NSInteger orderType;
@end

