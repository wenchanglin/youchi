//
//  YCNotificationCell.m
//  YouChi
//
//  Created by 李李善 on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNotificationCell.h"
#import "YCNotificationM.h"
#import "YCView.h"
@implementation YCNotificationCell
-(void)dealloc{
    //    ok
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)update:(YCNotificationM *)model atIndexPath:(NSIndexPath *)indexPath
{
    _lName.text = @"友吃";
    _lInfo.text = model.message;
    _lTimer.text = [model.createdDate substringFromIndex:5];
    _imagvIcon.image = [UIImage imageNamed:@"appIcon"];
}
@end
