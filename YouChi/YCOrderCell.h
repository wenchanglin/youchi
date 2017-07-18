//
//  YCOrderCell.h
//  YouChi
//
//  Created by 李李善 on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSuperTableViewCell.h"
#import "YCCommodity.h"
@interface YCOrderCell : YCSuperTableViewCell
@property (weak, nonatomic) IBOutlet YCCommodity *commodityView;

@end
