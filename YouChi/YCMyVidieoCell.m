//
//  YCMyVidieoCell.m
//  YouChi
//
//  Created by 朱国林 on 15/8/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyVidieoCell.h"
#import "YCView.h"
#import "YCCatolog.h"
#import "YCVideoM.h"
#import "AppDelegate.h"
@implementation YCMyVidieoCell
-(void)dealloc{
    //    ok
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgvAvatar.clipsToBounds = YES;
    self.imgvAvatar.contentMode = UIViewContentModeScaleAspectFill;
    [_btnAttention setNormalBgColor:KBGCColor(@"dab96a") selectedBgColor:KBGCColor(@"#535353")];
    self.backgroundColor = [UIColor clearColor];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)update:(YCVideoM *)m atIndexPath:(NSIndexPath *)indexPath
{
    [_imgvAvatar yc_setImageWithURL:IMAGE_HOST_NOT_SHOP_(m.imagePath) placeholder:PLACE_HOLDER];
    _btnAttention.selected = m.isFavorite.boolValue;
    _lTitle.text = m.title;
    _lDesc.text = m.descText;
    _lTime.text =m.playTime;
}
@end
