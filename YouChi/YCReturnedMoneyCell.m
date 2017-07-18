//
//  YCReturnedMoneyCell.m
//  YouChi
//
//  Created by 朱国林 on 16/2/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCMyOrderM.h"
#import "YCReturnedMoneyCell.h"
#import "YCView.h"
#import "YCAboutGoodsM.h"
@implementation YCReturnedMoneyCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.specialTab insertSegmentWithTitle:@"取消原因" image:nil];
    [self.specialTab insertSegmentWithTitle:@"处理结果" image:nil];
    self.specialTab.normalColor = KBGCColor(@"#232133");
    self.specialTab.segmentFont = KFont(12);
    self.specialTab.hasBottomLine = YES;
    self.specialTab.hasTopLine = YES;
    [self.specialTab addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
}




-(void)update:(YCMyOrderM *)model atIndexPath:(NSIndexPath *)indexPath
{

    self.refundRemark = model.refundRemark.firstObject;
    self.refuseRemark = model.refuseRemark.firstObject;
    
    
    self.lReason.text = [NSString stringWithFormat:@"取消订单原因：%@",self.refundRemark.remark];  // self.refundRemark.date
    self.lTime.text = [NSString stringWithFormat:@"申请时间：%@",self.refundRemark.date];
    
    [self updateStatue:model.refundStatus.intValue];
}

- (void)onChange:(YCSwitchTabControl *)specialTab{

    [specialTab segmentLineScrollToIndex:specialTab.selectedSegmentIndex animate:YES];
    
    if (specialTab.selectedSegmentIndex == 0) {
        
        self.lReason.text = [NSString stringWithFormat:@"取消订单原因：%@",self.refundRemark.remark];
        self.lTime.text = [NSString stringWithFormat:@"申请时间：%@",self.refundRemark.date];
    }else{
    
        self.lReason.text = [NSString stringWithFormat:@"处理结果：%@",self.refuseRemark.remark];
        self.lTime.text = [NSString stringWithFormat:@"处理时间：%@",self.refundRemark.date];
    }
    
    
}
- (void)updateStatue:(int) statue {

    NSString *title;
    
    if (statue == 1 || statue == 2) {
        title = @"审核中";
    }else if (statue == 3){
    
        title = @"已退款";
    }
    
    else if (statue == 3){
        
        title = @"已拒绝";
    }
    
    self.lStatus.text = title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
