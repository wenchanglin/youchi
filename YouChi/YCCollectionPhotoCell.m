//
//  YCChihuoyingPhotoCell.m
//  YouChi
//
//  Created by sam on 15/6/1.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCView.h"
#import "YCCollectionPhotoCell.h"
#import <Masonry/Masonry.h>
#import "YCAvatarImageView.h"
@implementation YCCollectionPhotoCell

- (void)dealloc{
    //ok
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}


- (void)_init
{
    _avatar = [YCAvatar new];
    self.backgroundView = _avatar;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.isReused = YES;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
