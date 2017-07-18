//
//  YCGoodsCommentCell2.h
//  YouChi
//
//  Created by 朱国林 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"
#import "YCGoodsCommentM.h"
#import <YYKit/YYKit.h>
#import "YCView.h"
#import "YCImageSelectControl.h"
@interface YCGoodsCommentCell2 : YCTableVIewCell
/// 头像
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lAuthor;
/// 日期
@property (weak, nonatomic) IBOutlet UILabel *lCommentDate;
/// 评论内容
@property (weak, nonatomic) IBOutlet YYLabel *lCommentDesc;
/// 支持一个
@property (weak, nonatomic) IBOutlet UIButton *bSupport;
/// 购物时间
@property (weak, nonatomic) IBOutlet UILabel *shoppingDate;
@property (weak, nonatomic) IBOutlet YCImageSelectControl *imageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


/**
 *  支持顶一个  tag  1001
 */

- (void)updateLikeButton:(BOOL)isLike;
@end
