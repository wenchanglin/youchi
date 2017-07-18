//
//  YCAdCell.m
//  YouChi
//
//  Created by sam on 15/8/13.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCAdCell.h"
#import "YCView.h"
#import "YCChihuoyingM.h"
@implementation YCAdCell
-(void)dealloc{
    //    ok
    
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    _ad = [self viewByTag:1];
    _lTitle = [self viewByTag:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)update:(YCChihuoyingM_1_2 *)model atIndexPath:(NSIndexPath *)indexPath
{
    [_ad ycNotShop_setImageWithURL:IMAGE_MEDIUM(model.imagePath) placeholder:PLACE_HOLDER];
    
    _lTitle.text = model.title;
}
@end
