//
//  LocalImageViewController.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/24.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "LocalImageViewController.h"
#import "LocalImageCollectionViewCell.h"
#import "Masonry.h"
#import "ProgressHUD.h"
#import "AppConstants.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CELL_NAME @"LocalImageCollectionViewCell"

@interface LocalImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView                                        *footView;
@property (strong, nonatomic) NSMutableArray                                *photoImages;
@property (strong, nonatomic) UICollectionView                              *collectionView;
@property (strong, nonatomic) UIButton                                      *endBtn;
@property (strong, nonatomic) UIImageView                                   *countImageView;
@property (strong, nonatomic) UILabel                                       *countLabel;
@property (strong, nonatomic) NSMutableArray                                *selectedArray;
@property (strong, nonatomic) NSMutableArray                                *selectedImages;

@end

@implementation LocalImageViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGPoint bottomOffset = CGPointMake(0, _collectionView.contentSize.height - _collectionView.bounds.size.height);
    [_collectionView setContentOffset:bottomOffset animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initFootBar];
    [self initCollectionView];
    
    ALAssetsLibrary *_assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    _photoImages = [[NSMutableArray alloc] init];
    _selectedArray = [[NSMutableArray alloc] init];
    _selectedImages = [[NSMutableArray alloc] init];
    
    ///ALAssetsGroupLibrary
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos|ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result){
                UIImage *img = [UIImage imageWithCGImage:result.thumbnail];
//                CGImageRef ref = [[result  defaultRepresentation]fullScreenImage];
                
//                UIImage *img = [[UIImage alloc]initWithCGImage:ref];
                
//                NSData * imageData = UIImageJPEGRepresentation(image,1);
                
//                length = [imageData length]/1000;
                NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                
                if(img)
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:img forKey:@"img"];
                    [dic setObject:@"0" forKey:@"flag"];
                    [dic setObject:urlstr forKey:@"url"];
                    [dic setObject:[NSNumber numberWithUnsignedInteger:index] forKey:@"index"];
                    [_photoImages addObject:dic];
                }
                if(index + 1 == group.numberOfAssets)
                {
                    ///最后一个刷新界面
                    [self finish];
                }
            }
        }];
    } failureBlock:^(NSError *error) {
        // error
        NSLog(@"error ==> %@",error.localizedDescription);
    }];
}

- (void)initNavigationBar {
    self.navigationItem.title = NSLocalizedString(@"tupianxuanze", @"");
}

- (void)initFootBar {
    _footView = [[UIView alloc] init];
    _footView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:234.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    _countImageView = [[UIImageView alloc] init];
    _countImageView.image = [UIImage imageNamed:@"imageCountBg"];
    _countImageView.hidden = NO;
    
    _countLabel = [[UILabel alloc] init];
    [_countLabel setBackgroundColor:[UIColor clearColor]];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.hidden = NO;
    _countLabel.text = @"0";
    
    _endBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _endBtn.layer.cornerRadius = 5;
//    _endBtn.backgroundColor = [UIColor clearColor];
//    浅绿色，完成按钮
    _endBtn.backgroundColor = [UIColor colorWithRed:126.0/255.0 green:222.0/255.0 blue:0.0/255.0 alpha:1.0];
    [_endBtn setTitle:NSLocalizedString(@"wancheng", @"") forState:UIControlStateNormal];
    _endBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [_endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_endBtn addTarget:self action:@selector(endBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _endBtn.enabled = YES;
    
    [self.view addSubview:_footView];
    [_footView addSubview:_countImageView];
    [_footView addSubview:_countLabel];
    [_footView addSubview:_endBtn];
    
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(self.view);
        make.height.equalTo(@36);
    }];
    
    [_endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footView).with.offset(3);
        make.right.equalTo(self.view).with.offset(-5);
        make.bottom.equalTo(_footView).with.offset(-3);
        make.width.equalTo(@50);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footView).with.offset(8);
        make.right.equalTo(_endBtn.mas_left).with.offset(-8);
        make.bottom.equalTo(_footView).with.offset(-8);
        make.width.equalTo(@20);
    }];
    
    [_countImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_countLabel);
        make.right.equalTo(_endBtn.mas_left).with.offset(-8);
        make.width.and.height.equalTo(@30);
    }];
}

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.collectionViewLayout = flowLayout;
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.bottom.equalTo(_footView.mas_top);
    }];
}

- (void)finish
{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_photoImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [collectionView registerNib:[UINib nibWithNibName:CELL_NAME bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CELL_NAME];
    
    [collectionView registerClass:[LocalImageCollectionViewCell class] forCellWithReuseIdentifier:CELL_NAME];
    
    LocalImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_NAME forIndexPath:indexPath];
    cell.selectImageView.tag = indexPath.row;
    if (indexPath.row < [_photoImages count])
    {
        id dic = [_photoImages objectAtIndex:indexPath.row];
        [cell sendValue:dic];
    }
    return cell;
}

#pragma mark - ---UICollectionViewDelegateFlowLayout
// 设置每个View的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWH = [UIScreen mainScreen].bounds.size.width / 4.0f - 10;
    return CGSizeMake(itemWH, itemWH);
}

// 设置每个图片的Margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectCount;
    
    LocalImageCollectionViewCell *cell = (LocalImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    id dic = [_photoImages objectAtIndex:indexPath.row];
    BOOL flag = [[dic objectForKey:@"flag"] boolValue];
    if (!flag)
    {
        selectCount = [self getSelectImageCount];
        if (selectCount >= _maxPhotoNumber) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil
                                                          message:[NSString stringWithFormat:NSLocalizedString(@"zuiduoxuanze", @""), (long)_maxPhotoNumber]
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"wozhidaole", @"")
                                                otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        [dic setObject:@"1" forKey:@"flag"];
        [_selectedArray addObject:dic];
    } else {
        [dic setObject:@"0" forKey:@"flag"];
        for (int i = 0; i < [_selectedArray count]; i++) {
            if ([[_selectedArray objectAtIndex:i] objectForKey:@"index"] == [dic objectForKey:@"index"]) {
                [_selectedArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    [cell setSelectFlag:!flag];
    
    selectCount = [self getSelectImageCount];

    if (selectCount > 0)
    {
        /*
        _endBtn.enabled = YES;
        _endBtn.backgroundColor = [UIColor colorWithRed:134/255.0f green:208/255.0f blue:0/255.0f alpha:1];
        _countLabel.hidden = NO;
        _countImageView.hidden = NO;*/
        _countLabel.text = [NSString stringWithFormat:@"%ld", (long)selectCount];
    }
    else {
        /*
        _endBtn.enabled = NO;
        _endBtn.backgroundColor = [UIColor clearColor];
        _countLabel.hidden = YES;
        _countImageView.hidden = YES;*/
        _countLabel.text = @"0";
    }
}

/**
 *  获取列表中有多少Image被选中
 *
 *  @return 选中个数
 */
- (NSInteger)getSelectImageCount
{
    NSInteger count = 0;
    for (NSInteger i = 0; i < [_photoImages count]; i++)
    {
        id dic = [_photoImages objectAtIndex:i];
        BOOL flag = [[dic objectForKey:@"flag"] boolValue];
        if (flag)
        {
            count++;
        }
    }

    return count;
}

/**
 *  完成按钮点击
 */
- (void)endBtnClick
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagesLoaded) name:@"imagesLoaded" object:nil];
    
    NSLog(@"完成按钮点击");
    
    [ProgressHUD show:NSLocalizedString(@"zhengzaichulitupian", @"")];
    if ([self.delegate respondsToSelector:@selector(getSelectImage:)])
    {
        if ([_selectedArray count] == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imagesLoaded" object:nil];
        }
        
        for (int i = 0; i < [_selectedArray count]; i++)
        {
            NSDictionary *dic = [_selectedArray objectAtIndex:i];
            
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            NSURL *url=[NSURL URLWithString:[dic objectForKey:@"url"]];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                UIImage *image=[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                
                UIImage *compressedImage;
                
                if ([UIImageJPEGRepresentation(image,1) length] / 1000 < 2000) {
                    compressedImage = image;
                }
                else {
                    compressedImage = [self compressImage:image];
                }
                
//                NSLog(@"image = %u, compressedImage = %lu", [UIImageJPEGRepresentation(image,1) length] / 1000, [UIImageJPEGRepresentation(compressedImage,1) length] / 1000);

                [_selectedImages addObject:compressedImage];
                
                image = nil;
                compressedImage = nil;
                
                if (i == [_selectedArray count] - 1) {
                    [ProgressHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"imagesLoaded" object:nil];
                }
            }failureBlock:^(NSError *error) {
                NSLog(@"error=%@",error);
                
                if (i == [_selectedArray count] - 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"imagesLoaded" object:nil];
                }
            }];
        }
    }
}

-(UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

/*
- (UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600;
    float maxWidth = 800;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.1;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}*/

/*
- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 1.0f;
    int resizeAttempts = 10;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length]/1000 > maxFileSize && resizeAttempts > 0) {
        resizeAttempts--;
        NSLog(@"compress size = %lu, compression = %f", [imageData length]/1000, compression);
        
        compression *= 0.5;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    NSLog(@"done compress size = %lu, compression = %f", [imageData length]/1000, compression);
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}*/

- (void)imagesLoaded {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imagesLoaded" object:nil];
    [self.delegate getSelectImage:_selectedImages];
//    [_selectedImages removeAllObjects];
    NSLog(@"pop");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
