//
//  YCShopSearchCell.h
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YCShopSearchCell : UITableViewCell
///图片
@property (weak, nonatomic) IBOutlet UIImageView *imgInfo;
///名字
@property (weak, nonatomic) IBOutlet UILabel *lName;
///份量－200g/份
@property (weak, nonatomic) IBOutlet UILabel *lMuch;
///最优惠价格
@property (weak, nonatomic) IBOutlet UILabel *lPrice;
///老价格
@property (weak, nonatomic) IBOutlet UILabel *lLodPrice;
///标题
@property (weak, nonatomic) IBOutlet UILabel *lTitle;
///标题背景
@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;
///购物车
@property (weak, nonatomic) IBOutlet UIButton *btnShop;

@property (weak, nonatomic) IBOutlet UILabel *lKeyWord;
///是否是搜索品类
@property(nonatomic,assign) BOOL isShopSearch;

@end
