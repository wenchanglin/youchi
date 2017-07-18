//
//  YCFixOrderVC.h
//  YouChi
//
//  Created by 李李善 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCTableViewController.h"
#import "YCFixOrderVM.h"
#import "YCMyCartVC.h"

#import "YCEditAddressVC.h"


@class YCFixOrderVCP;
@interface YCFixOrderVC : YCBTableViewController
@property(nonatomic,weak) YCFixOrderVCP  *vcp;
@end



@interface YCFixOrderVCP : YCViewController
@end
