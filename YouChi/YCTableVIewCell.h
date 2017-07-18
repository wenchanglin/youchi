//
//  YCTableVIewCell.h
//  YouChi
//
//  Created by sam on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"

@class YCTableVIewCell;
@protocol  YCTableVIewCellDelegate<NSObject>
@optional
- (void)onConfigureCell:(__kindof __weak YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier;

@end
typedef void(^YCCellInitBlock)(__kindof __weak YCTableVIewCell *cell,UIView *view,NSString *reuseIdentifier);
typedef void(^YCCellLayoutBlock)(__kindof __weak YCTableVIewCell *cell,UIView *view,CGRect frame);
typedef void(^YCCellUpdateBlock)(__kindof __weak YCTableVIewCell *cell,UIView *view,NSIndexPath *indexPath);
typedef void(^YCCellSelectBlock)(__kindof __weak YCTableVIewCell *cell,UIView *view,NSIndexPath *indexPath);

@interface YCTableVIewCell : UITableViewCell
@property (nonatomic,weak) UIViewController<YCTableVIewCellDelegate> *delegate;
@property (nonatomic,weak) id data;

@property (nonatomic,strong) YCCellUpdateBlock updateBlock;
@property (nonatomic,strong) YCCellLayoutBlock layoutBlock;
@property (nonatomic,strong) YCCellLayoutBlock autoLayoutBlock;
@property (nonatomic,strong) YCCellSelectBlock selectBlock;
@property (nonatomic,strong) YCCellInitBlock reuseBlock;

- (void)setInitBlock:(YCCellInitBlock)initBlock;
- (void)setInitAsyncBlock:(YCCellInitBlock)initBlock;
- (void)setUpdateBlock:(YCCellUpdateBlock)updateBlock;
- (void)setAutoLayoutBlock:(YCCellLayoutBlock)autoLayoutBlock;
- (void)setLayoutBlock:(YCCellLayoutBlock)layoutBlock;
- (void)setSelectBlock:(YCCellSelectBlock)selectBlock;
- (void)setReuseBlock:(YCCellInitBlock)reuseBlock;

- (BOOL)checkIsHasSetData:(id )data;

- (void)updateAtIndexPath:(NSIndexPath *)indexPath;
- (void)setBackgroundClearColor;
- (void)setContentViewClearColor;
@end
