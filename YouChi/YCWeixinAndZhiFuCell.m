//
//  YCWeixinAndZhiFuCell.m
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCWeixinAndZhiFuCell.h"

@implementation YCWeixinAndZhiFuCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)onTick:(BOOL)b
{
    self.selsctImage.hidden = !b;
}
@end



