//
//  OFTableViewController.h
//  OrderingFood
//
//  Created by Mallgo on 15-3-20.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Action.h"
#import "YCViewModel.h"
#import "YCViewController.h"
#import "NSString+MJ.h"
#import "YCViewModel+Logic.h"

#import "YCLoadControl.h"
#import "YCMoreButton.h"
#import "YCView.h"
#import <JDFNavigationBarActivityIndicator/JDFNavigationBarActivityIndicator.h>
#import "YCEmptyView.h"
#import <MUKPullToRevealControl/MUKCirclePullToRefreshControl.h>
#import "YCTableVIewCell.h"
#import "YCTableViewHeaderFooterView.h"
#import <Masonry/Masonry.h>
@interface YCStaticViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic,strong) NSArray *nextResponders;///键盘下一个
@property (nonatomic,strong) __kindof YCPageViewModel *viewModel;
@property (nonatomic,strong) YCNextBlock nextBlock;
@property (nonatomic,strong) YCErrorBlock errorBlock;
@property (nonatomic,strong) YCCompleteBlock completeBlock;
@property (nonatomic,strong) YCExecutingBlock executingBlock;


- (id)onCreateViewModel;
- (void)onSetupRefreshControl;
- (void)onSetupActivityIndicatorView;
- (void)onSetupCell;
- (void)onSetupHeaderFooter;
- (void)onKeyboardDone:(id)sender;
-(void)onRegisterNibName:(NSString *)name Identifier:(NSString *)identifier;
-(void)onRegisterNibName:(NSString *)name HeaderFooterViewIdentifier:(NSString *)identifier;
@end

@interface YCTableViewController : YCStaticViewController

@property (nonatomic,strong) YCLoadControl *loadControl;
@property (nonatomic,strong) YCMoreButton *moreButton;
@property(nonatomic,strong) YCEmptyView *emptyView;
@property(nonatomic,strong) JDFNavigationBarActivityIndicator *indicator;
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong) MUKCirclePullToRefreshControl *refresh;

- (id)onCreateViewModel;
- (void)onSetupFooter;
- (void)onSetupEmptyView;
- (void)onSetupCommentButton:(NSArray *)arr;

- (void)onInsertItemsIntoFront:(NSInteger )itemCount;
- (void)onInsertItemsIntoBack:(NSInteger )itemCount;
- (void)onInsertSectionsIntoBack:(NSInteger)sectionCount;

- (void)onReloadItems:(NSInteger )itemCount;


- (void)onUpdateCell:(__weak UITableViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForCell:(id)cell;
- (NSIndexPath *)indexPathForSelectedCell;

- (id )cellForindexPath:(NSIndexPath *)indexPath;

- (void)onScrollToBottom:(UIScrollView *)scrollView;

- (void)onMoreComment:(UIButton *)sender;




@end


@interface YCBTableViewController : YCTableViewController <YCTableVIewCellDelegate,YCTableVIewHeaderFooterViewDelegate>
- (instancetype)init;
- (void)onSetupCell;
- (void)onSetupHeaderFooter;
- (void)onConfigureCell:(__kindof __weak YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier;
- (void)onConfigureHeader:(__kindof __weak YCTableViewHeaderFooterView *)header reuseIdentifier:(NSString *)reuseIdentifier;
- (void)onConfigureFooter:(__kindof __weak YCTableViewHeaderFooterView *)footer reuseIdentifier:(NSString *)reuseIdentifier;
@end