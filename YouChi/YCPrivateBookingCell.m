//
//  YCPrivateCell.m
//  YouChi
//
//  Created by 李李善 on 15/5/13.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCChihuoyingM.h"
#import "YCPrivateBookingCell.h"

@implementation YCPrivateBookingCell
- (void)dealloc{
    //ok
}

- (void)awakeFromNib {
    // Initialization code
    _avatarControl.isClipAvatar = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)update:(YCChihuoyingM_1_2 *)model atIndexPath:(NSIndexPath *)indexPath
{
//    [_avatarControl updateAvatarControlWith:model.userImage name:model.userName sign:model.createdDate];
//
//    [_tupian yc_setImageWithURL:model.imagePathMid placeholder:PLACE_HOLDER];
    _miaoshu.text = [[NSString alloc]initWithFormat:@"   %@",model.name];

    [_pinglun updateWithIsLike:model.isLike.boolValue isFavorite:model.isFavorite.boolValue];
    
}


@end
