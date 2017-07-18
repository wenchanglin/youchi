//
//  YCMyOrderCell1.h
//  YouChi
//
//  Created by 朱国林 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import <UIKit/UIKit.h>
#import "YCOrderNumView.h"
#import "YCTableVIewCell.h"
@interface YCMyOrderCell1 : YCTableVIewCell
@property (weak, nonatomic) IBOutlet YCOrderNumView *vOrderNumView;
@property(assign,nonatomic)BOOL isOrderDetail;
@end
