//
//  YCProfileView.h
//  YouChi
//
//  Created by sam on 15/8/19.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCAvatarControl.h"
#import "YCRankView.h"
#import "YCBtnControl.h"
#import "YCProfileButtonsView.h"
#import "YCTableViewHeaderFooterView.h"
@interface YCProfileView : YCTableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet YCAvatarControl *infoAvatar;
/// 个人信息 等级 关注粉丝 view
@property (weak, nonatomic) IBOutlet YCProfileButtonsView *profileButtonsView;
/// 关注
@property (weak, nonatomic) IBOutlet UIButton *attention;
/// 粉丝
@property (weak, nonatomic) IBOutlet UIButton *fans;
/// 分享
@property (weak, nonatomic) IBOutlet UIButton *share;
/// 有米
@property (weak, nonatomic) IBOutlet UIButton *UMi;

/// 等级
@property (weak, nonatomic) IBOutlet YCRankView *rank;
/// 编辑
@property (weak, nonatomic) IBOutlet UIButton *edit;



@end
