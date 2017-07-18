//
//  YCIssueCasuaFlmVC.h
//  YouChi
//
//  Created by 李李善 on 15/5/21.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTableViewController.h"
#import "YCCollectionViewController.h"
#import <IQKeyboardManager/IQTextView.h>
#import "YCSelectCityVC.h"

#import <GKImagePicker@robseward/GKImagePicker.h>
#import "YCCollectionPhotoCell.h"
#import "YCEditPhotoVC.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

#import <UIImage-Resize/UIImage+Resize.h>
#import "YCPhotoBrowser.h"

///随手拍
@interface YCRandomPicturesVC : YCStaticViewController<UITextViewDelegate>
@end


typedef void(^YCRandomPicturesListVCBlock)(NSMutableArray<YCImageModel *> *imageModels);
///随手拍列表
@interface YCRandomPicturesListVC : UICollectionViewController <GKImagePickerDelegate,CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic,strong,readonly) GKImagePicker *picker;
@property (nonatomic,strong,readonly) NSMutableArray<YCImageModel *> *imageModels;
@property (nonatomic,strong) YCRandomPicturesListVCBlock imageModelUpdateBlock;
- (void)setImageModelUpdateBlock:(YCRandomPicturesListVCBlock)imageModelUpdateBlock;
@end



