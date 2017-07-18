//
//  YCIssueCasuaFlmVC.m
//  YouChi
//
//  Created by 李李善 on 15/5/21.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "MBProgressHUD.h"
#import "YCRandomPicturesVC.h"
#import "UIButton+MJ.h"

#import <Masonry/Masonry.h>
#import "YCMaterialVC.h"
#import "YCRandomPicturesVM.h"

#import "YCView.h"
#import "YCMyWorksVC.h"
#import <SDWebImage/SDImageCache.h>
@interface YCRandomPicturesVC ();
///标题
///内容
///定位位置
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (nonatomic,weak) IBOutlet IQTextView *content;
@property (weak, nonatomic) IBOutlet UITextField *materialName;
PROPERTY_STRONG YCRandomPicturesListVC *imageModelsVC;
PROPERTY_STRONG_VM(YCRandomPicturesVM);
@end

@implementation YCRandomPicturesVC
SYNTHESIZE_VM;
- (void)dealloc{
    //ok
}

- (id)onCreateViewModel
{
    YCRandomPicturesVM *vm = [YCRandomPicturesVM cacheViewModel];
    if (!vm) {
        vm = [YCRandomPicturesVM new];
    }
    return vm;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    WSELF;
    self.title = @"发布随手拍";
    
    self.content.placeholder = @"说点什么";
    self.materialName.text = self.viewModel.materialName;
    self.content.text = self.viewModel.desc;
    
    self.area.text = @"地理位置";
    
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [self.viewModel.modelsProxy enumerateObjectsUsingBlock:^(YCImageModel * _Nonnull im, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![mgr diskImageExistsForURL:im.fileUrl]) {
            [[SDWebImageManager sharedManager]downloadImageWithURL:im.fileUrl options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
               [[SDWebImageManager sharedManager]saveImageToCache:image forURL:imageURL];
                im.fileUrl = imageURL;
            }];
        }
    }];
    
    [[YCLocationManager sharedLocationManager] startUpdatingLocation:^(NSError *error, YCLocationInfo *x) {
        SSELF;
        if (error) {
            [self showMessage:error.localizedDescription];
        } else {
            self.area.text = x.lastCity;
            self.viewModel.city = x.lastCity;
            self.viewModel.latitude = @(x.lastLocation.coordinate.latitude);
            self.viewModel.longitude = @(x.lastLocation.coordinate.longitude);
        }
        
    }];
    
    
}


#pragma mark --发布按钮
- (IBAction)onPublish:(UIBarButtonItem *)sender
{
    WSELF;
    [self.view endEditing:YES];
    
    CHECK(self.materialName.text.length==0, @"请输入食材名称");
    CHECK(self.content.text.length==0, @"请输入描述");
    CHECK(self.viewModel.modelsProxy.count==0, @"请添加至少一张图片");
    
    self.viewModel.materialName = self.materialName.text;
    self.viewModel.desc = self.content.text;
    
    [SVProgressHUD show];
    [self showMessage:@"正在上传，请稍候"];
    
    RACSubject *msg = [RACSubject subject];
    [msg subscribeNext:^(id x) {
        SSELF;
        [self showMessage:x];
    }];
    [sender executeSignal:[self.viewModel signalUploadWith:msg] next:^(id next) {
        [self showmMidMessage:@"上传随手拍成功"];
        [self.viewModel deleteCacheViewModel];
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:YCPhotoNotification object:nil];
        
    } error:self.errorBlock completed:^{
        [SVProgressHUD dismissWithDelay:0.5];
    } executing:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return CGRectGetWidth(tableView.bounds)*2/3 + 10;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section== 3) {
        WSELF;
        YCSelectCityVM  *vm = [[YCSelectCityVM alloc]init];
        vm.selectCity = [RACSubject subject];
        vm.selCity = self.viewModel.city;
        [vm.selectCity  subscribeNext:^(id x) {
            SSELF;
            self.viewModel.city = self.area.text = x;
        }];
        [self pushTo:[YCSelectCityVC class] viewModel:vm];
    }
}

// 关闭
- (IBAction)onClose:(id)sender {
    WSELF;
    [self.view endEditing:YES];
    if (self.materialName.text.length==0 && self.content.text.length==0 && self.viewModel.modelsProxy.count==0) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否把数据保存为草稿？" delegate:nil cancelButtonTitle:@"放弃" otherButtonTitles:@"确定",@"删除", nil];
        [av.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
            SSELF;
            
            if (x.intValue ==1) {
                self.viewModel.materialName = self.materialName.text;
                self.viewModel.desc = self.content.text;
                
                [self.viewModel saveCacheViewModel];
            }
            else if (x.intValue ==2) {
                self.viewModel.materialName = nil;
                self.viewModel.desc = nil;
                [self.viewModel.modelsProxy removeAllObjects];
                [self.viewModel deleteCacheViewModel];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [av show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WSELF;
    if ([segue.destinationViewController isKindOfClass:[YCRandomPicturesListVC class]]) {
        YCRandomPicturesListVC *vc = segue.destinationViewController;
        [vc.imageModels setArray:self.viewModel.modelsProxy];
        [vc setImageModelUpdateBlock:^(NSMutableArray<YCImageModel *> *imageModels) {
            SSELF;
            [self.viewModel.modelsProxy setArray:imageModels];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


@interface YCRandomPicturesListVC ()
{
    CGFloat w,h;
    
}

@end
@implementation YCRandomPicturesListVC
@synthesize imageModels = _imageModels,picker = _picker;

- (void)dealloc
{
    //ok
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat ww = CGRectGetWidth(self.view.bounds);
    CGFloat margin = 10.f;
    int count = 3;
    w = (ww -(count+1)*margin)/count;
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
    layout.minimumInteritemSpacing = margin;
    layout.minimumColumnSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    layout.columnCount = count;
    layout.minimumContentHeight = w;
    [self.collectionView setCollectionViewLayout:layout];
    
    //    [self registerCellInfos:@[
    //                              [CellInfo cellInfoWithId:cell0 number:^NSInteger(NSInteger section) {
    //        return 1;
    //    } model:nil edge:nil size:^CGSize(NSIndexPath * _Nonnull indexPath) {
    //        return CGSizeMake(w, w);
    //    } headInfo:nil footInfo:nil]
    //                              ]];
    
}

- (NSMutableArray *)imageModels
{
    if (!_imageModels) {
        _imageModels = [NSMutableArray new];
    }
    return _imageModels;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageModels.count == 6) {
        return 6;
    }
    return self.imageModels.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIDAtIndexPath:indexPath] forIndexPath:indexPath];
    [self onUpdateCell:cell model:[self modelForItemAtIndexPath:indexPath] atIndexPath:indexPath];
    return cell;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageModels.count) {
        return cell2;
    }
    return cell1;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageModels.count) {
        return nil;
    }
    
    return self.imageModels[indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(w, w);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != self.imageModels.count) {
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"菜单" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"滤镜",@"删除",@"查看", nil];
        WSELF;
        [[as.rac_buttonClickedSignal ignore:@(as.cancelButtonIndex)] subscribeNext:^(NSNumber *x) {
            SSELF;
            int index = x.intValue;
            YCImageModel *im = self.imageModels[indexPath.row];
#pragma mark - 滤镜
            if (index == 0) {
                YCEditPhotoVC *vc = [[YCEditPhotoVC alloc]initWithImageModel:im];
                
                vc.nextBlock = ^(UIImage *img) {
                    SSELF;
                    //得到图片
                    SDImageCache *cache = [SDWebImageManager sharedManager].imageCache;
                    
                    NSString *key = [NSDate date].description;
                    
                    [cache storeImage:img forKey:key];
                    NSURL *url = [NSURL fileURLWithPath:[cache defaultCachePathForKey:key]];
                    
                    im.imageSize = img.size;
                    im.fileUrl = url;
                    
                    [self.imageModels replaceObjectAtIndex:indexPath.row withObject:im];
                    if (self.imageModelUpdateBlock) {
                        self.imageModelUpdateBlock(self.imageModels);
                    }
                    [collectionView reloadData];
                    
                };
                [self presentViewController:vc animated:YES completion:nil];
                
                
            }
#pragma mark - 删除
            else if (index == 1) {
                [self.imageModels removeObjectAtIndex:indexPath.row];
                if (self.imageModelUpdateBlock) {
                    self.imageModelUpdateBlock(self.imageModels);
                }
                [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }
#pragma mark - 查看
            else if (index == 2){
                YCPhotoBrowser *browser = [[YCPhotoBrowser alloc]initWithPageModels:self.imageModels selectedIndex:indexPath.row];
                [browser setUrlBlock:^NSURL *(YCImageModel *model) {
                    return model.fileUrl;
                }];
                [self.navigationController pushViewController:browser animated:YES];
            }
            
            
            
        }];
        
        [as showInView:collectionView];
    } else {
        [self.picker showActionSheetOnViewController:self onPopoverFromView:self.view];
    }
    
    
}

- (GKImagePicker *)picker
{
    if (!_picker) {
        _picker = [[GKImagePicker alloc]init];
        _picker.delegate = self;
        _picker.enforceRatioLimits = YES;
        _picker.resizeableCropArea = NO;
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGSize rect = CGSizeMake( width, width*kRatioImage);
        _picker.cropSize = rect;
    }
    return  _picker;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 * @method imagePicker:pickedImage: gets called when a user has chosen an image
 * @param imagePicker, the image picker instance
 * @param image, the picked and cropped image
 */
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image;
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        SDImageCache *cache = [SDWebImageManager sharedManager].imageCache;
        UIImage *img = [self fixOrientation:image];
        NSString *key = [NSDate date].description;
        
        [cache storeImage:img forKey:key];
        NSURL *url = [NSURL fileURLWithPath:[cache defaultCachePathForKey:key]];
        
        YCImageModel *im = [YCImageModel new];
        im.fileUrl = url;
        im.imageSize = img.size;
        im.cacheKey = key;
        
        [self.imageModels addObject:im];
        
        dispatch_async_on_main_queue(^{
            if (self.imageModelUpdateBlock) {
                self.imageModelUpdateBlock(self.imageModels);
            }
            [self.collectionView reloadData];
        });
    });
    
    
    
    /*
     image = [image resizedImageToFitInSize:imagePicker.cropSize scaleIfSmaller:YES];
     NSString *key = [NSDate date].description;
     SDImageCache *cache = [SDImageCache sharedImageCache];
     [cache storeImage:image forKey:key];
     NSURL *url = [NSURL fileURLWithPath:[cache defaultCachePathForKey:key]];
     [self.viewModel addModel:url];
     [self onReloadItems:nil];
     */
    
    /*
     image = [image resizedImageToFitInSize:imagePicker.cropSize scaleIfSmaller:YES];
     SDWebImageManager *manager = [SDWebImageManager sharedManager];
     NSString *key = [NSDate date].description;
     NSURL *url = [NSURL fileURLWithPath:[manager.imageCache defaultCachePathForKey:key]];
     [manager saveImageToCache:image forURL:url];
     [self.viewModel addModel:url];
     [self onReloadItems:nil];
     */
}

#pragma mark -


- (void)onUpdateCell:(UICollectionViewCell *)cell model:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell.reuseIdentifier isEqualToString:cell1]) {
        if ([url isKindOfClass:[NSURL class]]) {
            
            [[SDWebImageManager sharedManager]downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [cell.contentView setBackgroundImage:image];
            }];
        } else if ([url isKindOfClass:[NSString class]]) {
            [[YYImageCache sharedCache] getImageForKey:(id)url withType:YYImageCacheTypeAll withBlock:^(UIImage *image, YYImageCacheType type) {
                [cell.contentView setBackgroundImage:image];
            }];
            
        } else if ([url isKindOfClass:[YCImageModel class]]) {
            YCImageModel *im = (YCImageModel *)url;
            
            [[SDWebImageManager sharedManager]downloadImageWithURL:im.fileUrl options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                
                [cell.contentView setBackgroundImage:image];
            }];
            
        }
        
        else if ([url isKindOfClass:[UIImage class]]) {
            [cell.contentView setBackgroundImage:(id)url];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}
@end



