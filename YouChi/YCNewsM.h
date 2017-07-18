//
//  YCRecommendMsgM.h
//  YouChi
//
//  Created by 朱国林 on 15/8/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"

@interface YCNewsM : YCBaseImageModel

@property (nonatomic,strong) NSArray *newsList;


@end

@interface YCNewsList : YCBaseImageModel

@property (nonatomic,strong) NSString *title,*author,*htmlPath,*summary,*moreFavoriteCount;
@property (strong,nonatomic) NSNumber *favoriteCount,*pv,*isFavorite,*newsId;
@property (strong,nonatomic) NSAttributedString *ui_desc;
- (void)onSetupData;
@end