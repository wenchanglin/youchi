//
//  NSString+MJ.h
//  自定义button
//
//  Created by AiQing on 15-5-26.
//  Copyright (c) 2015年 quicklyant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (MJ)

/**
*  将date转化成字符串
*
*  @return NSDate
*/
+(NSDate*)onChangeTimer:(NSString *)Timer;
/**
 *  将字符串按照自定义格式转化成date
 *
 *  @return NSDate
 */
+(NSDate*)onChangeTimer:(NSString *)Timer dateStyle:(NSString *)Style;
/**
 *  将时间戳转化成字符串
 *
 *  @return NSString
 */
+(NSString*)onChangeNewTiemr:(NSNumber *)NewTiemr;
/**
 *  将字符串按照对应的格式转化成字符串
 *
 *  @return NSString
 */
+(NSString*)onChangeAndTimer:(NSString *)Timer dateStyle:(NSString *)Style;
/**
 *  将date按照自定义格式转化成字符串
 *
 *  @return NSString
 */
+(NSString*)onChangeDate:(NSDate *)date dateStyle:(NSString *)Style;
/**
 *  将data转化成字符串
 *
 *  @return NSString
 */
+(NSString*)onChangeData:(NSData *)data;
/**
 *  将字符串转化成Data
 *
 *  @return NSData
 */
+(NSData*)onChangeInfo:(NSString *)Info;
/**
 *  将字符串转化成高度
 *
 *  @return CGFloat
 */
+(CGFloat)onJiSuan:(NSString *)Info Font:(CGFloat)Font Bianfont:(CGFloat)Bianfont;
/**
 *  将字符串转化成UIColor
 *
 *  @return UIColor
 */
+(UIColor*)onChangeColor:(NSArray *)Colors;
/// 2015/09/22 20:09:56 ---> 09-22 20:09:56 (待优化)
+(NSString *)onChangeString:(NSString *)str;

@end


