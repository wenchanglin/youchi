//
//  YCVideoMoreLikeVM.h
//  YouChi
//
//  Created by 朱国林 on 15/9/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"

@interface YCMoreLikeVM : YCPageViewModel

@property(nonatomic,assign)BOOL isVideo;
@property(nonatomic,assign)int totalNum;
@property(nonatomic,assign)YCMoreLikeType type;
- (instancetype)initWithId:(id)aId withMoreTepy:(YCMoreLikeType)type;
@end


