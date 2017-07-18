//
//  YCGroupPurchaseVM.h
//  YouChi
//
//  Created by 李李善 on 16/5/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCItemDetailVM.h"
//自动播放   ---cell0)
#define KGroupC0 cell0
//详细描述---cell3)
#define KGroupC3 cell3

//认证   ---cell8)
#define KGroupC8 cell8
//发货信息---cell12)
#define KGroupC12 cell12
//商品评价，配送地址 ---cell12)
#define KGroupC13 cell13
//往上拉动---cell14)
#define KGroupC14 cell14
//图文详情---cell15)
#define KGroupC15 cell15
//图片   ---cell16)
#define KGroupC16 cell16
//保障   ---cell17)
#define KGroupC17 cell17


//攻略 ---cell6)cell7)
#define KGroupC6 cell6
#define KGroupC7 cell7
//团拼玩法 ---cell9)cell10)
#define KGroupC9 cell9
#define KGroupC10 cell10

///------------
/// 宏的定义
///------------
#define YCCreateGroupTop 5

#define YCCreateGroupPurchaseTop 20 //详细单元格上偏移


@interface YCGroupPurchaseVM : YCItemDetailVM
///添加地址
@property(nonatomic,strong) YCRecipientAddressM *AddressM;

///团拼ID
@property(nonatomic,strong) NSNumber *groupBuyId;
/**
 *  初始化
 *
 *  @param param 参数字典
 *
 *  @return self
 */


@end


