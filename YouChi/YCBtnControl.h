//
//  YCBtnControl.h
//  YouChi
//
//  Created by 朱国林 on 15/8/25.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

/// 按钮之间间隔一个距离

#import <UIKit/UIKit.h>

@interface YCBtnControl : UIControl
@property (nonatomic,assign)NSInteger selectedSegmentIndex;
@property (nonatomic,strong)NSMutableArray * segments;

- (void)insertBtnWithTitle:(NSString *)title;

@end
