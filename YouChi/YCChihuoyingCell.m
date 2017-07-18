//
//  YCChihuoyingCell.m
//  YouChi
//
//  Created by sam on 15/6/1.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCApis.h"
#import "YCChihuoyingCell.h"
#import "YCChihuoyingM.h"

#import <Masonry/Masonry.h>
#import <UIView+WZLBadge.h>
@implementation YCChihuoyingCell
- (void)dealloc{
    //ok
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _actions.like.userInteractionEnabled = YES;
    _actions.favorite.userInteractionEnabled = YES;
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];

    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor clearColor];
}


- (void)update:(YCChihuoyingM_1_2 *)model atIndexPath:(NSIndexPath *)indexPath
{
    _model = model;
    [_actions updateWithIsLike:model.isLike.boolValue isFavorite:model.isFavorite.boolValue likeCount:model.likeCount.intValue commentCount:model.commentCount.intValue];
    

}


@end
