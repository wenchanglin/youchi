//
//  YCMessageCell.m
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommentCell.h"
#import "YCUserCommentM.h"
#import "YCCatolog.h"
#import "YCView.h"
#import "AppDelegate.h"

@implementation YCCommentCell
- (void)dealloc
{
    //   OK
}

- (void)awakeFromNib {
    // Initialization code
    _avatarControl.sign.numberOfLines = 2;
}

- (void)update:(YCUserCommentM *)model atIndexPath:(NSIndexPath *)indexPath
{
   [_avatarControl updateAvatarControlWith:model.pushUserImage name:model.pushUserName sign:model.message sex:nil];
    
    if (isOldOSS(model.targetBody.imagePath)) {
        [_imagvIcon ycNotShop_setImageWithURL:model.targetBody.imagePath placeholder:PLACE_HOLDER];
    } else {
        [_imagvIcon yc_setImageWithURL:IMAGE_HOST_1_2_get(model.targetBody.imagePath) placeholder:PLACE_HOLDER];
    }
    

    _lInfo.attributedText = model.attributedDesc;
    _lTimer.text = model.createdDate ;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


