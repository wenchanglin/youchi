//
//  YCPriceCell.h
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"

@interface YCPriceCell : YCTableVIewCell

@property (weak, nonatomic) IBOutlet UILabel *lCoupon;
@property (weak, nonatomic) IBOutlet UILabel *price;///商品总额¥
@property (weak, nonatomic) IBOutlet UILabel *postage;///运费¥
@property (weak, nonatomic) IBOutlet UILabel *coupon;///优惠劵¥
@property (weak, nonatomic) IBOutlet UILabel *money;///使用账号余额¥
/// 邮费
@property (weak, nonatomic) IBOutlet UILabel *lPostage;
/// 满多少包邮
@property (weak, nonatomic) IBOutlet UILabel *lHowPostage;

@end
