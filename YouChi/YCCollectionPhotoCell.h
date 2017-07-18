//
//  YCChihuoyingPhotoCell.h
//  YouChi
//
//  Created by sam on 15/6/1.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAvatar.h"
@interface YCCollectionPhotoCell : UICollectionViewCell
@property (strong,nonatomic) YCAvatar *avatar;
@property (assign,nonatomic) BOOL isReused;
@end
