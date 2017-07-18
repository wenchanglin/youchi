//
//  YCApplyForRefundVC.h
//  YouChi
//
//  Created by 朱国林 on 16/1/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCRandomPicturesVC.h"
#import "YCApplyForRefundVM.h"

typedef void(^onUpdata)();
@interface YCApplyForRefundVCP : YCViewController
@property(nonatomic,strong)onUpdata onUpdata;
@end

@interface YCApplyForRefundVC : YCStaticViewController

@end

