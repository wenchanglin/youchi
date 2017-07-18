//
//  YCPhotosView.h
//  YouChi
//
//  Created by sam on 15/5/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCViewModel.h"

@interface YCPhotosView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,copy) NSArray *photos;
@property (nonatomic,strong) YCPhotoCellIdBlock cellIdBlock;
@property (nonatomic,strong) YCPhotoUpdateBlock updateBlock;
@property (nonatomic,strong) YCPhotoPageBlock pageBlock;
@property (nonatomic,strong) YCPhotoSizeBlock sizeBlock;
@property (nonatomic,strong) YCPhotoSelectBlock selectBlock;
- (void)setCellIdBlock:(YCPhotoCellIdBlock)cellIdBlock;
- (void)setUpdateBlock:(YCPhotoUpdateBlock)updateBlock;
- (void)setPageBlock:(YCPhotoPageBlock)pageBlock;
- (void)setSizeBlock:(YCPhotoSizeBlock)sizeBlock;
- (void)setSelectBlock:(YCPhotoSelectBlock)selectBlock;


@end
