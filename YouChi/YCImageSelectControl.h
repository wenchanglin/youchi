//
//  YCimageSelVC.h
//  YouChi
//
//  Created by 李李善 on 15/8/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCContainerControl.h"
#import "YCModel.h"
///略缩图选择控件
@interface YCImageSelectControl : YCContainerControl
@property(nonatomic,assign)BOOL showSelected;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)NSInteger imageCount;
@property(nonatomic,assign)IBInspectable BOOL showDefault;
- (void)reset;
- (void)updateImagesWithPageModels:(NSArray<YCBaseImageModel *> *)models;
- (void)updateShopImagesWithPageModels:(NSArray<YCBaseImageModel *> *)models;

@end
