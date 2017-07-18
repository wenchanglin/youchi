//
//  YCRecipeAddStepVC.m
//  YouChi
//
//  Created by sam on 15/10/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRecipeAddStepVC.h"
#import <GKImagePicker@robseward/GKImagePicker.h>
#import <IQTextView.h>
#import <UIImage-Resize/UIImage+Resize.h>

#import "YCRecipeStepListVM.h"
#import "YCEditPhotoVC.h"
#import "YCPhotoPickerVC.h"

@interface YCRecipeAddStepVC ()<GKImagePickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>

@property(nonatomic,strong)YCRecipeStepListVM *viewModel;
///描述
@property (weak, nonatomic) IBOutlet IQTextView *desc;
///照片
@property (weak, nonatomic) IBOutlet UIImageView *addImage;

@property(weak,nonatomic) IBOutlet UILabel *lTitle;

@property (strong, nonatomic) UIImage *stepImage;

@property (nonatomic,strong) YCPhotoPickerVC *picker;
@end

@implementation YCRecipeAddStepVC
@synthesize viewModel;
- (void)dealloc{
    //ok
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.viewModel.title;
    self.lTitle.text = self.viewModel.materialVM.name;

    
    self.desc.textColor = [UIColor blackColor];
    self.desc.placeholder = @"请简单描述一下这个步骤";
    self.desc.layoutManager.allowsNonContiguousLayout = NO;
    self.addImage.contentMode = UIViewContentModeScaleAspectFill;
    
    if (self.viewModel.editModel) {
        if (self.viewModel.editModel.image) {
            self.addImage.image = self.stepImage = self.viewModel.editModel.image;
        } else {
            self.addImage.image = self.stepImage = [UIImage cacheImagewith:IMAGE_HOST_NOT_SHOP_(self.viewModel.editModel.imagePath)];

        }
        
        self.desc.text = self.viewModel.editModel.desc;
    }
}


- (IBAction)onComplete:(id)sender {
    [self.view endEditing:YES];
    
    
    YCRecipeStepListM *m = self.viewModel.editModel;
    if (m) {
        m.image = self.stepImage;
        m.desc = self.desc.text;
        [self.viewModel notifyUpdate];
    } else {
        CHECK(!self.desc.text.length, @"请填写制作步骤");
        CHECK(!self.stepImage, @"请添加图片");
        
        
        m = [YCRecipeStepListM new];
        m.image = self.stepImage;
        m.desc = self.desc.text;
        [self.viewModel addModel:m];
    }
    
    if (!self.viewModel.materialVM.isEditMode) {
        [self.viewModel saveCacheViewModel];
        //[self showMessage:@"已保存编辑状态"];
    }
    
    self.viewModel.editModel = nil;
    [self onReturn];
}


- (IBAction)onTakePhone:(id)sender {
    [self.view endEditing:YES];
    [self.picker showActionSheetOnViewController:self onPopoverFromView:self.view editImage:self.stepImage];
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
        UIImage *img = [image resizedImageToFitInSize:image.size scaleIfSmaller:YES];
           //得到图片
            SSELF;
            self.addImage.image = self.stepImage = img;

    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(tableView.bounds);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
