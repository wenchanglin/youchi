//
//  YCTableView.h
//  YouChi
//
//  Created by sam on 15/6/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCViewModel.h"
@interface YCTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,copy) NSArray *photos;
@property (nonatomic,strong) YCPhotoUpdateBlock updateBlock;
@property (nonatomic,strong) YCPhotoPageBlock pageBlock;
@property (nonatomic,strong) YCPhotoHeightBlock heightBlock;
@property (nonatomic,strong) YCPhotoSelectBlock selectBlock;
@end
