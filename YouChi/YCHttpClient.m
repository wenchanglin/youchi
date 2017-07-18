//
//  MGMHttpEngine.m
//  mallgo-merchant
//
//  Created by MALL GO on 14-9-22.
//  Copyright (c) 2014年 mall-go. All rights reserved.
//

#import "YCHttpClient.h"
#import <OGCryptoHash/NSString+OGCryptoHash.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <Mantle/Mantle.h>
#import <sys/time.h>
#import "YCDefines.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import <YYKit/YYKit.h>

@interface YCHttpClient () {
    
    NSString *_apiVersion;
    NSString *_sign;
    
    NSString *_loginId;
    NSString *_clientId;
    NSString *_timeStamp;
    
    NSString *_clientType;
    NSString *_clientVersion;
    NSString *_clientOsVersion;
    
    
}
@property (nonatomic,strong,readonly) LevelDB *ldb;
@end

/*
 NSURL *baseURL = [NSURL URLWithString:@"http://example.com/v1/"];
 [NSURL URLWithString:@"foo" relativeToURL:baseURL];                  // http://example.com/v1/foo
 [NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL];          // http://example.com/v1/foo?bar=baz
 [NSURL URLWithString:@"/foo" relativeToURL:baseURL];                 // http://example.com/foo
 [NSURL URLWithString:@"foo/" relativeToURL:baseURL];                 // http://example.com/v1/foo
 [NSURL URLWithString:@"/foo/" relativeToURL:baseURL];                // http://example.com/foo/
 [NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL]; // http://example2.com/
 */

@implementation YCHttpClient

@synthesize requestSerializer;

/*
 1:创建单利对象
 2:host 网站前坠
 */

+ (YCHttpClient *)sharedClient {
    static YCHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *hostUrl = [NSURL URLWithString:host];
        _sharedClient = [[self alloc]initWithBaseURL:hostUrl];
    });
    return _sharedClient;
}


/*
 1:父类初始化方法（AFHTTPSessionManager）
 2:timeoutInterval 超时时间
 */

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self _setClientInfo];
        self.requestSerializer.timeoutInterval = 30.f;
        
        
        self.completionQueue = dispatch_queue_create("com.quicklyant.youchi", DISPATCH_QUEUE_CONCURRENT);
        
        [self.reachabilityManager startMonitoring];
    }
    return self;
}


/*
 1:创建KV数据库对象
 */

- (LevelDB *)ldb
{
    return [YCCache sharedCache].dataBase;
}

/*
 1:loginId 登陆获得ID
 2:appLoginId
 */

- (void)changeLoginId:(NSString *)loginId andAppLoginId:(NSString *)appLoginId
{
    _loginId = [appLoginId copy];
    
    
    
    if (loginId.length>0) {
        [[YCCache sharedCache]openDataBaseByLoginId:loginId];
    } else {
        [[YCCache sharedCache]closeDataBase];
    }
    
}

/*
 获取用户ID
 */

- (NSString *)clientId
{
    return _clientId;
}

///设置客户端的信息
- (void)_setClientInfo
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    _clientId = _loadClientId();
    
    _apiVersion = @"2.0";
    _clientType = @"iOS";
    
    _clientVersion = @"YouChi";
    _clientOsVersion = [[NSString alloc]initWithFormat:@"%@.%@",app_Version,app_build];
    _timeStamp = _creatTimeStamp();
    
    //测试
#if DEBUG
    _clientId = @"1234567890";
#endif
    
}

#pragma mark - 生成基本认证参数

static inline NSString *_loadClientId()
{
    //客户端设备唯一号
    UICKeyChainStore *kcs = [UICKeyChainStore keyChainStore];
    NSString *cid = [kcs stringForKey:@"uuid"];
    if (!cid) {
        
        cid = [NSUUID UUID].UUIDString;
        [kcs setString:cid forKey:@"uuid"];
    }
    return cid;
}


/*
 创建时间戳
 */

static inline NSString *_creatTimeStamp()
{
    //时间戳
    char fmt[32];
    
    struct timeval tv;
    
    struct tm *tm;
    
    gettimeofday(&tv, NULL);
    
    tm = localtime(&tv.tv_sec);
    
    strftime(fmt, sizeof(fmt), "%Y-%m-%d %H:%M:%S", tm);
    
    return [[NSString alloc]initWithUTF8String:fmt];
}

static inline NSString *_digestContent(NSString *key,NSString *content)
{
    
    return [content og_stringUsingCryptoHashFunction:OGCryptoHashFunctionSHA256 hmacSignedWithKey:key] ;
    
}

static inline NSString *_digestContent16(NSString *key,NSString *content)
{
    return [[content og_stringUsingCryptoHashFunction:OGCryptoHashFunctionSHA256 hmacSignedWithKey:key]substringToIndex:16];
    
}

static inline NSString *_genSign(NSString *loginId_,NSString *clientId_,NSDictionary *dict)
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:dict.count];
    
    NSArray *keys = [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *k in keys) {
        [arr addObject:dict[k]];
    }
    NSString *params = [arr componentsJoinedByString:@""];
    
    NSString *key = _digestContent16(loginId_, clientId_);
    
    
    NSString *gen = _digestContent(key, params);
    return gen;
}



static inline NSString *_errorStr(int code){
    NSString *errorStr;
    switch (code) {
        case NSURLErrorUnknown:
        {errorStr =@"未知错误";}
            break;
        case NSURLErrorCancelled:
        {errorStr =@"请求已取消";}
            break;
        case NSURLErrorBadURL:
        {errorStr =@"URL不正确";}
            break;
        case NSURLErrorTimedOut:
        {errorStr =@"请求超时";}
            break;
        case NSURLErrorUnsupportedURL:
        {errorStr =@"不支持的URL";}
            break;
        case NSURLErrorCannotFindHost:
        {errorStr =@"找不到服务器";}
            break;
        case NSURLErrorCannotConnectToHost:
        {errorStr =@"连接不到服务器";}
            break;
        case NSURLErrorDataLengthExceedsMaximum:
        {errorStr =@"请求数据过大";}
            break;
        case NSURLErrorNetworkConnectionLost:
        {errorStr =@"网络连接丢失";}
            break;
        case NSURLErrorDNSLookupFailed:
        {errorStr =@"域名查找失败";}
            break;
        case NSURLErrorHTTPTooManyRedirects:
        {errorStr =@"网络请求过多";}
            break;
        case NSURLErrorResourceUnavailable:
        {errorStr =@"资源不可用";}
            break;
        case NSURLErrorNotConnectedToInternet:
        {errorStr =@"未连接到互联网";}
            break;
        case NSURLErrorRedirectToNonExistentLocation:
        {errorStr =@"重定向不存在";}
            break;
        case NSURLErrorBadServerResponse:
        {errorStr =@"服务器响应错误";}
            break;
        case NSURLErrorUserCancelledAuthentication:
        {errorStr =@"用户取消认证";}
            break;
        case NSURLErrorCannotDecodeRawData:
        {errorStr =@"无法解码原始数据";}
            break;
        case NSURLErrorCannotDecodeContentData:
        {errorStr =@"无法解码内容数据";}
            break;
        case NSURLErrorCannotParseResponse:
        {errorStr =@"无法解析请求";}
            break;
        case NSURLErrorFileDoesNotExist:
        {errorStr =@"文件不存在";}
            break;
        case NSURLErrorFileIsDirectory:
        {errorStr = @"文件目录出错";}
            break;
        case NSURLErrorNoPermissionsToReadFile:
        {errorStr =@"没有读文件权限";}
            break;
        case NSURLErrorSecureConnectionFailed:
        {errorStr =@"安全连接失败";}
            break;
        case NSURLErrorServerCertificateHasBadDate:
        {errorStr =@"服务器日期证书有错误";}
            break;
        case NSURLErrorServerCertificateUntrusted:
        {errorStr =@"服务器证书不受信任";}
            break;
        case NSURLErrorServerCertificateHasUnknownRoot:
        {errorStr =@"服务器证书错误";}
            break;
        case NSURLErrorServerCertificateNotYetValid:
        {errorStr =@"服务器证书尚未有效";}
            break;
        case NSURLErrorClientCertificateRejected:
        {errorStr =@"客户端认证拒绝";}
            break;
        case NSURLErrorClientCertificateRequired:
        {errorStr =@"客户端证书无效";}
            break;
        case NSURLErrorCannotCreateFile:
        {errorStr =@"无法创建文件";}
            break;
        case NSURLErrorCannotOpenFile:
        {errorStr =@"无法打开文件";}
            break;
        case NSURLErrorCannotWriteToFile:
        {errorStr =@"无法写入文件";}
            break;
        case NSURLErrorCannotRemoveFile:
        {errorStr =@"无法删除文件";}
            break;
        case NSURLErrorDownloadDecodingFailedMidStream:
        {errorStr =@"下载解码失败";}
            break;
        case NSURLErrorDownloadDecodingFailedToComplete:
        {errorStr =@"下载解码未能完成";}
            break;
    }
    errorStr = [NSString stringWithFormat:@"%@,错误代码%d",errorStr,code];
    return errorStr;
    
}

NSError *_localizeRrror(NSError *error){
    error = [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey:_errorStr((int)error.code)}];
    return error;
}

/*
 URLString 网站后缀
 etagKey 缓存Key
 pageNo 分页
 */

#pragma mark -

- (void)_setupEtagWithUrl:(NSString *)URLString etagKey:(NSString *)etagKey pageNo:(NSNumber *)pageNo
{
    
}



/*
 将部分参数拼接在一个完整的字典中
 
 params  参数字典（部分参数都在里面）
 addSign  是否添加签名
 */

#pragma mark -
- (NSDictionary *)setUpParams:(NSDictionary *)params addSign:(BOOL)addSign
{
    NSMutableDictionary *requestParams = [NSMutableDictionary new];
    
    [requestParams setValue:_apiVersion forKey:kApiVersion];
    [requestParams setValue:_clientType forKey:kClientType];
    
    [requestParams setValue:_clientId forKey:kClientId];
    [requestParams setValue:_clientVersion forKey:kClientVersion];
    [requestParams setValue:_clientOsVersion forKey:kClientOsVersion];
    [requestParams setValue:_timeStamp forKey:kTimeStamp];
    
    
    [requestParams addEntriesFromDictionary:params];
    
    NSString *token = requestParams[kToken];
    if (token.length<=0) {
        [requestParams removeObjectForKey:kToken];
    }
    
    NSString *lid = params[kLoginId]?:[_loginId copy];
    
    if (lid) {
        //TODO:loginID改了
        [requestParams setValue:lid forKey:kLoginId];
    } else {
        [requestParams setValue:@"12345678" forKey:kLoginId];
    }
    
    
    if (addSign && lid) {
        [requestParams setValue:_genSign(lid,_clientId,requestParams) forKey:kSign];
    }
    
    
    return requestParams;
}



/*
 
 URLString  网站后缀
 parameters 解析对象
 success 返回成功block
 failure 返回失败block  121.41.35.184    @"http://shop2.youchi365.com/"
 */

#pragma mark -

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    //return [super POST:URLString parameters:parameters success:success failure:failure];
    //*
#if SETTING == 0
    if ([URLString hasPrefix:@"app/"]) {
        ///非商城
        URLString = [host stringByAppendingString:URLString];
    } else {
        ///商城
        URLString = [youchi_shop stringByAppendingString:URLString];
    }
#else
    if ([URLString hasPrefix:@"app/"]) {
        ///非商城
        URLString = [host stringByAppendingString:URLString];
    } else {
        ///商城
        URLString = [youchi_shop stringByAppendingString:URLString];
    }
    
#endif
    ///2.0不需要
    parameters = [self setUpParams:parameters addSign:YES];
    
    NSURLSessionDataTask *sdt = [super POST:URLString parameters:parameters success:success failure:failure];
    NSURLRequest *req = sdt.originalRequest;
    NSLog(@"\n>>url = %@\n>>header = %@\n>>>param = %@\n",req.URL.absoluteString.description,req.allHTTPHeaderFields.description,parameters.description);
    return sdt;
    //*/
}

///普通post请求
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    if ([URLString hasPrefix:@"app/"]) {
        ///非商城
        URLString = [host stringByAppendingString:URLString];
    } else {
        ///商城
        URLString = [youchi_shop stringByAppendingString:URLString];
    }

    
    parameters = [self setUpParams:parameters addSign:YES];
    
    NSURLSessionDataTask *sdt = [super POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
    NSURLRequest *req = sdt.originalRequest;
    NSLog(@"\n>>url = %@\n>>header = %@\n>>>param = %@\n",req.URL.absoluteString.description,req.allHTTPHeaderFields.description,parameters.description);
    return sdt;
}

///上传图片post请求
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    
    //    if ([URLString hasPrefix:@"app/"]) {
    //        ///非商城
    //        URLString = [host stringByAppendingString:URLString];
    //    } else {
    //        ///商城
    //        URLString = [youchi_shop stringByAppendingString:URLString];
    //    }
    
    
    
    parameters = [self setUpParams:parameters addSign:YES];
    
    NSURLSessionDataTask *sdt = [super POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
    NSURLRequest *req = sdt.originalRequest;
    NSLog(@"\n>>url = %@\n>>header = %@\n>>>param = %@\n",req.URL.absoluteString.description,req.allHTTPHeaderFields.description,parameters.description);
    return sdt;
}


/*
 1:
 2:
 <##>
 <##>
 */

#pragma mark -

- (RACSignal *)POSTBool:(NSString *)URLString parameters:(id)parameters
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject);
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                [subscriber sendNext:responseObject[kResult]];
                [subscriber sendCompleted];
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:_localizeRrror(error)];
        }];
        
        return nil;
    }];
    
    
    return signal;
}


#pragma mark -
- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey cacheKey:(id )cacheKey useCache:(BOOL)useCache
{
    if (useCache) {
        if (cacheKey) {
            cacheKey = [URLString stringByAppendingFormat:@"-%@",cacheKey];
        } else {
            cacheKey = URLString;
        }
    }
    
    NSString *etagKey = nil;
    if (useCache) {
        
    }
    
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject.description);
            
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                __autoreleasing NSError *error;
                id resultObject = responseObject[kResult];
                if (parseKey) {
                    resultObject = [resultObject valueForKeyPath:parseKey];
                }
                
                if (aClass) {
                    if ([resultObject isKindOfClass:[NSDictionary class]]) {
                        resultObject = [MTLJSONAdapter modelOfClass:aClass fromJSONDictionary:resultObject error:&error];
                    }
                    
                    else if ([resultObject isKindOfClass:[NSArray class]]) {
                        
                        resultObject = [MTLJSONAdapter modelsOfClass:aClass fromJSONArray:resultObject error:&error];
                    }
                    
                }
                
                if (error) {
                    [subscriber sendError:error];
                } else {
                    if (useCache) {
                        
                        
                        
                    }
                    
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                }
                
            } else {
                
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"😢"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSHTTPURLResponse *response = (id)task.response;
            
            if (response.statusCode == 304) {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                    NSLog(@"\n>> 缓存 \n");
                } else {
                    [subscriber sendError:_localizeRrror(error)];
                }
            } else {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                }
                [subscriber sendError:_localizeRrror(error)];
            }
            
            
        }];
        
        return nil;
    }];
    
    return signal;
}

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass cacheKey:(id)cacheKey useCache:(BOOL)useCache
{
    return [self POST:URLString parameters:parameters parseClass:aClass parseKey:nil cacheKey:cacheKey useCache:useCache];
}


#pragma mark -
- (RACSignal *)POSTs:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo cacheKey:(id)cacheKey useCache:(BOOL)useCache
{
    
    if (useCache) {
        if (cacheKey) {
            cacheKey = [URLString stringByAppendingFormat:@"-%@",cacheKey];
        } else {
            cacheKey = URLString;
        }
    }
    
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    int pageNo = pageInfo.pageNo;
    
    if (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId) {
        pageNo = 1;
        param[@"pageNo"] = @(pageNo);
        param[@"pageSize"] = @(pageInfo.pageSize);
        
    }
    
    else if (pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId) {
        pageNo++;
        param[@"firstId"] = pageInfo.loadmoreId;
        param[@"pageNo"] = @(pageNo);
        param[@"pageSize"] = @(pageInfo.pageSize);
        
    }
    /*
     else {
     param[@"pageNo"] = @(pageNo);
     param[@"pageSize"] = @(pageInfo.pageSize);
     }
     */
    
    cacheKey = [cacheKey stringByAppendingFormat:@"-%d-%d",pageNo,pageInfo.pageSize];
    
    
    
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self POST:URLString parameters:param progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject.description);
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                __autoreleasing NSError *error;
                id resultObject = responseObject[kResult];
                BOOL isNull = [resultObject isKindOfClass:[NSNull class]];
                
                
                if (pageInfo && !isNull) {
                    [pageInfo setValuesForKeysWithDictionary:resultObject];
                }
                id arr = nil;
                if (parseKey && !isNull) {
                    arr = resultObject[parseKey];
                } else {
                    arr = resultObject;
                }
                if (aClass && [arr isKindOfClass:[NSArray class]]) {
                    resultObject = [MTLJSONAdapter modelsOfClass:aClass fromJSONArray:arr error:&error];
                } else if (aClass && [arr isKindOfClass:[NSDictionary class]]){
                    resultObject = [MTLJSONAdapter modelOfClass:aClass fromJSONDictionary:arr error:&error];
                } else {
                    resultObject = arr;
                }
                
                
                if (error) {
                    [subscriber sendError:error];
                } else {
                    
                    
                    if (useCache) {
                        NSHTTPURLResponse *response = (id)task.response;
                        
                    }
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )||(pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                    
                }
                
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"😢"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSHTTPURLResponse *response = (id)task.response;
            //NSLog(@"\n>>%@\n",response);
            
            if (response.statusCode == 304) {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )|| (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                    NSLog(@"\n>> 缓存 \n");
                }else {
                    [subscriber sendError:_localizeRrror(error)];
                }
            } else {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )|| (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                }
                
                [subscriber sendError:_localizeRrror(error)];
            }
            
            
        }];
        return nil;
    }];
    
    return signal;
}


#pragma mark -
- (RACSignal *)POSTImages:(NSString *)URLString parameters:(NSDictionary *)parameters dataOrUrlDict:(NSDictionary *)dataOrUrlDict parseClass:(Class)aClass parseKey:(NSString *)parseKey
{
    parameters = [self setUpParams:parameters addSign:YES];
    NSLog(@"constructingBody : %@",dataOrUrlDict);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        __weak NSURLSessionTask *task = [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            __block NSError *error;
            [dataOrUrlDict enumerateKeysAndObjectsUsingBlock:^(NSString *name, id obj, BOOL *stop) {
                if (obj) {
                    if ([obj isKindOfClass:[NSData class]]) {
                        [formData appendPartWithFileData:obj name:name fileName:[name stringByAppendingString:@".jpg"] mimeType:@"image/jpg"];
                    }
                    
                    else if ([obj isKindOfClass:[NSURL class]]) {
                        [formData appendPartWithFileURL:obj name:name fileName:[name stringByAppendingString:@".png"] mimeType:@"image/png" error:&error];
                        if (error) {
                            [subscriber sendError:error];
                        }
                    }
                }
            }];
            
            
            
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            [[NSNotificationCenter defaultCenter]postNotificationName:YCHttpClientProgress object:uploadProgress];
            //NSLog(@"progress = %.10f",uploadProgress.fractionCompleted);
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject);
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                
                id resultObject = responseObject[kResult];
                
                if (parseKey) {
                    resultObject = [resultObject valueForKey:parseKey];
                }
                if (aClass) {
                    if ([resultObject isKindOfClass:[NSDictionary class]]) {
                        resultObject = [aClass modelWithDictionary:resultObject];
                    } else if ([resultObject isKindOfClass:[NSArray class]]) {
                        resultObject = [NSArray modelWithDictionary:resultObject];
                    }
                    
                }
                
                
                
                [subscriber sendNext:resultObject];
                [subscriber sendCompleted];
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"😢"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:_localizeRrror(error)];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    
    return signal;
}

- (RACSignal *)POSTImage:(NSString *)URLString parameters:(id)parameters data:(NSData *)data parseClass:(Class)aClass parseKey:(NSString *)parseKey
{
    return [self POSTImages:URLString parameters:parameters dataOrUrlDict:@{@"file1":data} parseClass:aClass parseKey:parseKey];
}


#pragma mark -
- (RACSignal *)POSTs_1_2:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo cacheKey:(id)cacheKey useCache:(BOOL)useCache
{
    if (useCache) {
        if (cacheKey) {
            cacheKey = [URLString stringByAppendingFormat:@"-%@",cacheKey];
        } else {
            cacheKey = URLString;
        }
    }
    
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    int pageNo = pageInfo.pageNo;
    
    if (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId) {
        
        pageNo = 1;
        param[kPageNo] = @(pageNo);
        param[kPageSize] = @(pageInfo.pageSize);
    }
    
    else if (pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId) {
        pageNo++;
        param[kFirstId] = pageInfo.loadmoreId;
        param[kPageNo] = @(pageNo);
        param[kPageSize] = @(pageInfo.pageSize);
        
    }
    /*
     else {
     param[@"pageNo"] = @(pageNo);
     param[@"pageSize"] = @(pageInfo.pageSize);
     }
     */
    
    cacheKey = [NSString stringWithFormat:@"%@-%d-%d",cacheKey?:@"",pageNo,pageInfo.pageSize];
    
   
    
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self POST:URLString parameters:param progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSLog(@"\n>>%@\n %@\n",URLString,[responseObject descriptionWithLocale:@"cn"]);
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                __autoreleasing NSError *error;
                id resultObject = responseObject[kResult];
                
                BOOL isNull = [resultObject isKindOfClass:[NSNull class]];
                
                NSDictionary *pageInfoDict = nil;
                if (pageInfo && !isNull && (pageInfoDict = resultObject[@"pageInfo"]) && ![pageInfoDict isKindOfClass:[NSNull class]]) {
                    [pageInfo setValuesForKeysWithDictionary:pageInfoDict];
                }
                
                id arr = nil;
                if (parseKey && !isNull) {
                    arr = resultObject[parseKey];
                } else {
                    arr = resultObject;
                }
                
                if (aClass && [arr isKindOfClass:[NSArray class]]) {
                    resultObject = [MTLJSONAdapter modelsOfClass:aClass fromJSONArray:arr error:&error];
                } else if (aClass && [arr isKindOfClass:[NSDictionary class]]){
                    resultObject = [MTLJSONAdapter modelOfClass:aClass fromJSONDictionary:arr error:&error];
                } else {
                    resultObject = arr;
                }
                
                if (error) {
                    [subscriber sendError:error];
                } else {
                    
                    
                    if (useCache) {
                       
                    }
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )||(pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                }
                
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"😢"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSHTTPURLResponse *response = (id)task.response;
            //NSLog(@"\n>>%@\n",response);
            
            if (response.statusCode == 304) {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )|| (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                    NSLog(@"\n>> 缓存 \n");
                }else {
                    [subscriber sendError:_localizeRrror(error)];
                }
            } else {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )|| (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                }
                
                [subscriber sendError:_localizeRrror(error)];
            }
            
            
        }];
        return nil;
    }];
    
    return signal;
}




- (RACSignal *)POSTs_2_0:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass cacheKey:(id )cacheKey useCache:(BOOL)useCache
{
    
    
    if (useCache) {
        if (cacheKey) {
            cacheKey = [URLString stringByAppendingFormat:@"-%@",cacheKey];
        } else {
            cacheKey = URLString;
        }
    }
    
   
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSLog(@"\n>>%@\n %@\n",URLString,[responseObject descriptionWithLocale:@"cn"]);
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                __autoreleasing NSError *error;
                
                NSDictionary *conentObject = responseObject[kResult];
                
                id resultObject = conentObject[kContent];
                
                if (aClass) {
                    if ([resultObject isKindOfClass:[NSDictionary class]]) {
                        resultObject = [MTLJSONAdapter modelOfClass:aClass fromJSONDictionary:resultObject error:&error];
                    }
                    
                    else if ([resultObject isKindOfClass:[NSArray class]]) {
                        
                        resultObject = [MTLJSONAdapter modelsOfClass:aClass fromJSONArray:resultObject error:&error];
                    }
                    
                }
                
                
                if (error) {
                    [subscriber sendError:error];
                } else {
                    if (useCache) {
                        
                       
                        
                    }
                    
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                }
                
            } else {
                
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"😢"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSHTTPURLResponse *response = (id)task.response;
            
            if (response.statusCode == 304) {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                    NSLog(@"\n>> 缓存 \n");
                } else {
                    [subscriber sendError:_localizeRrror(error)];
                }
            } else {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                }
                [subscriber sendError:_localizeRrror(error)];
            }
            
            
        }];
        
        return nil;
    }];
    
    
    return signal;
    
}

- (RACSignal *)wxOrderParamters:(NSDictionary *)parameters
{
    if (![WXApi isWXAppInstalled]) {
        return [RACSignal errorString:@"没有安装微信"];
    }
    PayReq *payReq = [[PayReq alloc]init];
    NSString *orderNo;
    @try {
        NSString *openID = parameters[@"appid"];
        NSString *partnerId = parameters[@"partnerid"];
        NSString *prePayId = parameters[@"prepayid"];
        NSString *nonceStr = parameters[@"noncestr"];
        NSString *timeStamp = parameters[@"timestamp"];
        orderNo = parameters[@"orderNo"];
        
        NSString *package = parameters[@"package"];
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: openID        forKey:@"appid"];
        [signParams setObject: nonceStr    forKey:@"noncestr"];
        [signParams setObject: package      forKey:@"package"];
        [signParams setObject: partnerId        forKey:@"partnerid"];
        [signParams setObject: timeStamp   forKey:@"timestamp"];
        [signParams setObject: prePayId     forKey:@"prepayid"];
        //生成签名
        NSString *sign  = [NSString yc_md5Sign:signParams];
        
        payReq.openID = openID;
        payReq.partnerId = partnerId;
        payReq.prepayId = prePayId;
        payReq.nonceStr = nonceStr;
        payReq.timeStamp = timeStamp.intValue;
        payReq.package = package;
        payReq.sign = sign;
        
    }
    @catch (NSException *exception) {
        return [RACSignal errorString:exception.reason];
    }
    @finally {
        ;
    }
    [WXApi sendReq:payReq];
    return [APP.weixinSignal mapReplace:orderNo];
}

- (RACSignal *)aliPayWithTradeNO:(NSString *)tradeNO productName:(NSString *)productName productDescription:(NSString *)productDescription amount:(NSString *)amount notifyURL:(NSString *)notifyURL
{
    
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = ALIPAY_PARTNER;
    NSString *seller = partner;
    NSString *privateKey = ALIPAY_PRIVATE;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        [APP.alipaySignal sendError:error(@"出错")];
        
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    @try {
        order.partner = partner;
        order.seller = seller;
        order.tradeNO = tradeNO; //订单ID（由商家自行制定）
        order.productName = productName;
        order.productDescription = productDescription; //商品描述
        order.amount = amount; //商品价格
        order.notifyURL =  notifyURL; //回调URL
    }
    @catch (NSException *exception) {
        [APP.alipaySignal sendError:error(exception.reason)];
        
    }
    @finally {
        ;
    }
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"youchi";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    
    if (signedString != nil) {
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"[AlipaySDK defaultService] payOrder reslut = %@",resultDic);
            NSString *memo = resultDic[@"memo"];
            int resultStatus = [resultDic[@"resultStatus"] intValue];
            
            
            
            if (resultStatus == 9000) {
                [APP.alipaySignal sendNext:nil];
                [APP.alipaySignal sendCompleted];
            } else {
                [APP.alipaySignal sendError:[NSError errorWithDomain:error_domain_aliplay code:0 userInfo:@{NSLocalizedDescriptionKey:memo?:@"未知错误"}]];
            }
            
        }];
        
    } else {
        [APP.alipaySignal sendError:error(@"签名字符串出错")];
    }
    return APP.alipaySignal;
    
}

- (RACSignal *)wxOrderWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId noncestr:(NSString *)noncestr timeStamp:(NSString *)timeStamp orderNo:(NSString *)orderNo package:(NSString *)package sign:(NSString *)sign
{
    if (![WXApi isWXAppInstalled]) {
        return [RACSignal errorString:@"没有安装微信"];
    }
    PayReq *payReq = [[PayReq alloc]init];
    @try {
        
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: appId       forKey:@"appid"];
        [signParams setObject: noncestr    forKey:@"noncestr"];
        [signParams setObject: package      forKey:@"package"];
        [signParams setObject: partnerId        forKey:@"partnerid"];
        [signParams setObject: timeStamp   forKey:@"timestamp"];
        [signParams setObject: prepayId     forKey:@"prepayid"];
        //生成签名
        NSString *sign_  = [NSString yc_md5Sign:signParams];
        
        payReq.openID = appId;
        payReq.partnerId = partnerId;
        payReq.prepayId = prepayId;
        payReq.nonceStr = noncestr;
        payReq.timeStamp = timeStamp.intValue;
        payReq.package = package;
        payReq.sign = sign_;
        
    }
    @catch (NSException *exception) {
        return [RACSignal errorString:exception.reason];
    }
    @finally {
        ;
    }
    [WXApi sendReq:payReq];
    return APP.weixinSignal;
}


- (RACSignal *)POSTs_2_0:(NSString *)URLString parameters:(id)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo cacheKey:(id)cacheKey useCache:(BOOL)useCache
{
    if (useCache) {
        if (cacheKey) {
            cacheKey = [URLString stringByAppendingFormat:@"-%@",cacheKey];
        } else {
            cacheKey = URLString;
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    int pageNo = pageInfo.pageNo;
    
    if (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId) {
        
        pageNo = 1;
        param[kPageNo] = @(pageNo);
        param[kPageSize] = @(pageInfo.pageSize);
    }
    
    else if (pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId) {
        pageNo++;
        param[kFirstId] = pageInfo.loadmoreId;
        param[kPageNo] = @(pageNo);
        param[kPageSize] = @(pageInfo.pageSize);
        
    }
    
    else {
        param[@"pageNo"] = @(pageNo);
        param[@"pageSize"] = @(pageInfo.pageSize);
    }
    
    cacheKey = [NSString stringWithFormat:@"%@-%d-%d",cacheKey?:@"",pageNo,pageInfo.pageSize];
    
    
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self POST:URLString parameters:param success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject);
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                __autoreleasing NSError *error;
                NSDictionary *conentObject = responseObject[kResult];
                
                id resultObject = conentObject[kContent];
                
                BOOL isNull = [resultObject isKindOfClass:[NSNull class]];
                
                NSDictionary *pageInfoDict = nil;
                if (pageInfo && !isNull && (pageInfoDict = conentObject[@"pageInfo"])) {
                    [pageInfo setValuesForKeysWithDictionary:pageInfoDict];
                }
                
                id arr = nil;
                if (parseKey && !isNull) {
                    arr = resultObject[parseKey];
                } else {
                    arr = resultObject;
                }
                
                if (aClass && [arr isKindOfClass:[NSArray class]]) {
                    resultObject = [MTLJSONAdapter modelsOfClass:aClass fromJSONArray:arr error:&error];
                } else if (aClass && [arr isKindOfClass:[NSDictionary class]]){
                    resultObject = [MTLJSONAdapter modelOfClass:aClass fromJSONDictionary:arr error:&error];
                } else {
                    resultObject = arr;
                }
                
                if (error) {
                    [subscriber sendError:error];
                } else {
                    
                    
                    if (useCache) {
                        
                    }
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )||(pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                }
                
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"未知错误"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSHTTPURLResponse *response = (id)task.response;
            //NSLog(@"\n>>%@\n",response);
            
            if (response.statusCode == 304) {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )|| (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                    NSLog(@"\n>> 缓存 \n");
                }else {
                    [subscriber sendError:_localizeRrror(error)];
                }
            } else {
                if (useCache && [self.ldb objectExistsForKey:cacheKey]) {
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )|| (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    MTLModel *resultObject = [self.ldb objectForKey:cacheKey];
                    [subscriber sendNext:resultObject];
                }
                
                [subscriber sendError:_localizeRrror(error)];
            }
            
            
        }];
        return nil;
    }];
    
    return signal;
    
}

#pragma mark -
- (RACSignal *)POST_shop:(NSString *)URLString parameters:(NSDictionary *)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    int pageNo = pageInfo.pageNo;
    if (pageInfo) {
        
        
        if (pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId) {
            
            pageNo = 1;
            param[kPageNo] = @(pageNo);
            param[kPageSize] = @(pageInfo.pageSize);
        }
        
        else if (pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId) {
            pageNo++;
            param[kFirstId] = pageInfo.loadmoreId;
            param[kPageNo] = @(pageNo);
            param[kPageSize] = @(pageInfo.pageSize);
            
        }
        
        else {
            param[kPageNo] = @(pageNo);
            param[kPageSize] = @(pageInfo.pageSize);
        }
        
    }
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *task = [self POST:URLString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (task.state != NSURLSessionTaskStateCompleted) {
                [subscriber sendCompleted];
                return ;
            }
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject);
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                __autoreleasing NSError *error;
                NSDictionary *conentObject = responseObject[kResult];
                
                id resultObject = conentObject[kContent];
                
                BOOL isNull = [resultObject isKindOfClass:[NSNull class]];
                
                NSDictionary *pageInfoDict = nil;
                if (pageInfo && !isNull && (pageInfoDict = conentObject[@"pageInfo"])) {
                    @try {
                        [pageInfo setValuesForKeysWithDictionary:pageInfoDict];
                    }
                    @catch (NSException *exception) {
                        ;
                    }
                    @finally {
                        ;
                    }
                }
                
                id arr = nil;
                if (parseKey && !isNull) {
                    arr = [resultObject valueForKey:parseKey];
                } else {
                    arr = resultObject;
                }
                
                if (aClass && [arr isKindOfClass:[NSArray class]]) {
                    resultObject = [NSArray modelArrayWithClass:aClass json:arr];
                } else if (aClass && [arr isKindOfClass:[NSDictionary class]]){
                    resultObject = [aClass modelWithDictionary:arr];
                } else {
                    resultObject = arr;
                }
                
                if (error) {
                    [subscriber sendError:error];
                } else {
                    
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )||(pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                }
                
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"未知错误"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:_localizeRrror(error)];
            
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    //    http://192.168.31.195:8080/shop/groupBuy/getOneGroupBuyProductDetails.json?productId=10
    return signal;
    
}

- (RACSignal *)POST_shop_array:(NSString *)URLString parameters:(NSDictionary *)parameters parseClass:(Class)aClass pageInfo:(YCPageInfo *)pageInfo
{
    return [self POST_shop_array:URLString parameters:parameters parseClass:aClass parseKey:kContent pageInfo:pageInfo];
}

- (RACSignal *)POST_shop_array:(NSString *)URLString parameters:(NSDictionary *)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey pageInfo:(YCPageInfo *)pageInfo
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    int pageNo = pageInfo.pageNo;
    if (pageInfo) {
        
        
        if (pageInfo.status == YCLoadingStatusRefresh) {
            
            pageNo = 1;
            param[kPageNo] = @(pageNo);
            param[kPageSize] = @(pageInfo.pageSize);
        }
        
        else if (pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId) {
            pageNo++;
            param[kFirstId] = pageInfo.loadmoreId;
            param[kPageNo] = @(pageNo);
            param[kPageSize] = @(pageInfo.pageSize);
        }
        
        else {
            param[kPageNo] = @(pageNo);
            param[kPageSize] = @(pageInfo.pageSize);
        }
        
    }
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *task = [self POST:URLString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (task.state != NSURLSessionTaskStateCompleted) {
                [subscriber sendCompleted];
                return ;
            }
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject);
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                __autoreleasing NSError *error;
                id resultObject = responseObject[kResult];
                
                BOOL isNull = [resultObject isKindOfClass:[NSNull class]];
                
                if (pageInfo) {
                    NSDictionary *pageInfoDict = resultObject[kPageInfo];
                    if (pageInfo && !isNull && ![pageInfoDict isKindOfClass:[NSNull class]]) {
                        @try {
                            [pageInfo setValuesForKeysWithDictionary:pageInfoDict];
                        }
                        @catch (NSException *exception) {
                            ;
                        }
                        @finally {
                            
                        }
                    }
                }
                
                if (parseKey) {
                    resultObject = [resultObject valueForKeyPath:parseKey];
                }
                
                if (aClass && [resultObject isKindOfClass:[NSArray class]]) {
                    resultObject = [NSArray modelArrayWithClass:aClass json:resultObject];
                    NSArray *arrs = resultObject;
                    if (pageInfo.firstPage && arrs.count == 0) {
                        pageInfo.lastPage = 1;
                    }
                }
                
                if (error) {
                    [subscriber sendError:error];
                } else {
                    
                    if ((pageInfo.status == YCLoadingStatusLoadMore && pageInfo.loadmoreId )||(pageInfo.status == YCLoadingStatusRefresh && pageInfo.refreshId)){
                        pageInfo.pageNo = pageNo;
                    }
                    
                    [subscriber sendNext:resultObject];
                    [subscriber sendCompleted];
                }
                
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"未知错误"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:_localizeRrror(error)];
            
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    
    return signal;
    
}

- (RACSignal *)POST_shop_object:(NSString *)URLString parameters:(NSDictionary *)parameters parseClass:(Class)aClass parseKey:(NSString *)parseKey
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *task = [self POST:URLString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (task.state != NSURLSessionTaskStateCompleted) {
                [subscriber sendCompleted];
                return ;
            }
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject);
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                id resultObject = responseObject[kResult];
                if (parseKey) {
                    resultObject = [resultObject valueForKeyPath:parseKey];
                }
                if (aClass && [resultObject isKindOfClass:[NSDictionary class]]) {
                    resultObject = [aClass modelWithDictionary:resultObject];
                } else if (aClass && [resultObject isKindOfClass:[NSDictionary class]]) {
                    resultObject = [NSArray modelArrayWithClass:aClass json:resultObject];
                }
                
                [subscriber sendNext:resultObject];
                [subscriber sendCompleted];
                
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"未知错误"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:_localizeRrror(error)];
            
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    
    return signal;
    
}

- (RACSignal *)POST_original:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *task = [super POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (task.state != NSURLSessionTaskStateCompleted) {
                [subscriber sendCompleted];
                return ;
            }
            NSLog(@"\n>>%@\n %@\n",URLString,responseObject);
            
            NSInteger codeValue = [responseObject[kCode] integerValue];
            if (codeValue == 200) {
                id resultObject = responseObject[kResult];
                [subscriber sendNext:resultObject];
                [subscriber sendCompleted];
                
                
            } else {
                [subscriber sendError:[NSError errorWithDomain:kApiVersion code:codeValue userInfo:@{NSLocalizedDescriptionKey:responseObject[kMsg]?:@"未知错误"}]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:_localizeRrror(error)];
            
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    
    return signal;
    
}

@end




