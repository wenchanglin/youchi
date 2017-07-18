//
//  YCYouMiExchangePayVM.h
//  YouChi
//
//  Created by 李李善 on 16/1/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCShopCategoryM.h"
#import "YCAboutGoodsM.h"
@interface YCYouMiExchangePayVM : YCPageViewModel
///AddressModel
@property(nonatomic,strong) YCAboutGoodsM *AddressModel;

///商品内容
@property(nonatomic,strong) YCShopSpecM *shopSpecsModel;

@end
