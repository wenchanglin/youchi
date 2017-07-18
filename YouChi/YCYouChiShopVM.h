//
//  YCYouChiShopVM.h
//  YouChi
//
//  Created by 李李善 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCYouChiShopM.h"


typedef NS_ENUM(NSInteger,YCStyleType) {
    YCStyleTypeAd = 5,
    YCStyleTypeNav = 6,
    YCStyleTypeNews = 7,
};

typedef NS_ENUM(NSInteger,YCShopOriginalType) {
    YCShopOriginalTypeUrl = 0,
    YCShopOriginalTypeItem,
    YCShopOriginalTypeSearch,
    YCShopOriginalTypeCatolog,
};

@interface YCYouChiShopVM : YCAutoPageViewModel
PROPERTY_STRONG YYTextLayout *newsTextLayout;
PROPERTY_STRONG shopFunds *shopFunds;
- (RACSignal *)popWindowSignal;
@end
