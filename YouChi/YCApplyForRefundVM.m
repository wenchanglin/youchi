//
//  YCApplyForRefundVM.m
//  YouChi
//
//  Created by 朱国林 on 16/1/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCApplyForRefundVM.h"
#import "YCViewModel+Logic.h"

@implementation YCApplyForRefundVM


-(instancetype)initWithModel:(id)aModel{
    if (self =[super initWithModel:aModel]) {
        self.title = @"申请退货";
        self.aboutGoodsM = aModel;
        self.Id = self.aboutGoodsM.orderProductId;
        self.count = self.aboutGoodsM.qty.intValue;
    }
    return self;
}

GETTER_LAZY_SUBJECT(applyForRefundSignal);


//OrderProductId	Long		YES	子订单ID
//imageKeysJson	String		YES	图片Key数组Json数据格式
//phoneNumber	String		YES	电话号码
//desc	String		YES	退货申请描述
//qty	String		YES	退货的数量
- (RACSignal *)signalUploadWith:(RACSubject *)msg
{
    
    CHECK_SIGNAL(self.comment.length<=0, @"请写明您要退货的原因");
    CHECK_SIGNAL(self.phoneNumber.length<=0, @"请留下您的联系电话");
    CHECK_SIGNAL(!self.aboutGoodsM.orderProductId, @"参数出错");
    
    WSELF;
    RACSignal *upload = [self uploadToAliyunWithImages:self.modelsProxy messageSignal:msg isShop:YES];
    
    return [upload.collect flattenMap:^RACStream *(NSArray<NSDictionary *> *imageParams) {
        SSELF;
        
        NSMutableDictionary *param = @{
                                       kToken:[YCUserDefault currentToken],
                                       @"desc":self.comment,
                                       @"OrderProductId":self.aboutGoodsM.orderProductId,
                                       @"phoneNumber":self.phoneNumber,
                                       @"qtyString":@(self.count),
                                       
                                       }.mutableCopy;
        
        NSMutableArray *aliyunKeys = [NSMutableArray new];
        [imageParams enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [aliyunKeys addObject:obj.allValues.lastObject];
        }];
        if (aliyunKeys.count>0) {
            NSString  *imageKeysString = [NSString stringWithFormat:@"[%@]",[aliyunKeys componentsJoinedByString:@","]];
            param[@"imageKeysJson"] = imageKeysString;
        }
        
        return [ENGINE POSTBool:@"order/returnGoodsByOrderProductId.json" parameters:param];
    }];
    
    
    
}
//OrderProductId	Long		YES	子订单ID
//imageKeysJson	String		YES	图片Key数组Json数据格式
//phoneNumber	String		YES	电话号码
//desc	String		YES	退货申请描述
//qty	String		YES	退货的数量
@end
