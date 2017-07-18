//
//  YCNumBerOfPurchaseView.h
//  YouChi
//
//  Created by 朱国林 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCPhotosView.h"
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "YCView.h"
/// 参与人数View
@interface YCNumberOfPurchaseView : YCView
@property (strong, nonatomic) YCPhotosView *photosView;
@property (strong,nonatomic) YYLabel *lTitle;

- (void)onUpdataAvatar:(NSArray *)avatarList;
+ (CGFloat )preferHeight:(CGFloat )h;
@end

