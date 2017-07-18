//
//  YCPersonalProfileItemCell.m
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPersonalProfileItemCell.h"
#import "YCView.h"
@implementation YCPersonalProfileItemCell
- (void)dealloc{
    //ok
}
- (void)awakeFromNib {
    // Initialization code
    [_menuItem setNormalBg:nil selectedBg:@"#f5b8b6"];
    self.borderColor = [UIColor colorWithHex:0x333333];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
