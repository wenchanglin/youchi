//
//  OFCollectionViewController.h
//  OrderingFood
//
//  Created by Mallgo on 15-3-31.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Action.h"
#import "YCViewModel.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "YCViewController.h"
@interface YCCollectionViewController : UICollectionViewController
@property (nonatomic,strong) YCPageViewModel *viewModel;
@property (nonatomic,strong) YCNextBlock nextBlock;
@property (nonatomic,strong) YCErrorBlock errorBlock;
@property (nonatomic,strong) YCCompleteBlock completeBlock;
@property (nonatomic,strong) YCExecutingBlock executingBlock;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

- (id)onCreateViewModel;

- (void)onInsertItemsIntoFront:(NSNumber *)itemCount;
- (void)onInsertItemsIntoBack:(NSNumber *)itemCount;
- (void)onReloadItems:(NSNumber *)items;

- (void)onUpdateCell:(UICollectionViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForCell:(id)cell;
@end


@interface YCWaterfallVC : YCCollectionViewController <CHTCollectionViewDelegateWaterfallLayout>

@end