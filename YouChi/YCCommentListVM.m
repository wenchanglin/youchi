//
//  YCCommentListVM.m
//  YouChi
//
//  Created by ZhiMin Deng on 15/6/14.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommentListVM.h"
#import "YCViewModel+Logic.h"

@implementation YCCommentListVM
- (void)dealloc{
    //ok
}

- (instancetype)initWithId:(id)aId type:(YCCheatsType)type
{
    self = [super initWithId:aId];
    if (self) {
        self.type = type;
    }
    return self;
}

-(instancetype)initWithModel:(id)model
{
    if (self == [super initWithModel:model]) {
        
        //self.modelsProxy = (id)model;
    }
    return self;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell0;
}


- (YCChihuoyingM_1_2 *)updateModel
{
    return self.model;
}

- (YCCheatsType)cheatsType{

    return self.type;
}
//- (NSURL *)shareImageUrl
//{
//    return self.videoModel.imagePath;
//}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    YCCommentM *m = [self modelForItemAtIndexPath:indexPath];
    return m.cellHeight;
}

- (RACSignal *)mainSignal
{
    WSELF;
    return [[super getCommentsById:self.Id type:self.type]doNext:^(NSArray *x) {
        SSELF;
        for (YCCommentM *m in x) {
            [m onSetupHeightWithWidth:kScreenWidth];
        }
        if (self.nextBlock) {
           self.nextBlock(x);
        }
    }];
}

- (RACSignal *)replySignalId:(NSNumber *)Id replyCommentId:(NSNumber *)replyCommentId replyUserId:(NSNumber *)replyUserId comment:(NSString *)comment type:(YCCheatsType)type{
    WSELF;
    return [[super replySignalId:Id replyCommentId:replyCommentId replyUserId:replyUserId comment:comment type:self.type]doNext:^(YCCommentM *x) {
        SSELF;
        if (x) {
            [x onSetupHeightWithWidth:kScreenWidth];
            [self.modelsProxy addObject:x];
        }
    }];
}

@end
