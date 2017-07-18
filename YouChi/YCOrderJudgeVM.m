//
//  YCOrderJudgeVM.m
//  YouChi
//
//  Created by 朱国林 on 15/12/28.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCOrderJudgeVM.h"
#import "YCViewModel+Logic.h"
@implementation YCOrderJudgeVM

-(instancetype)initWithModel:(id)aModel{
    if (self ==[super initWithModel:aModel]) {
        self.title = @"评论晒单";
        self.smallModel =aModel;
    }
    return self;
}

//@"orderProductId":self.smallModel.orderProductId,
//@"productId":m.productId,
//@"orderId":self.smallModel.orderId,
//@"content":[self.comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//@"imageKeys":images,


- (RACSignal *)signalUploadWith:(RACSubject *)msg
{
    
    CHECK_SIGNAL(self.comment.length==0, @"描述不能为空");
    CHECK_SIGNAL(!self.orderProductId||!self.productId||!self.orderId, @"缺少参数");
    
    WSELF;
    RACSignal *upload = [self uploadToAliyunWithImages:self.modelsProxy messageSignal:msg isShop:YES];
    
    return [upload.collect flattenMap:^RACStream *(NSArray<NSDictionary *> *imageParams) {
        SSELF;
        
        NSMutableDictionary *param = @{
                                       kToken:[YCUserDefault currentToken],
                                       @"orderProductId":@(self.orderProductId),
                                       @"productId":@(self.productId),
                                       @"orderId":@(self.orderId),
                                       @"content":self.comment,
                                       }.mutableCopy;
        
        NSMutableArray *aliyunKeys = [NSMutableArray new];
        [imageParams enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [aliyunKeys addObject:obj.allValues.lastObject];
        }];
        if (aliyunKeys.count>0) {
            NSString  *imageKeysString = [NSString stringWithFormat:@"[%@]",[aliyunKeys componentsJoinedByString:@","]];
            param[@"imageKeysJson"] = imageKeysString;
        }
        
        
        return [ENGINE POSTBool:@"product/addShowOff.json" parameters:param];
    }];


}

@end
