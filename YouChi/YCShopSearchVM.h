//
//  YCShopSearchVM.h
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchDetailVM.h"
#import "YCShopCategoryM.h"
@interface YCShopSearchVM : YCPageViewModel

@property(nonatomic,strong) NSString * searchText;
- (RACSignal *)onSearchSignal:(NSInteger)orderType;
@end
