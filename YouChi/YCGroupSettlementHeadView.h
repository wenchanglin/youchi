//
//  YCGroupSettlementHeadView.h
//  YouChi
//
//  Created by ant on 16/5/18.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 団拼结算情况头部View
@interface YCGroupSettlementHeadView : UIView

@property(nonatomic,strong)UIButton *bShipmentsRules;
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *lTitle;
@property(nonatomic,strong)UIImageView *imgArrow;
@property(nonatomic,assign)BOOL isHiddenIcon;
@end
