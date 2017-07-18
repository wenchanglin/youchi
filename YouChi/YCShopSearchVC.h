//
//  YCShopSearchVC.h
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCDiscoverVC.h"
#import "YCTableViewController.h"
#import "YCSwitchTabViewControl.h"
#import "YCShopSearchVM.h"
#import "YCShopSearchCell.h"

@interface YCShopSearchVCP : YCSwitchTabViewControl


@end

@interface YCShopSearchVC : YCTableViewController

@property(nonatomic,assign)NSInteger orderType;


@end
