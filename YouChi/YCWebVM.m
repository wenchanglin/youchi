//
//  YCWebVM.m
//  YouChi
//
//  Created by sam on 15/6/17.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCWebVM.h"

@implementation YCWebVM
- (void)dealloc{
    //ok
}
- (instancetype)initWithModel:(YCBaseImageModel *)model
{
    self = [super init];
    if (self) {
        self.shareText = model.desc;
        self.shareImageUrl = model.imagePath;

    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
      self.url  = url;
    }
    return self;
}


@end
