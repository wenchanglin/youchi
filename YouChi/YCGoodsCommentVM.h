//
//  YCGoodsCommentVM.h
//  YouChi
//
//  Created by 朱国林 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCGoodsCommentM.h"
#import "YCItemDetailM.h"
#define YCGoodsCommentInset 5
@interface YCGoodsCommentVM : YCPageViewModel
@property (nonatomic,strong) YCItemDetailM *model;

- (RACSignal *)clickLikeForProductShowoffByProductShowoffId:(NSNumber *)Id actionType:(BOOL )actionType;
@end
