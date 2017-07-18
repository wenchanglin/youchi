//
//  YCMyCouponVC.h
//  YouChi
//
//  Created by 朱国林 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSwitchTabViewControl.h"
#import "YCTableViewController.h"
@class YCMyCouponVC;



@interface YCMyCouponVCP : YCSwitchTabViewControl


@end

@interface YCMyCouponVC : YCTableViewController
///加载那个类型
@property(nonatomic,assign) NSInteger chooseType;


@end
