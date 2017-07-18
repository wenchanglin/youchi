//
//  YCAvatarChooseVC.m
//  YouChi
//
//  Created by 李李善 on 15/9/1.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCAvatarChooseVC.h"

@interface YCAvatarChooseVC ()

@end

#pragma mark - 照相和相册VC
@implementation YCAvatarChooseVC

-(void)dealloc
{
    //OK
}


- (IBAction)onChooseAvatar:(UIButton *)sender {
    //responds 响应者 因为first对象会在调用myAletViewDelegate的时候把自身赋值给delegate
    //respondsToSelector 判断当前响应者有没有执行该方法
    if ([_Delegate respondsToSelector:@selector(avatarChoose:clickedButtonAtIndex:)]){
        [_Delegate avatarChoose:self clickedButtonAtIndex:sender.tag-1];
    }
    [self hideSlideMenu];
    
    
}


@end


