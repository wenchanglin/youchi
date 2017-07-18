//
//  YCRefundConditionVC.h
//  YouChi
//
//  Created by 李李善 on 16/1/23.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCSwitchTabViewControl.h"
#import "YCRefundConditionVM.h"
typedef enum {
    ///审核中
    onCentralRefundStatus=1,
    ///已处理
    onOKRefundStatus,
    ///已退款
    onMoneyRefundStatus,
    ///已拒绝
    onRefuseRefundStatus,
    
    
}onRefundStatus;

@interface YCRefundConditionVCP : YCSwitchTabViewControl
///onRefundStatus
@property(nonatomic,assign) onRefundStatus RefundStatus;

@end




typedef enum {
    ///情况
    onRefundType,
    ///原因
    onReasonType,
}RefundType;
@interface YCRefundConditionVC : YCStaticViewController
///RefundType
@property(nonatomic,assign) RefundType refundType;

@end
