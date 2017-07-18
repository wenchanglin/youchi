//
//  YCGuanZhuCell.m
//  YouChi
//
//  Created by 李李善 on 15/5/31.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFansCell.h"
#import "YCFollowsM.h"
#import "YCView.h"



@implementation YCFollowsAndFansCell
-(void)dealloc
{
    //OK
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btnFollow.layer.shouldRasterize = YES;
    self.btnFollow.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.icon.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end

@implementation YCFansCell
-(void)dealloc
{
    //OK  封装起来太卡了
}

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)update:(YCFansUserListM *)model atIndexPath:(NSIndexPath *)indexPath
{
//    [self.superView updateAvatarControlWith:model.fansUserImage name:model.fansUserName sign:model.fansUserSignature];
    
    [self.icon ycNotShop_setImageWithURL:model.fansUserImage placeholder:AVATAR];
    self.lName.text = model.fansUserName;
    self.lSign.text = model.fansUserSignature;
    self.btnFollow.selected = [model.isFollow intValue];
}


@end
