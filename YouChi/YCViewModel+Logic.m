//
//  YCViewModel+Logic.m
//  YouChi
//
//  Created by sam on 15/6/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "MobClick.h"
#import "YCViewModel+Logic.h"
#import "YCHttpClient.h"
#import "YCCommentM.h"
#import "YCAboutGoodsM.h"
#import "YCItemDetailM.h"
#import <AliyunOSSiOS/OSSService.h>

@implementation YCImageModel
- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self modelInitWithCoder:coder];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self modelEncodeWithCoder:coder];
}
@end

@implementation YCViewModel (Logic)
#pragma mark - 点赞
- (RACSignal *)likeById:(NSNumber *)Id isLike:(BOOL)like type:(YCCheatsType)type
{
    CHECK_SIGNAL(!Id, @"点赞失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{kToken:[YCUserDefault currentToken],@"actionType":@(like)}.mutableCopy;
    
    if (type == YCCheatsTypeYouChi) {
        path = apiCLike;
        [param addEntriesFromDictionary:@{@"youchiId":Id,}];
    }
    
    else if (type == YCCheatsTypeRecipe) {
        path = @"app/common/like/recipeLikeAction.json";
        [param addEntriesFromDictionary:@{@"recipeId":Id,}];
    }
    
    else if (type == YCCheatsTypeVideo) {
        path = @"app/common/like/videoLikeAction.json";
        [param addEntriesFromDictionary:@{@"videoId":Id,}];
    }
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
    
}

#pragma mark - 收藏
- (RACSignal *)favoriteById:(NSNumber *)Id isFavorite:(BOOL)favorite type:(YCCheatsType)type{
    CHECK_SIGNAL(!Id, @"收藏失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{kToken:[YCUserDefault currentToken],@"actionType":@(favorite)}.mutableCopy;
    
    if (type == YCCheatsTypeYouChi) {
        path = @"app/common/favorite/youchiFavoriteAction.json";
        [param addEntriesFromDictionary:@{@"youchiId":Id,}];
    }
    
    else if (type == YCCheatsTypeRecipe) {
        path = @"app/common/favorite/recipeFavoriteAction.json";
        [param addEntriesFromDictionary:@{@"recipeId":Id,}];
    }
    
    else if (type == YCCheatsTypeVideo) {
        path = @"app/common/favorite/videoFavoriteAction.json";
        [param addEntriesFromDictionary:@{@"videoId":Id,}];
    }
    
    else if (type == YCCheatsTypeNews)/// 资讯收藏
    {
        path = @"app/common/favorite/newsFavoriteAction.json";
        [param addEntriesFromDictionary:@{@"newsId":Id,}];
    }
    
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
}

#pragma mark - 商品收藏
- (RACSignal *)goodsFavoriteById:(NSNumber *)Id isFavorite:(BOOL)favorite type:(YCCheatsType)type{
    CHECK_SIGNAL(!Id, @"收藏失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   @"markStatus":@(favorite)}.mutableCopy;
    
    
    if (type == YCCheatsTypeGoods) {
        
        path = @"product/markFavoriteProduct.json";
        [param addEntriesFromDictionary:@{@"productId":Id,}];
        
    }
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
}


#pragma mark - 删除评论
- (RACSignal *)deleteCommentById:(NSNumber *)Id type:(YCCheatsType)type
{
    CHECK_SIGNAL(!Id, @"删除评论失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{kToken:[YCUserDefault currentToken],}.mutableCopy;
    
    if (type == YCCheatsTypeYouChi) {
        path = @"app/common/comment/delYouchiComment.json";
        [param addEntriesFromDictionary:@{@"youchiCommentId":Id,}];
    }
    
    else if (type == YCCheatsTypeRecipe) {
        path = @"app/common/comment/delRecipeComment.json";
        [param addEntriesFromDictionary:@{@"recipeCommentId":Id,}];
    }
    
    else if (type == YCCheatsTypeVideo) {
        path = @"app/common/comment/delVideoComment.json";
        [param addEntriesFromDictionary:@{@"videoCommentId":Id,}];
    }
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
    
}

#pragma mark - 删除秘籍或者随手拍
- (RACSignal *)deletetById:(NSNumber *)Id type:(YCCheatsType)type
{
    CHECK_SIGNAL(!Id, @"删除失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{kToken:[YCUserDefault currentToken],}.mutableCopy;
    
    if (type == YCCheatsTypeYouChi) {
        path = @"app/my/deleter/delMyYouchi.json";
        [param addEntriesFromDictionary:@{@"youchiId":Id,}];//ok
    }
    
    else if (type == YCCheatsTypeRecipe) {
        path = @"app/my/deleter/delMyRecipe.json";
        [param addEntriesFromDictionary:@{@"recipeId":Id,}];//ok
    }
    
    else if (type == YCCheatsTypeGoods) {
        path = @"cart/deleteMyCartItem.json";
        [param addEntriesFromDictionary:@{@"cartItemId":Id,}];
    }
    
    else if (type == YCCheatsTypeAddress) {
        path = @"address/deletedUserAddress.json";
        [param addEntriesFromDictionary:@{@"addressId":Id,}];
    }
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
}

#pragma mark - 取消订单
- (RACSignal *)cancelOrder:(NSNumber *)Id
{
    CHECK_SIGNAL(!Id, @"取消订单失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    path = @"order/cancelOrder.json";
    [param addEntriesFromDictionary:@{@"orderId":Id,}];//ok
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
}

#pragma mark - 取消订单-----
- (RACSignal *)cancelOrder:(NSNumber *)Id phone:(NSString *)phone refundRemark:(NSString *)refundRemark{
    
    
    CHECK_SIGNAL(!Id, @"取消订单失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    path = @"order/cancelOrder.json";
    
    [param addEntriesFromDictionary:@{@"orderId":Id,}];
    [param addEntriesFromDictionary:@{@"phone":phone,}];
    [param addEntriesFromDictionary:@{@"refundRemark":refundRemark,}];
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
    
}



#pragma mark --删除订单
- (RACSignal *)deletOrder:(NSNumber *)Id
{
    CHECK_SIGNAL(!Id, @"删除失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    path = @"order/deleteOrderAfterComplete.json";
    
    [param addEntriesFromDictionary:@{@"orderId":Id,}];//ok
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
}


#pragma mark --确认收货
- (RACSignal *)confirmOrder:(NSNumber *)Id
{
    CHECK_SIGNAL(!Id, @"收货失败");
    NSString *path = nil;
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    path = @"order/confirmGotGoods.json";
    [param addEntriesFromDictionary:@{@"orderId":Id,}];//ok
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
}

#pragma mark - 设置默认地址
- (RACSignal *)setDefaultAddress:(NSNumber *)Id
{
    CHECK_SIGNAL(!Id, @"设置默认地址失败");
    NSString *path = @"address/setDefaultShopUserAddress.json";
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    [param addEntriesFromDictionary:@{@"userAddressId":Id,}];
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
}


/// 支付请求封装
- (RACSignal *)payPath:(NSString *)path parameters:(NSDictionary *)param;
{
    return [[ENGINE POST_shop_object:path parameters:param parseClass:[YCFixOrderM class] parseKey:kContent].deliverOnMainThread flattenMap:^RACStream *(YCFixOrderM *m) {
        if (m.payType.intValue == YCPayTypeWeixin) {
            return [ENGINE wxOrderWithAppId:m.appid partnerId:m.partnerid prepayId:m.prepayid noncestr:m.noncestr timeStamp:m.timestamp orderNo:m.orderNo package:m.package sign:m.sign];
        }
        
        else if (m.payType.intValue == YCPayTypeAliPay) {
            return [ENGINE aliPayWithTradeNO:m.tradeNO productName:m.productName productDescription:m.productDescription amount:m.amount notifyURL:m.notifyURL];
        }
        return [RACSignal error:[NSError errorWithDomain:kApiVersion code:0 userInfo:@{NSLocalizedDescriptionKey:@"未知支付类型，支付失败"}]];;
        
    }];
}

#pragma mark --订单列表马上支付
- (RACSignal *)payItNow:(NSNumber *)orderId
{
    CHECK_SIGNAL(!orderId, @"参数错误");
    
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    [param addEntriesFromDictionary:@{@"orderId":@(orderId.intValue),}];
    
    return [self payPath:@"order/payItNow.json" parameters:param];
    
}

- (RACSignal *)getMyCartList
{
    if (![YCUserDefault standardUserDefaults].isCurrentUserValid) {
        return [RACSignal empty];
    }
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken],
                            } ;
    return [[[ENGINE POST_shop_array:@"cart/getMyCartList.json" parameters:param parseClass:[YCAboutGoodsM class] pageInfo:nil ]map:^id(NSArray * x){
        
        NSInteger num = x.count;
        if (num == 0) {
            return nil;
        }
        return @(num).stringValue;
    }]catch:^RACSignal *(NSError *error) {
        return [RACSignal return:nil];
    }];
}

#pragma mark - 添加到购物车  productSpecId 第几个规格
- (RACSignal *)addToCart:(NSNumber *)Id productSpecId:(NSNumber *) productSpecId count:(NSNumber *) count
{
    CHECK_SIGNAL(!Id || !productSpecId, @"参数出错");
    NSString *path = @"cart/addCartItem.json";
    NSMutableDictionary *param = @{@"productId":Id,@"productSpecId":productSpecId,@"count":count,kToken:[YCUserDefault currentToken],}.mutableCopy;
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [[ENGINE POSTBool:path parameters:param]doNext:^(id x) {
        [[NSNotificationCenter defaultCenter]postNotificationName:YCAddCartItemNotification object:nil];
    }];
}

#pragma mark - 立即购买  productSpecId 第几个规格
- (RACSignal *)promptlyPayId:(NSNumber *)Id productSpecId:(NSNumber *) productSpecId count:(NSNumber *) count{
    NSString *path = @"order/buyItNow.json";
    NSMutableDictionary *param = @{@"productId":Id,@"productSpecId":productSpecId,@"qty":count,kToken:[YCUserDefault currentToken],}.mutableCopy;
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POST_shop_object:path parameters:param parseClass:[YCItemDetailM class] parseKey:nil];
}
#pragma mark - 立即购买（预售）
- (RACSignal *)presellPromptlyPayId:(NSNumber *)Id productSpecId:(NSNumber *) productSpecId count:(NSNumber *) count{
    NSString *path = @"orderPresell/getVirtualOrderPresell.json";
    NSMutableDictionary *param = @{@"productId":Id,@"productSpecId":productSpecId,@"qty":count,kToken:[YCUserDefault currentToken],}.mutableCopy;
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POST_shop_object:path parameters:param parseClass:[YCItemDetailM class] parseKey:nil];
}

#pragma mark --崔他人结算
#pragma mark-------催他结算
-(RACSignal *)onUrgePay:(NSNumber *)payUserId groupBuyId:(NSNumber *)groupBuyId {
    CHECK_SIGNAL(!payUserId, @"参数错误");
    NSString *path = @"groupBuy/urgePay.json";
    //TODO:groupBuyId没有输入
    NSMutableDictionary *param = @{
                                   @"payUserId":payUserId,
                                   @"groupBuyId":groupBuyId,
                                   kToken:[YCUserDefault currentToken],
                                   
                                   }.mutableCopy;
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    
    return [ENGINE POST_shop:path parameters:param parseClass:nil parseKey:nil pageInfo:nil];
    
}
#pragma mark - 友米兑换
-(RACSignal *)onPromptlyPayId:(NSNumber *)productId specId:(NSNumber *)specId{
    
    return [ENGINE POST_shop_object:@"order/getAntOrder.json" parameters:@{@"qty":@(1),@"specId":specId ,@"productId":productId,kToken:[YCUserDefault currentToken],} parseClass:[YCAboutGoodsM class] parseKey:kContent];
}



#pragma mark - 关注
- (RACSignal *)followUserById:(NSNumber *)Id isFollow:(BOOL)follow{
    CHECK_SIGNAL(!Id, @"关注失败");
    return [ENGINE POSTBool:apiGFollow parameters:@{
                                                    kToken:[YCUserDefault currentToken],
                                                    @"followUserId":Id,
                                                    @"actionType":@(follow),
                                                    }];
}

#pragma mark - 获得地理位置定位
- (RACSignal *)getLocationInformationSignal
{
    static RACSignal *signal;
    if (!signal) {
        signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[YCLocationManager sharedLocationManager] startUpdatingLocation:^(NSError *error, YCLocationInfo *locationInfo) {
                if (error) {
                    [subscriber sendError:error];
                } else {
                    [subscriber sendNext:locationInfo];
                    [subscriber sendCompleted];
                }
                
            }];
            return nil;
        }] replayLast];
    }
    
    return signal;
    
    
}

#pragma mark - 分享
- (RACSignal *)shareInView:(UIViewController *)vc title:(NSString *)title text:(NSString *)text image:(UIImage *)img url:(id )url shareId:(NSNumber *)shareId type:(YCShareType )type
{
    NSLog(@"\nshare >> %@\n",url);
    title = title?:@"友吃";
    text = text?:@"友吃分享";
    url = url?:@"www.youchi365.com";
    
    _setQQ(title,text, url);
    _setWechat(title ,text, url);
    _setSina(title, text, url);
    
    
    RACSignal *signal = [[self rac_signalForSelector:@selector(didFinishGetUMSocialDataInViewController:) fromProtocol:@protocol(UMSocialUIDelegate)] flattenMap:^id(RACTuple *tuple){
        RACTupleUnpack(UMSocialResponseEntity *response) = tuple;
        
        //根据`responseCode`得到发送结果,如果分享成功
        if(response.responseCode == UMSResponseCodeSuccess)
        {
            //得到分享到的微博平台名
            NSString *msg = [[NSString alloc]initWithFormat:@"成功分享到%@",response.data.allKeys.firstObject];
            if (type == YCShareTypeNone) {
                return [RACSignal errorString:msg];
            }
            
            NSMutableDictionary *param = @{kToken:[YCUserDefault currentToken]}.mutableCopy;
            if (shareId) {
                param[@"entityId"] = shareId;
            }
            param[@"type"] = @(type);
            return [[ENGINE POST_shop_object:@"app/common/share/shareSuccess.json" parameters:param parseClass:Nil parseKey:nil]flattenMap:^RACStream *(id value) {
                return [RACSignal return:msg];
            }];
        } else {
            return [RACSignal error:response.error];
        }
    }];
    
    
    
    [UMSocialSnsService presentSnsIconSheetView:vc
                                         appKey:UMAppKey
                                      shareText:text
                                     shareImage:img
                                shareToSnsNames:@[UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
    return signal;
}



void _setWechat(NSString *title,NSString *text,NSString *url)
{
    UMSocialData *data = [UMSocialData defaultData];
    UMSocialExtConfig *config = data.extConfig;
    config.wechatSessionData.title = config.wechatTimelineData.title = config.wechatFavoriteData.title = title;
    config.wechatSessionData.shareText = config.wechatTimelineData.shareText = config.wechatFavoriteData.shareText = text;
    config.wechatSessionData.url = config.wechatTimelineData.url = config.wechatFavoriteData.url = url;
}

void _setQQ(NSString *title,NSString *text,NSString *url)
{
    UMSocialData *data = [UMSocialData defaultData];
    UMSocialExtConfig *config = data.extConfig;
    config.qzoneData.title=title;
    config.qzoneData.url=url;
    config.qzoneData.shareText = text;
    
    config.qqData.title = title;
    config.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    config.qqData.url  = url;
    config.qqData.shareText = text;
}

void _setSina(NSString *title,NSString *text,NSString *url)
{
    UMSocialData *data = [UMSocialData defaultData];
    UMSocialExtConfig *config = data.extConfig;
    
    config.sinaData.urlResource.resourceType  = UMSocialUrlResourceTypeDefault;
    config.sinaData.urlResource.url  = url;
    config.sinaData.shareText = [[NSString alloc]initWithFormat:@"%@\n%@\n%@",text,title,url];
    
}


- (RACSignal *)replySignalId:(NSNumber *)Id replyCommentId:(NSString *)replyCommentId replyUserId:(NSString *)replyUserId comment:(NSString *)comment type:(YCCheatsType)type
{
    CHECK_SIGNAL(!Id || !comment, @"回复失败");
    CHECK_SIGNAL(comment.length==0, @"请输入");
    
    NSString *path = nil;
    NSMutableDictionary *param = @{kToken:[YCUserDefault currentToken],@"comment":comment,}.mutableCopy;
    if (replyCommentId) {
        param[@"replyCommentId"] = replyCommentId;
    }
    if (replyUserId) {
        param[@"replyUserId"] = replyUserId;
    }
    
    if (type == YCCheatsTypeYouChi) {
        path = @"app/common/comment/saveYouchiComment.json";
        [param addEntriesFromDictionary:@{@"youchiId":Id,}];
    }
    else if (type == YCCheatsTypeRecipe) {
        path = @"app/common/comment/saveRecipeComment.json";
        [param addEntriesFromDictionary:@{@"recipeId":Id,}];
    }
    else if (type == YCCheatsTypeVideo) {
        path = @"app/common/comment/saveVideoComment.json";
        [param addEntriesFromDictionary:@{@"videoId":Id,}];
    }
    
    //
    NSAssert(path, @"路径不能为空");
    return [[ENGINE POSTBool:path parameters:param]map:^id(id value) {
        
        return [YCCommentM modelWithDictionary:value];
    }];
}

#pragma mark - upload
- (RACSignal *)uploadToAliyunWithImages:(NSArray *)array message:(void (^)(NSString *))message
{
    WSELF;
    RACSignal *subscriber = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        SSELF;
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:ALI_accessKeyId
                                                                                                                secretKey:ALI_accessKeySecret];
        OSSClient *client = [[OSSClient alloc]initWithEndpoint:ALI_endpoint credentialProvider:credential];
        
        NSInteger uploadCount = array.count;
        __block NSInteger count = 0;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            
            // required fields
            put.bucketName = ALI_bucket;
            
            
            if ([obj isKindOfClass:[UIImage class]]) {
                obj = UIImageJPEGRepresentation(obj, QUALITY);
                put.uploadingData = obj;
            } else if ([obj isKindOfClass:[NSData class]]) {
                put.uploadingData = obj;
            } else if ([obj isKindOfClass:[NSURL class]]) {
                put.uploadingFileURL = obj;
                obj = [(NSURL *)obj absoluteString];
            } else {
                NSAssert(NO, @"出错");
            }
            
            put.objectKey = [[obj md5String]stringByAppendingString:@".jpg"];
            
            put.contentType = @"image/jpg";
            put.contentMd5 = @"";
            put.contentEncoding = @"";
            put.contentDisposition = @"";
            
            OSSTask * putTask = [client putObject:put];
            
            
            [putTask continueWithBlock:^id(OSSTask *task) {
                //NSLog(@"objectKey: %@", put.objectKey);
                if (!task.error) {
                    NSLog(@"upload object success!");
                    
                    if (message) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            message([NSString stringWithFormat:@"上传第%d张图片成功",(int)idx+1]);
                        });
                    }
                    [subscriber sendNext:put.objectKey];
                    
                    count = count+1;
                    if (uploadCount == count) {
                        [subscriber sendCompleted];
                    }
                    
                    
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                    NSString *err = [NSString stringWithFormat:@"上传第%d张图片失败",(int)idx+1];
                    [subscriber sendError:error(err)];
                }
                return nil;
                
            }];
            
            
        }];
        
        return nil;
    }];
    
    return subscriber;
    
}

- (RACSignal *)uploadToAliyunWithImages:(NSArray<YCImageModel *> *)array messageSignal:(RACSubject *)message isShop:(BOOL)isShop
{
    if (!array.count) {
        return [RACSignal empty];
    }
    RACSignal *subscriber = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @autoreleasepool {
            id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:ALI_accessKeyId
                                                                                                                    secretKey:ALI_accessKeySecret];
            OSSClient *client = [[OSSClient alloc]initWithEndpoint:ALI_endpoint credentialProvider:credential];
            
            NSInteger uploadCount = array.count;
            __block NSInteger sum = 0;
            
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YCImageModel *im = array[idx];
                NSString *dictKey = [NSString stringWithFormat:@"file%d",(int)idx+1];
                if (im.objectKey) {
                    if (message) {
                        [message sendNext:[NSString stringWithFormat:@"上传第%d张图片成功",(int)idx+1]];
                    }
                    [subscriber sendNext:@{dictKey:im.objectKey}];
                    sum = sum+1;
                    if (uploadCount == sum) {
                        [subscriber sendCompleted];
                    }
                } else {
                    
                    
                    NSString *objectKey = [NSString stringWithFormat:@"$%.f$%.f$%@.jpg",im.imageSize.width,im.imageSize.height,im.fileUrl.absoluteString.md5String];
                    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                    put.uploadingFileURL = im.fileUrl;
                    
                    
                    // required fields
                    put.bucketName = isShop?ALI_bucket:ALI_bucket_suishoupai;
                    put.objectKey = objectKey;
                    
                    put.contentType = @"image/jpg";
                    
                    OSSTask * putTask = [client putObject:put];
                    
                    
                    [putTask continueWithBlock:^id(OSSTask *task) {
                        
                        if (!task.error) {
                            NSLog(@"upload object success!");
                            NSLog(@"objectKey: %@", put.objectKey);
                            if (message) {
                                [message sendNext:[NSString stringWithFormat:@"上传第%d张图片成功",(int)idx+1]];
                            }
                            
                            im.objectKey = objectKey;
                            [subscriber sendNext:@{dictKey: objectKey}];
                            
                            sum = sum+1;
                            if (uploadCount == sum) {
                                [message sendCompleted];
                                [subscriber sendCompleted];
                            }
                            
                            
                        } else {
                            NSLog(@"upload object failed, error: %@" , putTask.error);
                            NSString *err = [NSString stringWithFormat:@"上传第%d张图片失败,%@",(int)idx+1,putTask.error.localizedDescription];
                            [subscriber sendError:error(err)];
                        }
                        return nil;
                        
                    }];
                    
                }
                
            }];
            
        }
        return nil;
    }];
    
    return subscriber;
    
}
@end


@implementation YCPageViewModel (Logic)
- (RACSignal *)getUserInfo:(NSNumber *)userId parseClass:(__unsafe_unretained Class)aClass parseKey:(NSString *)parseKey
{
    CHECK_SIGNAL(!userId, @"获取信息失败");
    return [ENGINE POST_shop_object:apiGetOtherDetailes parameters:@{
                                                                     @"userId":userId,
                                                                     kToken:[YCUserDefault currentToken],
                                                                     
                                                                     } parseClass:aClass parseKey:parseKey];
}

- (RACSignal *)getUserInfo:(NSNumber *)userId
{
    CHECK_SIGNAL(!userId, @"获取信息失败");
    return [ENGINE POST_shop_object:apiGetOtherDetailes parameters:@{
                                                                     @"userId":userId,
                                                                     kToken:[YCUserDefault currentToken],
                                                                     
                                                                     } parseClass:[YCLoginUserM class] parseKey:@"appUser"];
    
}

- (RACSignal *)getCommentsById:(NSNumber *)Id type:(YCCheatsType)type
{
    CHECK_SIGNAL(!Id, @"获取评论失败");
    NSString *path,*parseKey = nil;
    NSMutableDictionary *param = @{kToken:[YCUserDefault currentToken],}.mutableCopy;
    
    if (type == YCCheatsTypeYouChi) {
        path = @"app/common/comment/getYouchiCommentList.json";
        [param addEntriesFromDictionary:@{@"youchiId":Id,}];//ok
        parseKey = @"youchiCommentList";
    }
    else if (type == YCCheatsTypeRecipe) {
        path = @"app/common/comment/getRecipeCommentList.json";
        [param addEntriesFromDictionary:@{@"recipeId":Id,}];//ok
        parseKey = @"recipeCommentList";
    }
    else if (type == YCCheatsTypeVideo) {
        path = @"app/common/comment/getVideoCommentList.json";
        [param addEntriesFromDictionary:@{@"videoId":Id,}];
        parseKey = @"videoCommentList";
    }
    else if (type == YCCheatsTypeNews){
        path = @"app/common/comment/getNewsCommentList.json";
        [param addEntriesFromDictionary:@{@"newsId":Id,}];
        parseKey = @"videoCommentList";
    }
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POST_shop_array:path parameters:param parseClass:[YCCommentM class] parseKey:parseKey pageInfo:self.pageInfo];
}


#pragma mark-------解散团拼
-(RACSignal *)dissolveGroupBuyByGroupBuyId:(id)groupBuyId
{
    NSString *path = @"groupBuy/dissolveGroupBuy.json";
    return [ENGINE POST_shop:path parameters:@{
                                               @"groupBuyId":groupBuyId,
                                               kToken:[YCUserDefault currentToken],
                                               } parseClass:nil parseKey:nil pageInfo:nil];
    
    
}

#pragma mark-------取消团拼  groupBuy/kickOne.json
-(RACSignal *)cancelGroupByGroupBuyId:(id)groupBuyId
{
    
    NSString *path = @"groupBuy/cancelGroupBuy.json";
    //TODO:groupBuyId没有输入
    NSDictionary *param = @{
                            @"groupBuyId":groupBuyId,
                            kToken:[YCUserDefault currentToken],
                            };
    NSAssert(path, @"路径不能为空,说明没有这个type");
    
    return [ENGINE POST_shop:path parameters:param parseClass:nil parseKey:nil pageInfo:nil];
    
    
}
@end