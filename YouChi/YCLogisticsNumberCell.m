//
//  YCLogisticsNumberCell.m
//  YouChi
//
//  Created by 李李善 on 16/1/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLogisticsNumberCell.h"
#import "YCMyOrderM.h"
@implementation YCLogisticsSuperNumberCell

-(void)update:(YCKuaidi *)model atIndexPath:(NSIndexPath *)indexPath{
    self.lLogisticsLocation.text =model.context;
    self.lTimer.text = model.time;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



#pragma mark-------第一个
@implementation YCLogisticsFirstNumberCell
-(void)update:(YCKuaidi *)model atIndexPath:(NSIndexPath *)indexPath{
    [super update:model atIndexPath:indexPath];
}

@end
#pragma mark-------中间
@implementation YCLogisticsOtherNumberCell
-(void)update:(YCKuaidi *)model atIndexPath:(NSIndexPath *)indexPath{
    [super update:model atIndexPath:indexPath];
}

@end
#pragma mark-------最后一个
@implementation YCLogisticsLastNumberCell

-(void)update:(YCKuaidi *)model atIndexPath:(NSIndexPath *)indexPath{
    [super update:model atIndexPath:indexPath];
}

@end