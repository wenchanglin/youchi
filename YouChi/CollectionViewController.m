//
//  CollectionViewController.m
//  YouChi
//
//  Created by sam on 16/8/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <Method>
- (void)_setupWith:(NSArray *)cellInfos
{
    NSParameterAssert(cellInfos);
    _cellInfos = cellInfos;
    for (CellInfo *cellInfo in cellInfos) {
        [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:cellInfo.Id];
        if (cellInfo.headInfo) {
            [self.collectionView registerClass:[CollectionHeaderFooter class] forSupplementaryViewOfKind:_headerKind withReuseIdentifier:cellInfo.headInfo.Id];
        }
        
        if (cellInfo.footInfo) {
            [self.collectionView registerClass:[CollectionHeaderFooter class] forSupplementaryViewOfKind:_footerKind withReuseIdentifier:cellInfo.footInfo.Id];
        }
    }
}

- (void)registerCellInfos:(NSArray<CellInfo *> *)cellInfos
{
    [self registerCellInfos:cellInfos count:1];
}

- (void)registerCellInfos:(NSArray<CellInfo *> *)cellInfos count:(NSUInteger)count
{
    NSMutableArray *infos = [NSMutableArray new];
    for (int n = 0; n<count; n++) {
        [infos addObjectsFromArray:cellInfos];
    }
    [self _setupWith:infos];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _cellInfos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CellInfo *info = _cellInfos[section];
    return info.numberBlock(section);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellInfo *info = _cellInfos[indexPath.section];
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:info.Id forIndexPath:indexPath];
    if (cell.collectionView != collectionView) {
        cell.collectionView = collectionView;
        
        if ([_configureDelegate respondsToSelector:@selector(onConfigureCell:reuseIdentifier:collectionView:)]) {
            [_configureDelegate onConfigureCell:cell reuseIdentifier:cell.reuseIdentifier collectionView:collectionView];
        }
    }
    [cell executeUpdate:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellInfo *info = _cellInfos[indexPath.section];
    return info.sizeBlock(indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = (CollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSParameterAssert([cell isKindOfClass:[CollectionCell class]]);
    [cell executeSelect:indexPath];
}


#pragma mark - element
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CellInfo *info = _cellInfos[indexPath.section];
    
    if (info.headInfo) {
        CollectionHeaderFooter *header = [collectionView dequeueReusableSupplementaryViewOfKind:_headerKind withReuseIdentifier:info.headInfo.Id forIndexPath:indexPath];
        if (header.collectionView != collectionView && [_configureDelegate respondsToSelector:@selector(onConfigureHeader:reuseIdentifier:)]) {
            header.collectionView = collectionView;
            [_configureDelegate onConfigureHeader:header reuseIdentifier:info.headInfo.Id];
        }
        return header;
    }
    
    if (info.footInfo) {
        CollectionHeaderFooter *header = [collectionView dequeueReusableSupplementaryViewOfKind:_footerKind withReuseIdentifier:info.footInfo.Id forIndexPath:indexPath];
        if (header.collectionView != collectionView && [_configureDelegate respondsToSelector:@selector(onConfigureFooter:reuseIdentifier:)]) {
            header.collectionView = collectionView;
            [_configureDelegate onConfigureFooter:header reuseIdentifier:info.footInfo.Id];
        }
        return header;
    }
    
    return nil;
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
