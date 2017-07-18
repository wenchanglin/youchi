//
//  YCSearchDetaiLlistVM.h
//  YouChi
//
//  Created by 李李善 on 15/9/11.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//




#import "YCViewModel.h"
#import "YCChihuoyingM.h"

typedef NS_ENUM(NSUInteger, YCSearchlistType) {
    YCSearchlistTypeUser =0,///用户
    YCSearchlistTypePhoto = 1,///随手拍
    YCSearchlistTypeVideo = 2,///视频
    YCSearchlistTypeRecommend = 3,///资讯
};

@interface YCSearchDetaiLlistVM : YCPageViewModel

-(instancetype)initWithCellId:(NSString *)cellId HeightRow:(CGFloat)heightRow SearchlistType:(YCSearchlistType)listType;
@property(nonatomic,assign)YCSearchlistType listType;
@property(nonatomic,strong)NSString *CellId;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,strong) YCChihuoyingM_1_2 *model;
@property(nonatomic,strong) NSString * searchText;
//- (RACSignal  *)searchText:(NSString *)Text;

@end
