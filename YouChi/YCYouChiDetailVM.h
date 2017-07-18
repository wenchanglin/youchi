//
//  YCSpecialDrinkVM.h
//  YouChi
//
//  Created by sam on 15/5/19.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCChihuoyingM.h"
#import "YCCommentM.h"
#import "YCDetailControlVCP.h"

#define YCYouChiDetailInset 3
@interface YCYouChiDetailVM : YCAutoPageViewModel<YCDetailControlDatasource>
- (instancetype )initWithYouChiId:(id)aId;
@property (nonatomic,strong) YCChihuoyingM_1_2 *model;
@property (nonatomic,strong) YCCommentM *replyModel;
@property (nonatomic,assign) BOOL shouldOpenCommentKeyboard;
@property (nonatomic,assign) NSNumber *lickCount;
@property (nonatomic,readonly) NSNumber *youchiId;
@end
