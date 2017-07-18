//
//  YCBackImgView.h
//  YouChi
//
//  Created by ZhiMin Deng on 15/10/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCEmptyView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *emptyImage;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
- (void)updateConstraintsImage:(NSString *)image title:(NSString *)title;
@end
