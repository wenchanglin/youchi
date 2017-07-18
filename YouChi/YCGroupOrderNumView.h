//
//  YCGroupOrderNumView.h
//  YouChi
//
//  Created by ant on 16/5/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <YYKit/YYKit.h>
#import "Masonry.h"
#import "YCView.h"
#import <UIKit/UIKit.h>

/// 发货状态
typedef NS_ENUM(NSUInteger, YCGroupOrderState) {
    
    YCGroupOrderStateAllHadPay,       /// 全部付款
    YCGroupOrderStateHadSend,       ///      已发货
    YCGroupOrderStateHadCancel,       ///   已取消
};



@interface YCGroupOrderNumView : UIView

@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *lTitle;
@property(nonatomic,assign)YCGroupOrderState groupOrderState;

- (void)onUpdataRemainingNum:(int)count;
@end
