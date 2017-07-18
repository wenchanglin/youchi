//
//  YCZanView.h
//  YouChi
//
//  Created by 李李善 on 15/8/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YCRightLikeCountView : UIControl
///显示赞数

@property (assign, nonatomic) BOOL leftAndRight;
@property (strong, nonatomic) UILabel *zanShu;
@property (strong, nonatomic) UIImageView *zanImage;

- (void)updateLikeCount:(int )likeCount;
@end


@interface YCLeftZanView : YCRightLikeCountView

@end