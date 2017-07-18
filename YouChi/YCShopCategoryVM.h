//
//  YCShopCategoryVM.h
//  YouChi
//
//  Created by 李李善 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCYouChiShopVM.h"
#import "YCViewModel.h"

#import "YCShopCategoryM.h"
@interface YCShopCategoryVM : YCPageViewModel
///选择更新哪一个
@property(nonatomic,assign) NSInteger selsectBtn;
///按钮标题数组
@property(nonatomic,strong) NSMutableArray  *titles;
///一个标题对应--->商品数组
@property(nonatomic,strong) NSMutableArray  *shops;
@end

