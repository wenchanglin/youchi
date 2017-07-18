//
//  YCChihuoCommentCell.m
//  YouChi
//
//  Created by 李李善 on 15/9/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCChihuoCommentCell.h"

#import "YCView.h"
#import "NSString+MJ.h"
@implementation YCChihuoCommentCell
- (void)dealloc{
    //    OK
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar = VIEW(1);
    _name = VIEW(2);
    _comment = VIEW(3);
    _comment.font = [UIFont systemFontOfSize:kFontComment];
    _date = VIEW(4);
    self.contentView.hasBottomLine = YES;
}




- (void)updateComment:(YCCommentM *)m
{
    [_avatar ycNotShop_setImageWithURL:m.userImage placeholder:PLACE_HOLDER];
    _name.text = m.userName;
    _comment.attributedText = m.ui_comment;
    _date.text = [m.createdDate substringFromIndex:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end


@implementation YCCommentView

/*
 @property(nonatomic,strong) YCAvatar  *avatar;
 @property(nonatomic,strong) UILabel  *name;
 @property(nonatomic,strong) UILabel  *comment;
 @property(nonatomic,strong) UILabel  *date;
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        _avatar = [YCAvatar newInSuperView:self];
        _name = [YYLabel newInSuperView:self];
        _date = [YYLabel newInSuperView:self];
        _comment = [YYLabel newInSuperView:self];
    }
    return self;
}

//- (void)updateConstraints
//{
//    [super updateConstraints];
//    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//}

- (void)updateComment:(YCCommentM *)m
{
    [_avatar ycNotShop_setImageWithURL:m.userImage placeholder:PLACE_HOLDER];
    _name.text = m.userName;
    _comment.attributedText = m.ui_comment;
    _date.text = [m.createdDate substringFromIndex:5];
}


@end