//
//  YCViewModel+Logic.h
//  YouChi
//
//  Created by sam on 15/6/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.    YCAgricultureParameter
//

#import "YCViewModel.h"
#import "YCLocationManager.h"
#import "UMSocial.h"
#import "YCFixOrderM.h"

@interface YCImageModel : NSObject
///图片大小
@property (nonatomic,assign) CGSize imageSize;
///本地url
@property (nonatomic,strong) NSURL *fileUrl;
/////本地data
//@property (nonatomic,strong) NSData *fileData;
///阿里云key，不为nil表示已上传
@property (nonatomic,strong) NSString *objectKey;
///缓存key
@property (nonatomic,strong) NSString *cacheKey;
@end

@interface YCViewModel (Logic)<UMSocialUIDelegate>
///点赞
- (RACSignal *)likeById:(NSNumber *)Id isLike:(BOOL)like type:(YCCheatsType)type;

///收藏
- (RACSignal *)favoriteById:(NSNumber *)Id isFavorite:(BOOL)favorite type:(YCCheatsType)type;

/// 商品收藏
- (RACSignal *)goodsFavoriteById:(NSNumber *)Id isFavorite:(BOOL)favorite type:(YCCheatsType)type;

///删除评论
- (RACSignal *)deleteCommentById:(NSNumber *)Id type:(YCCheatsType)type;

///关注
- (RACSignal *)followUserById:(NSNumber *)Id isFollow:(BOOL)like;

///删除秘籍或者是随手拍
- (RACSignal *)deletetById:(NSNumber *)Id type:(YCCheatsType)type;

///默认地址
- (RACSignal *)setDefaultAddress:(NSNumber *)Id;

///添加到购物车    productSpecId 第几个规格
- (RACSignal *)addToCart:(NSNumber *)Id productSpecId:(NSNumber *) productSpecId count:(NSNumber *) count;

/// 取消订单
- (RACSignal *)cancelOrder:(NSNumber *)Id;

/// 取消订单-----
- (RACSignal *)cancelOrder:(NSNumber *)Id phone:(NSString *)phone refundRemark:(NSString *)refundRemark ;

/// 删除订单
- (RACSignal *)deletOrder:(NSNumber *)Id;

/// 确认收货
- (RACSignal *)confirmOrder:(NSNumber *)Id;

/// 获取最后时间戳
- (RACSignal *)lastCouponCreat;

///立即购买    productSpecId 第几个规格
- (RACSignal *)promptlyPayId:(NSNumber *)Id productSpecId:(NSNumber *) productSpecId count:(NSNumber *) count;
///立即购买 预售
- (RACSignal *)presellPromptlyPayId:(NSNumber *)Id productSpecId:(NSNumber *) productSpecId count:(NSNumber *) count;
///友米兑换
-(RACSignal *)onPromptlyPayId:(NSNumber *)productId specId:(NSNumber *)specId;

/// 支付请求封装
- (RACSignal *)payPath:(NSString *)path parameters:(NSDictionary *)param;

/// 马上支付(订单)
- (RACSignal *)payItNow:(NSNumber *)orderId;


- (RACSignal *)getMyCartList;

- (RACSignal *)getLocationInformationSignal;

- (RACSignal *)shareInView:(UIViewController *)vc title:(NSString *)msg text:(NSString *)text image:(UIImage *)img url:(NSString *)url shareId:(NSNumber *)shareId  type:(YCShareType )type;

- (RACSignal *)replySignalId:(NSNumber *)Id replyCommentId:(NSNumber *)replyCommentId replyUserId:(NSNumber *)replyUserId comment:(NSString *)comment type:(YCCheatsType)type;

/// 催他人结算
-(RACSignal *)onUrgePay:(NSNumber *)payUserId groupBuyId:(NSNumber *)groupBuyId;

///上传图片到阿里云，返回key数组
- (RACSignal *)uploadToAliyunWithImages:(NSArray *)array message:(void (^)(NSString *))message;
///上传图片到阿里云，返回<file?:alikey>数组
- (RACSignal *)uploadToAliyunWithImages:(NSArray<YCImageModel *> *)array messageSignal:(RACSubject *)message isShop:(BOOL)isShop;
@end

@interface YCPageViewModel (Logic)
- (RACSignal *)getUserInfo:(NSNumber *)Id parseClass:(Class )aClass parseKey:(NSString *)parseKey;

///获取评论列表
- (RACSignal *)getCommentsById:(NSNumber *)Id type:(YCCheatsType)type;

///解散团拼
-(RACSignal *)dissolveGroupBuyByGroupBuyId:(id)groupBuyId;
///取消团拼
-(RACSignal *)cancelGroupByGroupBuyId:(id)groupBuyId;
@end