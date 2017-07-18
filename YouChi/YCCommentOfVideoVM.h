//
//  YCCommentOfVideoVM.h
//  YouChi
//
//  Created by 朱国林 on 15/11/9.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCChihuoyingM.h"
#import "YCViewModel.h"
#import "YCCommentM.h"
@interface YCCommentOfVideoVM : YCPageViewModel
@property (nonatomic,strong) YCChihuoyingM_1_2 *videoModel;
@property (nonatomic,strong) YCCommentM *replyModel;
@end
