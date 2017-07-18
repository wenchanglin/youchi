//
//  YCMyCouponCell.h
//  YouChi
//
//  Created by 朱国林 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"
/**
 判断按钮标题
 buttonTypeExchangeYouMi 友米兑换--->改为 @“立即兑换”
 buttonTypeCouponUse     最新优惠卷--->改为 @“立即使用”
 buttonTypeCouponDelete  最新优惠卷--->改为 @“删除”
 */

typedef enum {
    
    buttonTypeCouponNewCoupon = 0,///用户优惠卷
    buttonTypeCouponUserCoupon ,///最新优惠卷
    buttonTypeExchangeYouMi///友米兑换
}buttonType;


/**
 判断优惠卷使用情况
 */
typedef enum {
    imgCouponUsetypeDidUse=0,///已使用
    imgCouponUsetypeOverdue,///已过期
    imgCouponUsetypeWillUse///未使用
}imgCouponUsetype;

@interface YCMyCouponCell : YCTableVIewCell


///判断优惠卷标签
@property(nonatomic,assign) buttonType btnType;
///判断优惠卷标签
@property(nonatomic,assign) imgCouponUsetype Usetype;
///内容图片
@property (weak, nonatomic) IBOutlet UIImageView *imgCoupon;
///已使用或者未使用图片
@property (weak, nonatomic) IBOutlet UIImageView *imgLabel;
///有效期:
@property (weak, nonatomic) IBOutlet UILabel *lTime;
///删除按钮
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;

@property (weak, nonatomic) IBOutlet UIView *blackView;

/**
 优惠劵还是友米兑换
 如果是优惠劵单元格，直接隐藏
 “友米图片”
 “更改按钮标题”
 
 BOOL
 */
@property(nonatomic,assign) BOOL isCoupon;
@end
