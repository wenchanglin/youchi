//
//  YCPhotoPickerVC.h
//  YouChi
//
//  Created by sam on 15/10/30.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import <GKImagePicker@robseward/GKImagePicker.h>
#import <GKImagePicker@robseward/GKImageCropViewController.h>

@interface YCPhotoPickerVC : GKImagePicker
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, weak) UIView *popoverView;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
- (void)showActionSheetOnViewController:(UIViewController *)viewController onPopoverFromView:(UIView *)popoverView editImage:(UIImage *)editImage;
@end
