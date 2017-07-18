//
//  NSMutableAttributedString+Edit.h
//  YouChi
//
//  Created by 李李善 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSMutableAttributedString (Edit)
/**
 *  编辑指定文本内容求出NSRange
 *
 *  @param tetx  文本内容
 *
 *  @return NSRange
 */
-(NSRange)onEditText:(NSString *)text;


@end
