//
//  YCPhotosView.m
//  YouChi
//
//  Created by sam on 15/5/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPhotosView.h"
#import "YCView.h"

@implementation YCPhotosView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc
{
    //ok
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        __weak UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate> *ws = self;
        self.dataSource = ws;
        self.delegate = ws;
        self.pagingEnabled = YES;
        self.scrollsToTop = NO;
        
        [ws registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cell0];
        self.cellIdBlock = ^(NSIndexPath *indexPath) {
            return cell0;
        };
    }
    
    return self;
}

- (void)awakeFromNib
{
    
    __weak UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate> *ws = self;
    self.dataSource = ws;
    self.delegate = ws;
    self.pagingEnabled = YES;
    self.scrollsToTop = NO;
    
    self.cellIdBlock = ^(NSIndexPath *indexPath) {
        return cell0;
    };
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = self.cellIdBlock(indexPath);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    self.updateBlock(cell,self.photos[indexPath.row]);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sizeBlock) {
        return self.sizeBlock(collectionView.bounds.size);
    }
    CGSize size = collectionView.bounds.size;
    return CGSizeMake(size.width, size.height);
}

- (void)scrollViewDidEndDecelerating:(UICollectionView *)scrollView
{
    NSIndexPath *idp = [scrollView indexPathsForVisibleItems].lastObject;
    if (self.pageBlock) {
        self.pageBlock(idp,self.photos[idp.row]);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(indexPath,self.photos.count>0?self.photos[indexPath.row]:nil);
    } 
}

@end
