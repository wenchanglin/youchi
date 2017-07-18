//
//  MGMHttpEngine.h
//  mallgo-merchant
//
//  Created by MALL GO on 14-9-22.
//  Copyright (c) 2014年 mall-go. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YCUserDefault.h"
#import "YCCatolog.h"
#import "YCCache.h"
#import "YCPageInfo.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#define ENGINE (YCHttpClient *)[YCHttpClient sharedClient]

static NSString *YCHttpClientProgress = @"YCHttpClientProgress";

@interface YCHttpRequestSerializer : AFHTTPRequestSerializer
@property (nonatomic, strong) NSMutableSet *etagUrlSet;
@property (nonatomic, strong) NSMutableDictionary *etagUrlDict;
@end

@interface YCHttpClient : AFHTTPSessionManager
@property (nonatomic, strong) YCHttpRequestSerializer <AFURLRequestSerialization> *requestSerializer;

+ (YCHttpClient *)sharedClient;
- (void)changeLoginId:(NSString *)loginId andAppLoginId:(NSString *)appLoginId;
- (NSString *)clientId;

///请求是否200，如点赞等
- (RACSignal *)POSTBool:(NSString *)URLString parameters:(id)parameters;

///请求json字典的result是字典或数组，无分页
//- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey cacheKey:(id )cacheKey useCache:(BOOL)useCache;


//- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass  cacheKey:(id )cacheKey useCache:(BOOL)useCache;


///请求json字典的result的数组，可带分页
//- (RACSignal *)POSTs:(NSString *)URLString parameters:(id)parameters parseClass:(Class )aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo cacheKey:(NSString *)cacheKey useCache:(BOOL)useCache;

///请求json字典的result的数组，可带分页

//- (RACSignal *)POSTs_2_0:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass cacheKey:(id )cacheKey useCache:(BOOL)useCache;

//上传图片
- (RACSignal *)POSTImages:(NSString *)URLString parameters:(id)parameters dataOrUrlDict:(NSDictionary *)dataDic parseClass:(Class)aClass  parseKey:(NSString *)parseKey;

- (RACSignal *)POSTImage:(NSString *)URLString parameters:(id)parameters data:(NSData *)data parseClass:(Class)aClass  parseKey:(NSString *)parseKey;


//1.2
//- (RACSignal *)POSTs_1_2:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo cacheKey:(id)cacheKey useCache:(BOOL)useCache;

//h5微信支付
- (RACSignal *)wxOrderParamters:(NSDictionary *)parameters;

//支付宝支付
- (RACSignal *)aliPayWithTradeNO:(NSString *)tradeNO productName:(NSString *)productName productDescription:(NSString *)productDescription amount:(NSString *)amount notifyURL:(NSString *)notifyURL;

//微信支付
- (RACSignal *)wxOrderWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId noncestr:(NSString *)noncestr timeStamp:(NSString *)timeStamp orderNo:(NSString *)orderNo package:(NSString *)package sign:(NSString *)sign;

//- (RACSignal *)POSTs_2_0:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo cacheKey:(id)cacheKey useCache:(BOOL)useCache;

///商城解析，yymodel
- (RACSignal *)POST_shop:(NSString *)URLString parameters:(NSDictionary *)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo;

- (RACSignal *)POST_shop_array:(NSString *)URLString parameters:(NSDictionary *)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo;
- (RACSignal *)POST_shop_array:(NSString *)URLString parameters:(NSDictionary *)parameters parseClass:(Class)aClass pageInfo:(YCPageInfo *)pageInfo;

- (RACSignal *)POST_shop_object:(NSString *)URLString parameters:(NSDictionary *)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey;

- (RACSignal *)POST_original:(NSString *)URLString parameters:(NSDictionary *)parameters;
@end






