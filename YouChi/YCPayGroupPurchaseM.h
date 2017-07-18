//
//  YCPayGroupPurchaseM.h
//  YouChi
//
//  Created by 李李善 on 16/5/25.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCItemDetailM.h"
#import "YCModel.h"
@interface YCPayGroupPurchaseM : YCItemDetailM

@property (strong,nonatomic) NSNumber *orderId,*noPayCount;
//@property (strong,nonatomic) NSNumber *tag;


@end

@interface YCPayGroupPriceM : YCBaseModel

@property (strong,nonatomic) NSString *object;

@end

