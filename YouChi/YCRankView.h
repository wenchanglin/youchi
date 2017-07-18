//
//  YCRankView.h
//  YouChi
//
//  Created by sam on 15/5/24.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface YCRankView : UIView
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *desc;
@end

IB_DESIGNABLE
@interface YCTimeView : YCRankView
@end
