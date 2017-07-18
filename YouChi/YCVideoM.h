//
//  YCVideoM.h
//  YouChi
//
//  Created by 朱国林 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"

@interface YCVideoM : YCBaseImageModel

@property (nonatomic,strong) NSString *title,*playTime,*playPv;
@property (strong,nonatomic) NSNumber *pv,*totalFraction,*isFavorite,*isLike,*likeCount;

@property (strong,nonatomic) NSString *descText;
@property (strong,nonatomic) NSAttributedString *ui_desc;
@end
