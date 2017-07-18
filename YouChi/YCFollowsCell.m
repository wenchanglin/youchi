//
//  YCFansCell.m
//  YouChi
//
//  Created by 朱国林 on 15/8/18.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFollowsCell.h"
#import "YCFollowsM.h"
#import "YCView.h"
@implementation YCFollowsCell

-(void)dealloc
{
    //OK
}

- (void)awakeFromNib {
    
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)update:(YCFollowUserListM *)model atIndexPath:(NSIndexPath *)indexPath
{
//    [self.superView updateAvatarControlWith:model.followUserImage name:model.followUserName sign:model.followUserSignature];
    [self.icon ycNotShop_setImageWithURL:model.followUserImage placeholder:AVATAR];
    
    self.lName.text = model.followUserName;
    self.lSign.text = model.followUserSignature;
    self.btnFollow.selected = model.isFollow.boolValue;
    
}


@end
