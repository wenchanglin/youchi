//
//  YCNewstGroupPurchaseView.h
//  YouChi
//
//  Created by 朱国林 on 16/5/12.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "YCNewstGroupM.h"
#import "YCMyInitiateGroupM.h"

#import "YCLinearView.h"
#import "YCView.h"
#import "YCNumberOfPurchaseView.h"

@interface YCGroupView : YCLinearView
/// 团拼图片
@property(nonatomic,strong)YCView *groupPurchaseImage;
/// 团拼人数
@property(nonatomic,strong)YYLabel *groupPurchaseNum;
/// 团拼名称
@property(nonatomic,strong)YYLabel *lName;

/// 原价
@property(nonatomic,strong)YYLabel *lOriginalpricel;
/// 描述
@property(nonatomic,strong)YYLabel *lBrief;
@end


/// 最新团拼View
@interface YCNewstGroupPurchaseView : YCGroupView

/// 确认开团
@property(nonatomic,strong)UIButton *bOpenGroup;

@property(nonatomic,strong)UIView *redLine;


///最新团拼
- (void)updateWithLastestGroupon:(YCNewstGroupM *)m;
@end

/// 我发起的团拼View
@interface YCMyGroupView : YCGroupView
/// 扫码
@property(nonatomic,strong)UIButton *bQrCode;
/// 发起买单
@property(nonatomic,strong)UIButton *bInitiatePay;
///最新团拼
- (void)updateWithLastestGroupon:(YCMyInitiateGroupM *)m;
@end

///我参与的团拼view
@interface YCMyParticipationGroupView : YCMyGroupView
PROPERTY_STRONG YCNumberOfPurchaseView *numberOfPurchase;
@end
