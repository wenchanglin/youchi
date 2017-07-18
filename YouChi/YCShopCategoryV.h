//
//  YCShopCategoryV.h
//  YouChi
//
//  Created by 李李善 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^onClickButton)(UIButton *button ,NSInteger i);

@interface YCShopCategoryV : UIScrollView



@property(nonatomic,strong) NSMutableArray  *imgs;
///标题数组
@property(nonatomic,strong) NSMutableArray  *titles ,*btns;

///默认第几个选择 1 2 3 4 5
@property(nonatomic,assign) int  selsectBtnInteger;

-(void)onClickButton:(onClickButton)click;

@end
