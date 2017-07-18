//
//  YCRecipientAddressCell.h
//  YouChi
//
//  Created by 朱国林 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"
#import "YCAboutGoodsM.h"
@interface YCRecipientAddressCell : YCTableVIewCell
@property (weak, nonatomic) IBOutlet UILabel *lRecipientName;
@property (weak, nonatomic) IBOutlet UILabel *lRecipientNum;
@property (weak, nonatomic) IBOutlet UILabel *lRecipientAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgChoose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ChooseWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ChooseHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgMap;
@property (strong,nonatomic) IBOutlet UIView *nonView;

@property (nonatomic,assign) BOOL isArrow;
/// 当确认订单的地址没有时，显示添加地址
@property (nonatomic,assign) BOOL isHiddenMsg;

- (void)updateWith:(YCAboutGoodsM *)model atIndexPath:(NSIndexPath *)indexPath;

@end
