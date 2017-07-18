//
//  YCYouMiExchangePayCell.h
//  YouChi
//
//  Created by 李李善 on 16/1/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSuperTableViewCell.h"
#import "YCCommodity.h"
@interface YCYouMiExchangePayCell : YCSuperTableViewCell
///View
@property (weak, nonatomic) IBOutlet YCCommodity *commodityView;
///需要支付多少友米
@property (weak, nonatomic) IBOutlet UILabel *lMuch;

@end
