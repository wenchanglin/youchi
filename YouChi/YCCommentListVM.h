//
//  YCCommentListVM.h
//  YouChi
//
//  Created by ZhiMin Deng on 15/6/14.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCDetailControlVCP.h"
#import "YCViewModel.h"
#import "YCCommentM.h"
@interface YCCommentListVM : YCPageViewModel<YCDetailControlDatasource>
- (instancetype)initWithId:(id)aId type:(YCCheatsType )type;
@property (nonatomic,strong) YCCommentM *replyModel;

@property (nonatomic,strong) YCCommentM *selectedModel;

@property (nonatomic,assign) YCCheatsType type;
@end
