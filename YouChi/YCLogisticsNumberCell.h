//
//  YCLogisticsNumberCell.h
//  YouChi
//
//  Created by 李李善 on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSuperTableViewCell.h"


#pragma mark-------公共父类
@interface YCLogisticsSuperNumberCell : YCSuperTableViewCell
///位置
@property (weak, nonatomic) IBOutlet UILabel *lLogisticsLocation;
///时间
@property (weak, nonatomic) IBOutlet UILabel *lTimer;

@end


#pragma mark-------第一个
@interface YCLogisticsFirstNumberCell : YCLogisticsSuperNumberCell

@end
#pragma mark-------中间
@interface YCLogisticsOtherNumberCell : YCLogisticsSuperNumberCell

@end
#pragma mark-------最后一个
@interface YCLogisticsLastNumberCell : YCLogisticsSuperNumberCell

@end