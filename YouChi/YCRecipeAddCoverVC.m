//
//  YCRecipeAddCoverVC.m
//  YouChi
//
//  Created by sam on 15/10/28.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRecipeAddCoverVC.h"
#import "YCRecipeStepListVM.h"
#import "YCEditPhotoVC.h"

#import <GKImagePicker@robseward/GKImagePicker.h>
#import <UIImage-Resize/UIImage+Resize.h>
#import "YCPhotoPickerVC.h"
#import "YCEditPhotoVC.h"

@interface YCRecipeAddCoverVC ()<GKImagePickerDelegate>
@property(nonatomic,strong)YCRecipeStepListVM *viewModel;
@property (nonatomic,strong) YCPhotoPickerVC *picker;
@property (weak, nonatomic) IBOutlet UIImageView *ivCover;
@property (strong, nonatomic) UIImage *cover;
@end

@implementation YCRecipeAddCoverVC
@synthesize viewModel;

- (void)dealloc{
    //ok
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.viewModel.coverImage) {
        self.cover = self.ivCover.image = self.viewModel.coverImage;
    }
    self.title = @"添加封面";
    self.ivCover.contentMode = UIViewContentModeScaleAspectFill;
    if (self.viewModel.materialVM.isEditMode) {
        WSELF;

        [self.ivCover setImageWithURL:IMAGE_HOST_NOT_SHOP_(IMAGE_LARGE(self.viewModel.materialVM.editRecipeDetailVM.model.imagePath)) placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            SSELF;
            self.cover = image;
        }];
    }
}



// 发布
- (IBAction)onPublush:(id)sender {
    
    [self.view endEditing:YES];
    
    CHECK(self.cover == nil, @"请添加封面");
    self.viewModel.coverImage = self.ivCover.image;
    
    [SVProgressHUD showWithStatus:@"正在上传"];
    if (self.viewModel.materialVM.isEditMode) {
        [sender executeActivitySignal:[self.viewModel editSignal] next:^(id next) {
            [self showMessage:@"编辑秘籍成功"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:YCPhotoNotification object:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } error:self.errorBlock completed:^{
            [SVProgressHUD dismiss];
        } executing:nil];
    } else {
        
        
        [sender executeActivitySignal:[self.viewModel uploadSignal] next:^(id next) {
            [self showMessage:@"发秘籍成功"];
            
            for (YCDetailControlVCP *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[YCDetailControlVCP class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return ;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } error:self.errorBlock completed:^{
            [SVProgressHUD dismiss];
        } executing:nil];
        
    }
}



- (IBAction)onTakePhoto:(id)sender {
    [self.picker showActionSheetOnViewController:self onPopoverFromView:self.view editImage:self.cover];
}



- (YCPhotoPickerVC *)picker
{
    if (!_picker) {
        _picker = [[YCPhotoPickerVC alloc]init];
        _picker.delegate = self;
        _picker.enforceRatioLimits = YES;
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGSize rect = CGSizeMake( width, width*kRatioImage);
        _picker.cropSize = rect;
    }
    return  _picker;
}

/**
 * @method imagePicker:pickedImage: gets called when a user has chosen an image
 * @param imagePicker, the image picker instance
 * @param image, the picked and cropped image
 */
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    WSELF;
    [[RACScheduler immediateScheduler]schedule:^{
        SSELF;
        UIImage *img = [image resizedImageToFitInSize:image.size scaleIfSmaller:YES];
        self.viewModel.coverImage = self.ivCover.image = self.cover = img;
        self.viewModel.isCoverImageChanged = YES;
        [self.viewModel saveCacheViewModel];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.picker = nil;
}
@end
