//
//  NSMutableAttributedString+Edit.m
//  YouChi
//
//  Created by 李李善 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "NSMutableAttributedString+Edit.h"
#import "YCMarcros.h"
@implementation NSMutableAttributedString (Edit)

-(NSRange)onEditText:(NSString *)text{

    NSMutableString *str = self.mutableString;
    if (str == nil && !str ) {
        return NSMakeRange(0, 0);
    }
  return [str rangeOfString:text];

}
@end
