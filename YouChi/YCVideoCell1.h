//
//  YCVideoCell1.h
//  YouChi
//
//  Created by 朱国林 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>
@interface YCVideoCell1 : UITableViewCell

/// 图片
@property(nonatomic)IBOutlet UIImageView *imgV;
/// 标题
@property(nonatomic)IBOutlet UILabel     *lTitle;
/// 描述
@property(nonatomic)IBOutlet UILabel     *lDesc;
/// 时间
@property(nonatomic)IBOutlet UILabel     *lTime;

/// 评分、播放次数
@property(nonatomic)IBOutlet UILabel     *lPlayCount;


/// 按钮
@property(nonatomic)IBOutlet UIButton    *btnPlay;


/// 图片宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewWidth;

@end
