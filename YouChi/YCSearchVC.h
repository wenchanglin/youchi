//
//  YCSearchVC.h
//  YouChi
//
//  Created by 李李善 on 15/5/24.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "YCTableViewController.h"

typedef enum {
  isSearchTypeShop,///搜索商品
  isSearchTypeOther,///其他搜索
}isSearchType;

@interface YCSearchVC : YCTableViewController
///搜索什么类型  isSearchType
@property(nonatomic,assign) isSearchType searchType;


@end
