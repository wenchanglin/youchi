//
//  YCOrderJudgeVM.h
//  YouChi
//
//  Created by 朱国林 on 15/12/28.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCRandomPicturesVM.h"
#import "YCMyOrderM.h"



@interface YCOrderJudgeVM : YCPageViewModel

///SmallModel
@property(nonatomic,strong) YCShopOrderProductM *smallModel;
///评论
@property(nonatomic,strong) NSString *comment;

///请求参数
@property(nonatomic,assign) int orderId,orderProductId,productId;
- (RACSignal *)signalUploadWith:(RACSubject *)msg;
@end
