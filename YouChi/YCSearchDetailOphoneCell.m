//
//  YCSearchDetailOphoneCellTableViewCell.m
//  YouChi
//
//  Created by ZhiMin Deng on 15/10/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchDetailOphoneCell.h"
#import "YCView.h"
#import "YCCatolog.h"
#import "YCMarcros.h"
@implementation YCSearchDetailOphoneCell
-(void)dealloc{
    //    ok
    
}
- (void)awakeFromNib {
    // Initialization code

    _icon = VIEW(1);
    _title = VIEW(2);
    _action = VIEW(3);
    
    [_action setNormalBg:@"#DEC079" selectedBg:@"#535353"];  //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateIcon:(NSString *)icon title:(NSString *)title shouldShowAction:(BOOL)shouldShowAction isSelected:(BOOL)isSelected
{
    [_icon ycNotShop_setImageWithURL:icon placeholder:PLACE_HOLDER];
    _title.text = title;
    _action.hidden = !shouldShowAction;
    _action.selected = isSelected;
}
- (void)updateIcon:(NSString *)icon AttributedStr:(NSAttributedString *)AttributedStr shouldShowAction:(BOOL )shouldShowAction isSelected:(BOOL)isSelected{
    [_icon ycNotShop_setImageWithURL:icon placeholder:PLACE_HOLDER];
    _title.attributedText = AttributedStr;
    _action.hidden = !shouldShowAction;
    _action.selected = isSelected;
}

@end
