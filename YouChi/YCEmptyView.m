//
//  YCBackImgView.m
//  YouChi
//
//  Created by ZhiMin Deng on 15/10/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCEmptyView.h"

@implementation YCEmptyView
-(void)dealloc{
    //    ok
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateConstraintsImage:(NSString *)image title:(NSString *)title{

    self.height.constant  = 184;
    self.width.constant   = 239;
    self.centerX.constant = self.centerY.constant = 0;
    
    self.emptyImage.image = [UIImage imageNamed:image];
    self.emptyLabel.text  = title;
}

@end
