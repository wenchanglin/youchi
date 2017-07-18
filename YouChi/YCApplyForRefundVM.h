//
//  YCApplyForRefundVM.h
//  YouChi
//
//  Created by 朱国林 on 16/1/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRandomPicturesVM.h"
#import "YCMyOrderM.h"
@interface YCApplyForRefundVM : YCRandomPicturesVM
///model
@property(nonatomic,strong) YCShopOrderProductM *aboutGoodsM;

///电话号码
@property(nonatomic,strong) NSString *phoneNumber;
///评论
@property(nonatomic,strong) NSString *comment;

///数量
@property(nonatomic,assign) NSInteger count;

PROPERTY_STRONG RACSubject *applyForRefundSignal;


- (RACSignal *)signalUploadWith:(RACSubject *)msg;
@end
