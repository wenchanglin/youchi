//
//  YCGroupVC.h
//  YouChi
//
//  Created by 李李善 on 16/5/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCImagePlayerView.h"
#import "YCGroupPurchaseVM.h"



//    自动播放/详细描述VC
@interface YCBaseGroupPurchaseVC : YCBTableViewController
#pragma mark - 自动播放 ---cell0)
#pragma mark - 详细描述 ---cell3)
@end




//   认证/发货信息/商品评价，配送地址/往上拉动/图文详情/图片/保障
@interface  YCGroupPurchaseVC: YCBaseGroupPurchaseVC
#pragma mark - 认证   ---cell8)
#pragma mark - 发货信息---cell12)
#pragma mark - 商品评价，配送地址 ---cell13)

#pragma mark - 往上拉动---cell14)
#pragma mark - 图文详情---cell15)
#pragma mark - 图片   ---cell16)
#pragma mark - 保障   ---cell17)
@end

//攻略/团拼玩法
@interface  YCStrategyGroupPurchaseVC: YCGroupPurchaseVC
#pragma mark-------攻略cell7 cell9
#pragma mark-------团拼玩法 cell10 cell11
@end

