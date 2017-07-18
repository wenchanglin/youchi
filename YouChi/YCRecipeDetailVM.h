//
//  YCSmallHelperDetailedVM.h
//  YouChi
//
//  Created by 李李善 on 15/5/26.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCChihuoyingM.h"

#import "YCDetailControlVCP.h"
@interface YCRecipeDetailVM : YCAutoPageViewModel<YCDetailControlDatasource>
@property (nonatomic,strong) YCChihuoyingM_1_2 *model;
@property (nonatomic,strong) YCCommentM *replyModel;
@property (nonatomic,assign) BOOL shouldOpenCommentKeyboard;
@end
