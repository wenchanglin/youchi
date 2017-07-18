//
//  YCCommentOfVideoVM.m
//  YouChi
//
//  Created by 朱国林 on 15/11/9.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommentOfVideoVM.h"
#import "YCCommentM.h"
@implementation YCCommentOfVideoVM
-(instancetype)initWithModel:(id)model
{
    if (self == [super initWithModel:model]) {
        
        self.videoModel = (id)model;
    }
    return self;
}

@end
