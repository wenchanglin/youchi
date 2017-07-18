//
//  OFCatolog.m
//  OrderingFood
//
//  Created by Mallgo on 15-3-20.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//

#import "YCCatolog.h"
#import "YCView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YCDefines.h"
#import <CommonCrypto/CommonCrypto.h>
const char * kPushedViewController,*kCellUpdateBlock;
@implementation YCCatolog

@end
@implementation UITableViewCell (OF)
- (UIViewController *)pushedViewController
{
    return objc_getAssociatedObject(self, kPushedViewController);
}


- (void)setPushedViewController:(UIViewController *)pushedViewController
{
    objc_setAssociatedObject(self, kPushedViewController, pushedViewController, OBJC_ASSOCIATION_ASSIGN);
}



- (void)update:(id)model atIndexPath:(NSIndexPath *)indexPath controller:(UIViewController *)vc
{
    ;
}

- (void)update:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    ;
}

@end

@implementation UICollectionViewCell (OF)

- (void)update:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    ;
}

@end


@implementation RACSignal (OF)
+ (RACSignal *)errorString:(NSString *)e
{
    return [RACSignal error:[NSError errorWithDomain:@"rac" code:0 userInfo:@{NSLocalizedDescriptionKey:e}]];
}

@end



@implementation NSObject (JSONKit)

- (NSString *)mgm_JSONString {
    // If that option is not set, the most compact possible JSON will be generated.
    // or NSJSONWritingPrettyPrinted option will generate JSON with whitespace designed to make the output more readable
    return [self mgm_JSONStringWithOptions:0 error:NULL];
}

- (NSString *)mgm_JSONStringWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error {
    NSString *JSONString = nil;
    NSData *JSONData = [self mgm_JSONDataWithOptions:opt error:error];
    if (JSONData != nil) {
        JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    }
    
    return JSONString;
}

- (NSData *)mgm_JSONData {
    return [self mgm_JSONDataWithOptions:0 error:NULL];
}

- (NSData *)mgm_JSONDataWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error {
    NSData *JSONData = nil;
    
    // If obj will not produce valid JSON, an exception is thrown.
    // This exception is thrown prior to parsing and represents a programming error, not an internal error.
    if ([NSJSONSerialization isValidJSONObject:self]) {
        JSONData = [NSJSONSerialization dataWithJSONObject:self options:opt error:error];
    
    } else {
        if (error) {
            *error = [NSError errorWithDomain:NSJSONKitErrorDomain
                                         code:-1
                                     userInfo:@{ NSLocalizedFailureReasonErrorKey:@"This is not a valid JSONObject" }];
        }
    }
    
    return JSONData;
}
@end

@implementation NSAttributedString (YC)

- (CGFloat)heightWithFixedWidth:(CGFloat)width {
    CGFloat height = 0.0;
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)self);
    
    CFIndex startIndex = 0;
    do {
        CFIndex length = CTTypesetterSuggestLineBreak(typesetter, startIndex, width);
        
        CGFloat ascent, descent, leading;
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(startIndex, length));
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CFRelease(line);
        height += ascent + descent + leading;
        
        startIndex += length;
    }
    while (startIndex < [self length]);
    
    CFRelease(typesetter);
    
    return ceil(height);
}

@end

@implementation NSString (YC)

- (CGFloat) heightForFontSize:(CGFloat)fontSize andWidth:(CGFloat)width
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:
                        NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;


    return ceilf(sizeToFit.height);
}


//md5 encode
- (NSString *) yc_md5;
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

//创建package签名
+ (NSString *)yc_md5Sign:(NSDictionary *)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", WX_API_KEY];
    //得到MD5 sign签名
    NSString *md5Sign =[contentString yc_md5];
    
    return md5Sign;
}

//获取package带参数的签名包
+ (NSString *)genPackage:(NSMutableDictionary*)packageParams
{
    NSString *sign;
    NSMutableString *reqPars=[NSMutableString string];
    //生成签名
    sign        = [NSString yc_md5Sign:packageParams];
    //生成xml的package
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>\n"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    
    return [NSString stringWithString:reqPars];
}

- (NSString *)yc_signParams:(NSDictionary *)dict
{
    NSString    *package, *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [time_stamp yc_md5];
    //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
    //package       = [NSString stringWithFormat:@"Sign=%@",package];
    package         = @"Sign=WXPay";
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: WX_APP_ID        forKey:@"appid"];
    [signParams setObject: nonce_str    forKey:@"noncestr"];
    [signParams setObject: package      forKey:@"package"];
    [signParams setObject: WX_MCH_ID        forKey:@"partnerid"];
    [signParams setObject: time_stamp   forKey:@"timestamp"];
    //[signParams set;
    return signParams.description;
}
@end

