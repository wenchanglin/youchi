//
//  YCCommentVM.m
//  YouChi
//
//  Created by sam on 15/5/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommentVM.h"
#import "YCUserCommentM.h"

@implementation YCCommentVM
{
    NSMutableArray *chihuoyings,*guodans;
}
- (void)dealloc{
    //ok
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell1;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    return 200.f;
}


#pragma mark---我的果单评论列表,带分页
- (RACSignal *)mainSignal
{
    WSELF;
    return [[ENGINE POST_shop_array:apiCGetCommentNoticeList parameters:@{kToken:[YCUserDefault currentToken],} parseClass:[YCUserCommentM class] parseKey:@"noticeList" pageInfo:self.pageInfo]doNext:^(NSArray * x){
        SSELF;
        
        for (YCUserCommentM *m in x)
        {
            
            NSString *desc = [NSString stringWithFormat:@"%@\n\n%@",m.targetBody.name,m.targetBody.desc];
            NSRange  rang1 = [desc rangeOfString:m.targetBody.name];
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:desc];
            [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:rang1];
            [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang1];
            
            m.attributedDesc =attributed;
            
            //m.createdDate = [m.createdDate substringToIndex:16];
            
            
            
        }
        
        
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];
    
}



- (RACSignal *)onChihuoCommentreply:(NSString *)reply
{
    
    if (reply.length<=0) {
        return [RACSignal errorString:@"回复不能为空"];
    }
    
    return [ENGINE POSTBool:apiCSaveComment parameters:@{
                                                         kToken:[YCUserDefault currentToken],
                                                         @"youchiId":self.Id ,
                                                         @"comment":reply,
                                                         @"replyCommentId":self.replyCommentId,
                                                         @"replyUserId":self.replyUserId,
                                                         }];
    return nil;
}




- (RACSignal *)onMiJiCommentreply:(NSString *)reply
{
    
    
    if (reply.length<=0) {
        return [RACSignal errorString:@"回复不能为空"];
    }
    
    return [ENGINE POSTBool:apiRSaveComment parameters:@{
                                                         kToken:[YCUserDefault currentToken],
                                                         @"recipeId":self.Id ,
                                                         @"comment":reply,
                                                         @"replyCommentId":self.replyCommentId,
                                                         @"replyUserId":self.replyUserId,
                                                         }];
    return nil;
}

- (RACSignal *)onChiHuoDeleteSignal:(NSNumber *)Id
{
    return [ENGINE POSTBool:apiCDelComment parameters:@{
                                                        kToken:[YCUserDefault currentToken],
                                                        @"youchiCommentId":Id,
                                                        
                                                        }];
}
- (RACSignal *)onGuoDanDeleteSignal:(NSNumber *)Id{
    return [ENGINE POSTBool:apiRDelComment parameters:@{
                                                        kToken:[YCUserDefault currentToken],
                                                        @"recipeCommentId":Id,
                                                        
                                                        }];
}









@end
