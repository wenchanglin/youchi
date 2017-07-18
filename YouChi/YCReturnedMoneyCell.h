//
//  YCReturnedMoneyCell.h
//  YouChi
//
//  Created by 朱国林 on 16/2/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCSwitchTabControl.h"
#import "YCAboutGoodsM.h"
#import "YCTableVIewCell.h"

@interface YCReturnedMoneyCell : YCTableVIewCell
@property (weak, nonatomic) IBOutlet YCSwitchTabControl *specialTab;
/// 审核状态
@property (weak, nonatomic) IBOutlet UILabel *lStatus;
/// 取消原因
@property (weak, nonatomic) IBOutlet UILabel *lReason;
///  时间
@property (weak, nonatomic) IBOutlet UILabel *lTime;


@property(strong,nonatomic)YCRefundM *refundRemark,*refuseRemark;

@end
