//
//  YCSearchDetailOphoneCellTableViewCell.h
//  YouChi
//
//  Created by ZhiMin Deng on 15/10/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCModel.h"
@interface YCSearchDetailOphoneCell : UITableViewCell
@property (nonatomic,weak) UIImageView *icon;
@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UIButton *action;
@property (weak, nonatomic) IBOutlet UIButton *attention;
- (void)updateIcon:(NSString *)icon title:(NSString *)title shouldShowAction:(BOOL )shouldShowAction isSelected:(BOOL)isSelected;
- (void)updateIcon:(NSString *)icon AttributedStr:(NSAttributedString *)AttributedStr shouldShowAction:(BOOL )shouldShowAction isSelected:(BOOL)isSelected;
@end
