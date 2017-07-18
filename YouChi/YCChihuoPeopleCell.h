//
//  YCChihuoPeopleCell.h
//  YouChi
//
//  Created by 李李善 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCPhotosView.h"
#import "YCCollectionPhotoCell.h"
#import "YCChihuoyingM.h"
#import "YCRightLikeCountView.h"
#import "YCDefines.h"
#import "YCTableVIewCell.h"
@interface YCChihuoPeopleCell : YCTableVIewCell
@property (weak, nonatomic) IBOutlet YCLeftZanView *leftZanView;
@property (weak, nonatomic) IBOutlet YCPhotosView *photosView;
@property (weak, nonatomic) IBOutlet UIButton *more;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLineHeight;
- (void)updateChihuo:(YCChihuoyingM_1_2 *)model type:(YCCheatsType )type;
@end
