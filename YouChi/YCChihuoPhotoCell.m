//
//  YCChihuoyingFourCell.m
//  YouChi
//
//  Created by 李李善 on 15/5/29.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCChihuoPhotoCell.h"
#import <Masonry/Masonry.h>

@implementation YCChihuoPhotoCell

- (void)dealloc{
    //ok
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _title.text = nil;
    _title.font = KFont(16);
    _title.textAlignment = NSTextAlignmentCenter;
    
    _avatar.clipsToBounds = YES;
    _avatar.userInteractionEnabled = YES;
    _avatar.exclusiveTouch = YES;
    
    _contentImage.clipsToBounds = YES;
    
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)update:(YCChihuoyingM_1_2 *)model atIndexPath:(NSIndexPath *)indexPath
{
    [super update:model atIndexPath:indexPath];

    ///内容图片
    YCChihuoyingM_1_2 *imageModel = model.youchiPhotoList.firstObject;
    YCBaseImageModel *m = imageModel?:model;
    [_contentImage ycNotShop_setImageWithURL:IMAGE_MEDIUM(m.imagePath) placeholder:PLACE_HOLDER];

    ///发的人头像
    [_avatar yc_setImageWithURL:IMAGE_HOST_NOT_SHOP(model.userImage) placeholder:AVATAR_LITTLE];
    
    
    ///描述
    _title.text = model.name;
    
}




@end
