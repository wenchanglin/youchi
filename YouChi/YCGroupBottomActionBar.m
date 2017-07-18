//
//  YCGroupActionBar.m
//  YouChi
//
//  Created by sam on 16/6/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupBottomActionBar.h"

@implementation YCGroupBottomActionBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateColors
{
    if (self.elements.count == 0) {
        [self setElementCount:2 block:^UIView *(NSInteger idx) {
            UIButton *btn = [UIButton new];
            
            return btn;
        }];
    }
    [self.elements enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = YES;
    }];
    
    _btnLeft = self.elements.firstObject;
    _btnRight = self.elements.lastObject;
    
    [_btnLeft setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d8b76a"]] forState:UIControlStateNormal];
    [_btnLeft setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_btnRight setBackgroundImage:[UIImage imageWithColor:UIColorHex(C40000)] forState:UIControlStateNormal];
    [_btnRight setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
}
@end
