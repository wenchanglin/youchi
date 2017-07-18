//
//  YCCommentVM.h
//  YouChi
//
//  Created by sam on 15/5/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCUserCommentM.h"
@interface YCCommentVM : YCPageViewModel

@property (nonatomic,strong) NSString *comment,*deletedBy,*deletedDate;
@property (nonatomic,strong) YCUserCommentM *selectedModel;
@property (strong, nonatomic)  NSNumber *replyUserId;

@property (strong, nonatomic)  NSNumber *replyCommentId;
@property (assign, nonatomic) NSIndexPath *indePath;


- (RACSignal *)onChihuoCommentreply:(NSString *)reply;
- (RACSignal *)onMiJiCommentreply:(NSString *)reply;
- (RACSignal *)onChiHuoDeleteSignal:(NSNumber *)Id;
- (RACSignal *)onGuoDanDeleteSignal:(NSNumber *)Id;
@end
