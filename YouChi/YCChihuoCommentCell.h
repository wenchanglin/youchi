//
//  YCChihuoCommentCell.h
//  YouChi
//
//  Created by 李李善 on 15/9/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCMarcros.h"
#import "YCCommentM.h"
#import "YCAvatar.h"
#import "YCTableVIewCell.h"
#import <Masonry/Masonry.h>

@interface YCChihuoCommentCell : YCTableVIewCell
@property(nonatomic,strong) YCAvatar  *avatar;
@property(nonatomic,strong) UILabel  *name;
@property(nonatomic,strong) UILabel  *comment;
@property(nonatomic,strong) UILabel  *date;


- (void)updateComment:(YCCommentM *)m;
@end

@interface YCCommentView : UIView
@property(nonatomic,strong) YCAvatar  *avatar;
@property(nonatomic,strong) YYLabel  *name;
@property(nonatomic,strong) YYLabel  *comment;
@property(nonatomic,strong) YYLabel  *date;

- (void)updateComment:(YCCommentM *)m;
@end
