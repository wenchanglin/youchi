//
//  YCMyMoneyCell.h
//  YouChi
//
//  Created by 李李善 on 16/1/11.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCMyMoneyCell : UITableViewCell
///行为
@property (weak, nonatomic) IBOutlet UILabel *lAction;
///时间
@property (weak, nonatomic) IBOutlet UILabel *lTime;
///内容
@property (weak, nonatomic) IBOutlet UILabel *lInfo;
///金钱
@property (weak, nonatomic) IBOutlet UILabel *lMoney;

@end
