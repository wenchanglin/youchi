//
//  YCCategoryDelete.h
//  YouChi
//
//  Created by 李李善 on 15/12/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//


typedef NS_ENUM(NSUInteger, YCOrderStateTypeCell) {
    YCOrderStateOrderDetailCll = 0,/// 详情cell
};

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface YCCategoryDelete : UIControl
///商品类型
@property(nonatomic,strong) UILabel *commodityName;
///删除按钮 tag==30
@property(nonatomic,strong) UIButton *btnDelete;
///选中按钮 tag==40
@property(nonatomic,strong) UIButton *btnSelect;
///是否隐藏选中按钮
@property(nonatomic,assign)IBInspectable BOOL hiddenBtnSel;
@property(nonatomic,assign) YCOrderStateTypeCell ycOrderStateTypeCell;
/**
 name    商品类型
 select  是否选中
 */
-(void)onUpdataCommodityName:(NSString *)name Selsct:(BOOL)select;
@end

