//
//  YCModifyPasswordVM.m
//  YouChi
//
//  Created by 李李善 on 15/10/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModifyPasswordVM.h"

@implementation YCModifyPasswordVM

- (BOOL)_equalPassword
{
    NSString *pswnew =[self.passwordNew stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *psw =[self.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL equal = [pswnew isEqualToString:psw] &&[self.passwordNew isEqualToString:self.password];
    
    return equal;
    
}


- (BOOL)_changePassword
{
    NSString *pswold =[self.passwordOld stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *psw =[self.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL change = [pswold isEqualToString:psw] &&[self.passwordOld isEqualToString:self.password];
    
    return change;
    
}


-(BOOL)_lengthPassword
{
  BOOL length =self.passwordOld.length >=6&&self.password.length >=6;
    return length;
}

-(RACSignal *)mainSignal
{
    
    
    if (![self _equalPassword]) {
        return [RACSignal errorString:@"两个新密码不一样!!"];
    }
    
    
    if (![self _lengthPassword]) {
        return [RACSignal errorString:@"请重新输入6位数的密码!!"];
    }
    
    if ([self _changePassword]) {
        return [RACSignal errorString:@"原密码和新密码一样，请重新输入!!"];
    }

    
    
    NSString *loginId = [YCUserDefault currentLoginId];
    
    NSString *tonken =[YCUserDefault currentToken];
    
    
    return [ENGINE POST_shop_object:apiModifyPassword parameters:@{kLoginId:loginId,
                                                       kToken:tonken,
                                                       kOldPassword:self.passwordOld,
                                                       kPassword:self.password,
                                                       } parseClass:[YCLoginM class] parseKey:nil];
    
    
    
}
@end
