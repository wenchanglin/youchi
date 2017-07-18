//
//  YCNewsCell.h
//  YouChi
//
//  Created by 朱国林 on 15/8/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCNewsCell : UITableViewCell
/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/// 标题
@property (weak, nonatomic) IBOutlet UILabel *lTitle;
/// 作者名字
@property (weak, nonatomic) IBOutlet UILabel *lAuthor;

@property (weak, nonatomic) IBOutlet UIButton *bFavorite;

@end
