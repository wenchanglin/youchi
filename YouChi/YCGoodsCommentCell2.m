//
//  YCGoodsCommentCell2.m
//  YouChi
//
//  Created by 朱国林 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGoodsCommentCell2.h"
#import <YYKit/YYKit.h>
@implementation YCGoodsCommentCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(YCGoodsCommentM *)model atIndexPath:(NSIndexPath *)indexPath{
    [_imgIcon ycNotShop_setImageWithURL:model.user.imagePath placeholder:AVATAR_LITTLE];
    _lAuthor.text = model.user.nickName;
    _lCommentDate.text = model.createdDate;
    _lCommentDesc.textLayout = model.layout;
    _lCommentDesc.attributedText = model.layout.text;
    
    _shoppingDate.text = model.orderPayDate;
    
    self.imageHeight.constant = model.shopProductShowoffImages.count == 0 ? 0 : 70;
    [_imageControl updateShopImagesWithPageModels:model.shopProductShowoffImages];
    
    [self updateLikeButton:model.isClickLike.boolValue];
}

- (void)updateLikeButton:(BOOL)isLike
{
    //_bSupport.selected = isLike;
    UIColor *color = isLike?color_title:KBGCColor(@"#272636");
    _bSupport.borderColor = color;
    _bSupport.selected = isLike;
    [_bSupport setTitleColor:color forState:UIControlStateNormal];
}


@end
