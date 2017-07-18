//
//  YCCancelOrderVC.h
//  YouChi
//
//  Created by 朱国林 on 16/2/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCCancelOrderVM.h"
typedef void(^onUpdata)();

@interface YCCancelOrderVC : YCTableViewController
@property(nonatomic,strong)onUpdata onUpdata;
@end
