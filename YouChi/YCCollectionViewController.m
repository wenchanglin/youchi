//
//  OFCollectionViewController.m
//  OrderingFood
//
//  Created by Mallgo on 15-3-31.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//

#import "YCCollectionViewController.h"
#import "MobClick.h"
#import <UIView+Toast.h>
#import <Masonry/Masonry.h>

@interface YCCollectionViewController ()

@end

@implementation YCCollectionViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    YCPageViewModel *vm = [self onCreateViewModel];
    YCCollectionViewController *vc = [super initWithCoder:aDecoder];
    [vc onSetupBackButton];
    vc.viewModel = vm;
    return vc;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    YCPageViewModel *vm = [self onCreateViewModel];
    YCCollectionViewController *vc = [super initWithCollectionViewLayout:layout];
    [vc onSetupBackButton];
    vc.viewModel = vm;
    return vc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[MobClick beginLogPageView:@"PageOne"];
    self.viewModel.active = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:@"PageOne"];
    self.viewModel.active = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    __weak UINavigationController *nav = self.navigationController;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)nav;


    [self onMainSignalExecute:nil];
    
}

- (NSIndexPath *)indexPathForCell:(id)cell
{
    return [self.collectionView indexPathForCell:cell];
}

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



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return [self.viewModel numberOfSections];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [self.viewModel cellIDAtIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    // Configure the cell
    [self onUpdateCell:cell model:[self.viewModel modelForItemAtIndexPath:indexPath] atIndexPath:indexPath];
    return cell;
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

- (id)onCreateViewModel
{
    return nil;
}


- (void)onReloadItems:(NSNumber *)items
{
    if ([NSThread isMainThread]) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        });
    }
}


- (void)onInsertItemsIntoBack:(NSNumber *)itemCount
{
    NSInteger addCount = [itemCount intValue];
    if (0 == addCount) {
        return;
    }
    NSInteger count = self.collectionView.visibleCells.count;
    if (count == 0) {
        [self onReloadItems:itemCount];
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:addCount];
            for (int n = 0; n < addCount; n++) {
                NSIndexPath *idxp = [NSIndexPath indexPathForItem:n+rowCount inSection:0];
                [arr addObject:idxp];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView insertItemsAtIndexPaths:arr];
            });
        });
        
        
        
    }
}


- (void)onInsertItemsIntoFront:(NSNumber *)itemCount
{
    NSInteger addCount = [itemCount intValue];
    if (0 == addCount) {
        return;
    }
    NSInteger count = self.collectionView.visibleCells.count;
    if (count == 0) {
        [self onReloadItems:itemCount];
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            NSInteger addCount = [itemCount intValue];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:addCount];
            for (int n = 0; n < addCount; n++) {
                NSIndexPath *idxp = [NSIndexPath indexPathForItem:n inSection:0];
                [arr addObject:idxp];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView insertItemsAtIndexPaths:arr];
            });
        });
    
    }
}


- (void)onUpdateCell:(UICollectionViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    [cell update:model atIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.sourceViewController;
    vc.hidesBottomBarWhenPushed = YES;
}

- (YCNextBlock)nextBlock
{
    if (!_nextBlock) {
        WSELF;
        _nextBlock = ^(NSArray *x) {
            SSELF;
            [self onReloadItems:nil];
        };
    }
    return _nextBlock;
}

- (YCErrorBlock)errorBlock
{
    if (!_errorBlock) {
        WSELF
        _errorBlock = ^(NSError *e){
            SSELF;
            [self showMessage:e.localizedDescription];
        };
    }
    return _errorBlock;
}

- (YCExecutingBlock)executingBlock
{
    if (!_executingBlock) {
        WSELF;
        _executingBlock = ^(BOOL isExecuting){
            SSELF;
            if (isExecuting) {
                self.collectionView.backgroundView = self.activityIndicatorView;
                [self.activityIndicatorView startAnimating];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityIndicatorView stopAnimating];
                });
            }
        };
    }
    return _executingBlock;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

- (void)dealloc
{

}
@end



@implementation YCWaterfallVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CHTCollectionViewWaterfallLayout *layout = (id)self.collectionViewLayout;
    //NSAssert([layout isKindOfClass:[CHTCollectionViewWaterfallLayout class]], @"类型不对");
    layout.minimumInteritemSpacing = 5;
    //layout.minimumColumnSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel fixedSize:collectionView.bounds.size forItemAtIndexPath:indexPath];
}

/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 19;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell1 forIndexPath:indexPath];
    
    // Configure the cell
    [self onUpdateCell:cell model:[self.viewModel modelForItemAtIndexPath:indexPath] atIndexPath:indexPath];
    return cell;
}
*/

- (void)dealloc
{
    
}
@end