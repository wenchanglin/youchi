//
//  CellBlock.h
//  funvive
//
//  Created by DengZhiMin on 16/3/23.
//  Copyright © 2016年 jiquke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^CellInitBlock)(__kindof UIView *contentView);
typedef void(^CellFrameBlock)(CGRect frame);
typedef void(^CellIndexPathBlock)(NSIndexPath *indexPath);


@protocol CellBlockSource <NSObject>
@optional
///初始化方法，只执行一次
- (void)setInitBlock:(CellInitBlock )initBlock;
///后台线程初始化方法，只执行一次
- (void)setInitAsyncBlock:(CellInitBlock )initAsyncBlock;

///更新
- (void)setUpdateBlock:(CellIndexPathBlock )updateBlock;

///位置
- (void)setLayoutBlock:(CellFrameBlock )layoutBlock;
///自动约束位置，只执行一次
- (void)setAutoLayoutBlock:(CellFrameBlock )autoLayoutBlock;

///点击方法
- (void)setSelectBlock:(CellIndexPathBlock )selectBlock;
@end

@interface CellBlockData : NSObject
{
@public
    CellInitBlock _initAsyncBlock;
    CellFrameBlock _layoutBlock;
    CellFrameBlock _autoLayoutBlock;
    CellIndexPathBlock _updateBlock;
    CellIndexPathBlock _selectBlock;
}
@end

@protocol CellDataSource <NSObject>
@required
@property (nonatomic,weak,readonly) id modelData;

- (BOOL)containModelData:(id)modelData;
@end

@interface TableCell : UITableViewCell<CellBlockSource,CellDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) UIEdgeInsets edge;
@property (nonatomic,weak) NSIndexPath *initialIndexPath;
@property (nonatomic,assign,readonly) CGSize contentSize;

- (void)executeUpdate:(NSIndexPath *)indexPath;
- (void)executeSelect:(NSIndexPath *)indexPath;
- (void)registerContentViewClass:(Class)contentViewClass;

@end

@interface CollectionCell : UICollectionViewCell<CellBlockSource,CellDataSource>
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,assign) UIEdgeInsets edge;
- (void)executeUpdate:(NSIndexPath *)indexPath;
- (void)executeSelect:(NSIndexPath *)indexPath;
- (void)registerContentViewClass:(Class)contentViewClass;
@end

@interface TableHeaderFooter : UITableViewHeaderFooterView<CellBlockSource,CellDataSource>
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,weak) UITableView *tableView;
- (void)executeUpdate:(NSIndexPath *)indexPath;
- (void)executeSelect:(NSIndexPath *)indexPath;
//- (void)registerContentViewClass:(Class)contentViewClass;
@end

@interface CollectionHeaderFooter : UICollectionReusableView<CellBlockSource,CellDataSource>
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,weak) UICollectionView *collectionView;
@end

@protocol CellConfigureDelegate <NSObject>
@optional

- (void)onConfigureCell:(__weak __kindof TableCell *)cell reuseIdentifier:(NSString *)reuseIdentifier tableView:(__weak __kindof UITableView *)tableView;
- (void)onConfigureCell:(__weak __kindof CollectionCell *)cell reuseIdentifier:(NSString *)reuseIdentifier collectionView:(__weak __kindof UICollectionView *)collectionView;

- (void)onConfigureHeader:(__weak __kindof UIView *)header reuseIdentifier:(NSString *)reuseIdentifier;
- (void)onConfigureFooter:(__weak __kindof UIView *)footer reuseIdentifier:(NSString *)reuseIdentifier;
@end

typedef void(^CellConfigureBlock)(__weak __kindof UIView *cell,NSString *reuseIdentifier);
@interface CellConfigureDelegateObject : NSObject<CellConfigureDelegate>
- (instancetype)initWithBlock:(CellConfigureBlock)block;
@end
NS_ASSUME_NONNULL_END