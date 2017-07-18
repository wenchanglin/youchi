//
//  YCGroupPurchaseMainVC.h
//  YouChi
//
//  Created by 李李善 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCGroupPurchaseMainVM.h"
#import "YCGroupPurchaseVC.h"


@interface YCGroupPurchaseMainVCP : YCViewController
/**
 *  邀请好友
 *
 *  @param sender 按钮
 */
-(IBAction)onInvite:(id)sender;

@end

///团拼详情界面
@interface YCGroupPurchaseMainVC : YCStrategyGroupPurchaseVC

@end
