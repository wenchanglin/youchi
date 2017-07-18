//
//  YCMyOrderCell.h
//  YouChi
//
//  Created by 朱国林 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCCommodity.h"
#import "YCTableView.h"
#import "YCTableVIewCell.h"
@interface YCMyOrderCell : YCTableVIewCell
@property (weak, nonatomic) IBOutlet YCCommodity *goodsAttribute;

@end
