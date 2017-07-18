//
//  YCCellManagerTopView.m
//  YouChi
//
//  Created by water on 16/6/15.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCellManagerTopView.h"
#import "YCCellManagerFrame.h"
#import "YCView.h"
#import "YCChihuoyingM.h"



@interface YCCellManagerTopView ()

@property (weak,nonatomic) UIImageView *iconView;
@property (weak,nonatomic) UILabel *userNameLbl;
@property (weak,nonatomic) UILabel *signatureLbl;
@property (weak,nonatomic) UIButton *rightBtn;


@end

@implementation YCCellManagerTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *userNameLbl = [[UILabel alloc] init];
        [self addSubview:userNameLbl];
        self.userNameLbl = userNameLbl;
        
        UILabel *signatureLbl = [[UILabel alloc] init];
        [self addSubview:signatureLbl];
        self.signatureLbl = signatureLbl;
        
        UIButton *rightBtn = [[UIButton alloc] init];
        rightBtn.adjustsImageWhenHighlighted = NO;
        [rightBtn setImage:[UIImage imageNamed:@"赞_显示数量的赞"] forState:UIControlStateNormal];
        [self addSubview:rightBtn];
        self.rightBtn = rightBtn;
    }
    return self;
}

-(void)setManagerFrame:(YCCellManagerFrame *)managerFrame{
    _managerFrame = managerFrame;
    
//    [self.iconView yc_setImageWithURL:managerFrame.model.imagePath placeholder:PLACE_HOLDER];
//    self.userNameLbl.text = managerFrame.model.userName;
//    self.signatureLbl.text = managerFrame.model.signature;
//    [self.rightBtn setTitle:[NSString stringWithFormat:@"%@个人觉得很赞",managerFrame.model.likeCount] forState:UIControlStateNormal];
    
    self.iconView.frame = managerFrame.topIconF;
    self.userNameLbl.frame = managerFrame.userNameF;
    self.signatureLbl.frame = managerFrame.signatureF;
    self.rightBtn.frame = managerFrame.topRightF;
    
    self.frame = managerFrame.topF;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
