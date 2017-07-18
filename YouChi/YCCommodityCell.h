//
//  YCCommodityCell.h
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyCartCell.h"

#import "YCCategoryDelete.h"
#import "YCMuchPrice.h"
#import "YCCommodity.h"
@interface YCCommodityCell : YCMyCartCell
///商品类型删除View
@property (weak, nonatomic) IBOutlet YCCategoryDelete *caregoryDeleteV;
///数量加减View
@property (weak, nonatomic) IBOutlet YCMuchPrice *muchPriceV;


@end
