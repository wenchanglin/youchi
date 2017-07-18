//
//  YCDeliveredlocationCell.h
//  YouChi
//
//  Created by 李李善 on 15/12/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"
@interface YCDeliveredlocationCell : YCTableVIewCell


///收件人名字
@property (weak, nonatomic) IBOutlet UILabel *lReceiverName;
///收件人电话
@property (weak, nonatomic) IBOutlet UILabel *lReceiverPhone;
///收货地址
@property (weak, nonatomic) IBOutlet UILabel *lReceiverAddress;
@end
