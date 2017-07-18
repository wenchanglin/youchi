//
//  YCEditPhotoVC.h
//  YouChi
//
//  Created by sam on 15/9/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewController.h"
#import "YCViewModel+Logic.h"

#if TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
#import <PhotoEditFramework/PhotoEditFramework.h>

@interface YCEditPhotoVC : UIViewController <pg_edit_sdk_controller_delegate>
#else
@interface YCEditPhotoVC : UIViewController
#endif
@property (nonatomic,strong) YCNextBlock nextBlock;
@property (nonatomic,strong) UIImage *originImage;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImageModel:(YCImageModel *)imageModel;
@end
