//
//  YCPhotoPickerVC.m
//  YouChi
//
//  Created by sam on 15/10/30.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPhotoPickerVC.h"
#import "YCEditPhotoVC.h"
#import <Toast/UIView+Toast.h>

@interface YCPhotoPickerVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (nonatomic,strong) UIImage *editImage;
@end

@implementation YCPhotoPickerVC
# pragma mark -
# pragma mark Private Methods

- (void)_hideController{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)showActionSheetOnViewController:(UIViewController *)viewController onPopoverFromView:(UIView *)popoverView editImage:(UIImage *)editImage
{
    self.presentingViewController = viewController;
    self.popoverView = popoverView;
    self.editImage = editImage;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:(id)self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Image from Camera", @"Image from Camera"), NSLocalizedString(@"Image from Library", @"Image from Library"),@"滤镜", nil];
    actionSheet.delegate = self;

    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [actionSheet showFromRect:self.popoverView.frame inView:self.presentingViewController.view animated:YES];
    } else {
        if (self.presentingViewController.navigationController.toolbar) {
            [actionSheet showFromToolbar:self.presentingViewController.navigationController.toolbar];
        } else {
            [actionSheet showInView:self.presentingViewController.view];
        }
    }
}

- (void)presentImagePickerController
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
        [self.popoverController presentPopoverFromRect:self.popoverView.frame
                                                inView:self.presentingViewController.view
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
        
    } else {
        
        [self.presentingViewController presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }
}


- (void)showCameraImagePicker {
    
#if TARGET_IPHONE_SIMULATOR
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Simulator" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
#elif TARGET_OS_IPHONE
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    
    if (self.useFrontCameraAsDefault){
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    [self presentImagePickerController];
#endif
    
}

- (void)showGalleryImagePicker {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    
    [self presentImagePickerController];
}


#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self showCameraImagePicker];
            break;
        case 1:
            [self showGalleryImagePicker];
            break;
        case 2:
            if (self.editImage) {
                YCEditPhotoVC *vc =[[YCEditPhotoVC alloc]initWithImage:self.editImage];
                WSELF;
                vc.nextBlock = ^(UIImage *img) {
                    SSELF;
                    if ([self.delegate respondsToSelector:@selector(imagePicker:pickedImage:)]) {
                        [self.delegate imagePicker:self pickedImage:img];
                    }
                };
                
                [self.presentingViewController presentViewController:vc animated:YES completion:nil];
            }
            
            else {
                [self.presentingViewController showMessage:@"请先添加图片"];
            }
            break;
            
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
