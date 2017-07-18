//
//  YCYCCreateGroupPurchaseM.h
//  YouChi
//
//  Created by 李李善 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCItemDetailM.h"

@interface YCCreateGroupPurchaseM : YCItemDetailM
/*-------------------------这里是解析区----------------------------*/
/**
 *  参加开团人数
 */
@property(nonatomic,assign) NSNumber *joinCount,*noPayCount;
/**
 *  开团数
 */
@property(nonatomic,assign) NSNumber *sponsorCount;




/*--------------------------这里是代码处理区----------------------*/
/**
 * 开团人
 */
@property(nonatomic,strong) NSMutableAttributedString *openGroupMan;
/**
 *  参团人
 */
@property(nonatomic,strong) NSMutableAttributedString *joinInGroupMan;

@end
