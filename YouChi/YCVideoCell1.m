//
//  YCVideoCell1.m
//  YouChi
//
//  Created by 朱国林 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCVideoCell1.h"
#import "YCMarcros.h"
#import "Masonry.h"
#import "YCVideoM.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import <NSAttributedString-DDHTML/NSAttributedString+DDHTML.h>
#import "YCView.h"
@implementation YCVideoCell1
-(void)dealloc{
    //    ok
}
- (void)awakeFromNib {

    _lTitle     = VIEW(2);
    _lTime     = VIEW(3);
    _lPlayCount= VIEW(4);
    _btnPlay= VIEW(5);
    _lDesc= VIEW(6);
    self.imgViewWidth.constant = SCREEN_WIDTH *0.50f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)update:(YCVideoM *)model atIndexPath:(NSIndexPath *)indexPath
{
    [_btnPlay setBackgroundImageWithURL:IMAGE_HOST_NOT_SHOP_(model.imagePath) forState:UIControlStateNormal options:YYWebImageOptionSetImageWithFadeAnimation];
    self.lTitle.text = model.title;
    self.lDesc.text = [model.descText stringByAppendingString:@"\n\n\n\n\n"];
    self.lTime.text = model.playTime;
    self.lPlayCount.text = model.playPv;

}



@end
