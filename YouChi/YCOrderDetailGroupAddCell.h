//
//  YCOrderDetailGroupAddCell.h
//  YouChi
//
//  Created by ant on 16/5/26.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCGroupAddressView.h"
#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"

@interface YCOrderDetailGroupAddCell : YCTableVIewCell
@property(nonatomic,strong) IBOutlet YCGroupAddressView *addressView;
@property(nonatomic,assign)BOOL isFixOrder;
@end
