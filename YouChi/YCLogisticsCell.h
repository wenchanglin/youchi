//
//  YCLogisticsCell.h
//  YouChi
//
//  Created by 李李善 on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"
@interface YCLogisticsCell : YCTableVIewCell
@property (weak, nonatomic) IBOutlet UIView *logisticsView;
///物流单号
@property (weak, nonatomic) IBOutlet UILabel *lLogisticsNumber;
///包裹物流1
@property (weak, nonatomic) IBOutlet UILabel *lPackege;
///物流1
@property (weak, nonatomic) IBOutlet UILabel *lNumber;
///物流2
@property (weak, nonatomic) IBOutlet UILabel *lNumber2;
///物流3
@property (weak, nonatomic) IBOutlet UILabel *lNumber3;
@property (weak, nonatomic) IBOutlet UIButton *btnWuLiu;

@end
