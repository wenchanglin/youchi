                                                                                                     //
//  YCEditPhotoVC.m
//  YouChi
//
//  Created by sam on 15/9/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCEditPhotoVC.h"
#import <Masonry/Masonry.h>


@interface YCEditPhotoVC ()

@end


@implementation YCEditPhotoVC
-(void)dealloc{
    //    ok
    
    
}
- (instancetype)initWithImage:(UIImage *)image
{
    
    self = [super init];
    if (self) {
        if ([image isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)image;
            NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
            image = [[UIImage alloc]initWithData:imageData];
        } else if ([image isKindOfClass:[YCImageModel class]]) {
            YCImageModel *im = (YCImageModel *)image;
            NSData *imageData = [NSData dataWithContentsOfURL:im.fileUrl options:NSDataReadingMappedIfSafe error:nil];
            image = [[UIImage alloc]initWithData:imageData];
        }
        self.originImage = image;
        
#if TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
        pg_edit_sdk_controller_object *object = [[pg_edit_sdk_controller_object alloc]init];
        object.pCSA_fullImage = image;
        pg_edit_sdk_controller *vc = [[pg_edit_sdk_controller alloc]initWithEditObject:object withDelegate:self];
        if (vc) {
            [self.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            [self addChildViewController:vc];
            [vc didMoveToParentViewController:self];
        }
#endif
    }
    return self;
}

- (instancetype)initWithImageModel:(YCImageModel *)imageModel
{
    NSData *imageData = [NSData dataWithContentsOfURL:imageModel.fileUrl options:NSDataReadingMappedIfSafe error:nil];
    UIImage *image = [[UIImage alloc]initWithData:imageData];
    return [self initWithImage:image];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#if TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
/**
 *  完成后调用，点击保存，object 是 pg_edit_sdk_controller_object 对象
 *  Invoke after completion, click save, object's target is pg_edit_sdk_controller_object
 */
- (void)dgPhotoEditingViewControllerDidFinish:(UIViewController *)pController
                                       object:(pg_edit_sdk_controller_object *)object
{
    if (self.nextBlock) {
        self.nextBlock([[UIImage alloc]initWithData:object.pOutEffectOriData]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  完成后调用，点击取消
 *  Invoke after completion, click cancel
 */
- (void)dgPhotoEditingViewControllerDidCancel:(UIViewController *)pController withClickSaveButton:(BOOL)isClickSaveBtn;
{
    if (isClickSaveBtn) {
        if (self.nextBlock) {
            self.nextBlock(self.originImage);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
