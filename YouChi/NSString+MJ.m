//
//  NSString+MJ.m
//  自定义button
//
//  Created by AiQing on 15-5-26.
//  Copyright (c) 2015年 quicklyant. All rights reserved.
//

#import "NSString+MJ.h"
#import "YCPassValueHelper.h"
#define KSize [[UIScreen mainScreen]bounds].size
@implementation NSString (MJ)

#pragma mark-------字符串转成date1.0
+(NSDate*)onChangeTimer:(NSString *)Timer{
    
    if (Timer==nil)
    {
        return nil;
    }
    else
    {   YCDateFormatter * dateFormat = [YCDateFormatter shareDateFormatter];
        return [dateFormat.formatter dateFromString:Timer];
    }
    
}


#pragma mark-------字符串转成date1.1
+(NSDate*)onChangeTimer:(NSString *)Timer dateStyle:(NSString *)Style
{
    if (Style==nil)
    {
        Style=@"YYYY-MM-dd HH:mm:ss";
    }
    if (Timer==nil)
    {
        return nil;
    }
    else
    {
        return [self onChangeTimer:Timer];
    }
    
}


#pragma mark-------将时间戳转化成date
+(NSString*)onChangeNewTiemr:(NSNumber *)NewTiemr{
    
    if (NewTiemr==nil) {
        return nil;
    }
     YCDateFormatter * dateFormat = [YCDateFormatter shareDateFormatter];
    return [dateFormat stringFromNumber:NewTiemr];
}



#pragma mark-------字符串转成字符串
+(NSString*)onChangeAndTimer:(NSString *)Timer dateStyle:(NSString *)Style{
 
    if (Timer==nil&&Style==nil) {
        
        return nil;
    }
    NSDate *date = [self onChangeTimer:Timer];
    if (date==nil) {
        return nil;
    }
    return [self onChangeDate:date dateStyle:Style];
}




#pragma mark-------将date转化成字符串
+(NSString*)onChangeDate:(NSDate *)date dateStyle:(NSString *)Style
{
    
    if (date==nil)
    {
        return nil;
        
    }
        YCDateFormatter * dateFormat = [YCDateFormatter shareDateFormatter];
        dateFormat.formatter.dateFormat = Style;
        return [dateFormat.formatter stringFromDate:date];
}



#pragma mark-------字符串转成data
+(NSData*)onChangeInfo:(NSString *)Info
{
    
    if (Info==nil)
    {
        return nil;
    }
        //字符串转data
        return [Info dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark-------将data转化成字符串
+(NSString*)onChangeData:(NSData *)data
{
    
    if (data==nil)
    {
        return nil;
        
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

#pragma mark-------计算字符串的长度
+(CGFloat)onJiSuan:(NSString *)Info Font:(CGFloat)Font Bianfont:(CGFloat)Bianfont
{
    if (Info==nil)
    {
        return 0;
    }
   return [Info sizeWithFont:[UIFont systemFontOfSize:Font] constrainedToSize:CGSizeMake(KSize.width-Bianfont, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height +2;    
}

#pragma mark-------将字符串转化成UIColor
+(UIColor*)onChangeColor:(NSArray *)Colors
{
    if (Colors==nil)
    {
        return nil;
    }
        for (NSString *colorSTR in Colors) {
            SEL blackSel = NSSelectorFromString(colorSTR);
            if ([UIColor respondsToSelector: blackSel])
                return [UIColor performSelector:blackSel];
        }
    return nil;
}


#pragma mark-------2015/09/22 20:09:56 ---> 09-22 20:09:56 (待优化)
+(NSString *)onChangeString:(NSString *)str{
    if (str==nil) {
        return nil;
    }
    str = [str substringFromIndex:5];
    str = [str substringToIndex:11];
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    return str;
}

#pragma mark 字符串尺寸
+(CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)constrainSize string:(NSString *)str{
    NSMutableDictionary *attrs  = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize size = [str boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}

@end







