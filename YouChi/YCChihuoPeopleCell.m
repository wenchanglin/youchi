//
//  YCChihuoPeopleCell.m
//  YouChi
//
//  Created by 李李善 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCChihuoPeopleCell.h"
#import "YCView.h"

@implementation YCChihuoPeopleCell
- (void)dealloc{
    //    OK
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    [_photosView registerClass:[YCCollectionPhotoCell class] forCellWithReuseIdentifier:cell0];
    
    _photosView.updateBlock = ^(YCCollectionPhotoCell *cell,YCBaseUserImageModel *m) {
        
            if (m.userImage) {
                [cell.avatar yc_setImageWithURL:IMAGE_HOST_NOT_SHOP(m.userImage) placeholder:AVATAR_LITTLE];
            } else {
                [cell.avatar yc_setImageWithURL:IMAGE_HOST_NOT_SHOP(m.userImagePath) placeholder:AVATAR_LITTLE];
            }
        
    };

    CGFloat wh = CGRectGetHeight(_photosView.frame)-_leftZanView.frame.size.height;
    _photosView.sizeBlock = ^(CGSize size) {
        return CGSizeMake(wh, wh);
    };

    self.contentView.backgroundColor = [UIColor clearColor];
    _buttonLineHeight.constant = 0.5f;
    
}

- (void)updateChihuo:(YCChihuoyingM_1_2 *)m type:(YCCheatsType)type
{
    [_leftZanView updateLikeCount:m.likeCount.intValue];
    
    
    NSArray *likeList;
    if (type == YCCheatsTypeYouChi) {
        likeList = m.youchiLikeList;
    }
    else if (type == YCCheatsTypeRecipe){
        likeList = m.recipeLikeList;
    }
    else if (type == YCCheatsTypeVideo){
        likeList = m.videoLikeList;
    }
    if (likeList.count == 0) {
        _more.enabled = NO;
    }
    if (_photosView.photos.count != likeList.count) {
        _photosView.photos = likeList;

        [_photosView performBatchUpdates:^{
            NSIndexSet *idp = [NSIndexSet indexSetWithIndex:0];
            [_photosView deleteSections:idp];
            [_photosView insertSections:idp];
        } completion:^(BOOL finished) {
            // 查看更多点赞
            CGFloat contentSizeWidth = _photosView.contentSize.width;
            CGFloat width = _photosView.bounds.size.width;
            _more.enabled = (contentSizeWidth >= width);
            if (likeList.count>=10) {
                _more.enabled = YES;
            }
        }];

    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
