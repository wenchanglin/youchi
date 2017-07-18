//
//  CellBlock.m
//  funvive
//
//  Created by DengZhiMin on 16/3/23.
//  Copyright © 2016年 jiquke. All rights reserved.
//

#import "Cell.h"

@implementation CellBlockData
@end

@implementation TableCell
{
    id _modelData;
    id _layoutData;
    
    CellBlockData *_blockData;
    UIView *__contentView;
    Class _contentViewClass;
}

- (void)dealloc
{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _blockData = [CellBlockData new];
    
    self.selectedBackgroundView = [UIView new];
    [self.selectedBackgroundView setBackgroundColor:[[UIColor brownColor] colorWithAlphaComponent:0.1]];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

#pragma mark - block
- (void)setInitBlock:(CellInitBlock)initBlock
{
    NSParameterAssert(initBlock);
    NSParameterAssert([NSThread isMainThread]);
    if (_contentViewClass) {
        __contentView = [_contentViewClass new];
        
    } else {
        __contentView = [UIView new];
    }
    //[__contentView setBackgroundColorWhite];
    __contentView.frame = self.contentView.bounds;
    initBlock(__contentView);
    if (_blockData->_autoLayoutBlock) {
        _blockData->_autoLayoutBlock(__contentView.bounds);
    }
    [self.contentView addSubview:__contentView];
}

- (void)setInitAsyncBlock:(CellInitBlock)initAsyncBlock
{
    NSParameterAssert(initAsyncBlock);
    
    dispatch_async(YYDispatchQueueGetForQOS(NSQualityOfServiceBackground), ^{
        if (_contentViewClass) {
            __contentView = [_contentViewClass new];
            
        } else {
            __contentView = [UIView new];
        }
        
        
        __contentView.frame = self.contentView.bounds;
        initAsyncBlock(__contentView);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.contentView addSubview:__contentView];
            //[__contentView setBackgroundColorWhite];
            
            if (_blockData->_autoLayoutBlock) {
                _blockData->_autoLayoutBlock(__contentView.bounds);
                _blockData->_autoLayoutBlock = nil;
            }
            
            if (_blockData->_updateBlock) {
                NSIndexPath *idp = [_tableView indexPathForCell:self];
                if (idp && [_tableView.indexPathsForVisibleRows containsObject:idp]) {
                    _blockData->_updateBlock(idp);
                    
                }
                

            }
            [self setNeedsLayout];
            
            
            
        });
    });
    
}


- (void)setUpdateBlock:(CellIndexPathBlock)updateBlock
{
    _blockData->_updateBlock = updateBlock;
}

- (void)setLayoutBlock:(CellFrameBlock)layoutBlock
{
    _blockData->_layoutBlock = layoutBlock;
    [self setNeedsLayout];
}

- (void)setAutoLayoutBlock:(CellFrameBlock)autoLayoutBlock
{
    _blockData->_autoLayoutBlock = autoLayoutBlock;
    [self setNeedsLayout];
}


- (void)setSelectBlock:(CellIndexPathBlock)selectBlock
{
    _blockData->_selectBlock = selectBlock;
}

#pragma mark - data
- (id)modelData
{
    return _modelData;
}


- (BOOL)containModelData:(id)modelData
{
    if (modelData != _modelData) {
        _modelData = modelData;
        return NO;
    }
    return YES;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = UIEdgeInsetsInsetRect(self.contentView.bounds, _edge);
    __contentView.frame = bounds;
    if (self.accessoryType == UITableViewCellAccessoryNone && !self.accessoryView) {
        self.selectedBackgroundView.frame = bounds;
    } else {
        self.selectedBackgroundView.frame = self.bounds;
    }
    
    if (_blockData->_layoutBlock) {
        bounds.origin = CGPointZero;
        _blockData->_layoutBlock(bounds);
    }
}

- (void)setContentViewWhiteColor
{
    [self setContentViewColor:[UIColor whiteColor]];
}

- (void)setContentViewClearColor
{
    [self setContentViewColor:[UIColor clearColor]];
}

- (void)setContentViewColor:(UIColor *)color
{
    __contentView.backgroundColor = color;
}

- (void)executeUpdate:(NSIndexPath *)indexPath
{
    if (_blockData->_updateBlock) {
        _blockData->_updateBlock(indexPath);
    }
}

- (void)executeSelect:(NSIndexPath *)indexPath
{
    if (_blockData->_selectBlock) {
        _blockData->_selectBlock(indexPath);
    }
}

- (void)registerContentViewClass:(Class)contentViewClass
{
    _contentViewClass = contentViewClass;
}

- (void)setEdge:(UIEdgeInsets)edge
{
    if (!UIEdgeInsetsEqualToEdgeInsets(edge, _edge)) {
        _edge = edge;
        _contentSize = UIEdgeInsetsInsetRect(self.contentView.bounds, _edge).size;
        [self setNeedsLayout];
    }
}

- (void)updateContentSize
{
    _contentSize = UIEdgeInsetsInsetRect(self.contentView.bounds, _edge).size;
}
@end


@implementation CollectionCell
{
    CellBlockData *_blockData;
    
    id _modelData;
    id _layoutData;
    
    UIView *__contentView;
    Class _contentViewClass;
}

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _blockData = [CellBlockData new];
    __contentView = [[UIView alloc]initWithFrame:self.contentView.bounds];
    self.contentView.backgroundColor = self.backgroundColor = [UIColor clearColor];
    __contentView.backgroundColor  = [UIColor whiteColor];
    
    
    //self.selectedBackgroundView = [UIView new];
    return self;
}

#pragma mark - block
- (void)setInitBlock:(CellInitBlock)initBlock
{
    NSParameterAssert(initBlock);
    __contentView.frame = self.contentView.bounds;
    initBlock(__contentView);
    if (_blockData->_autoLayoutBlock) {
        _blockData->_autoLayoutBlock(__contentView.bounds);
        _blockData->_autoLayoutBlock = nil;
    }
    [self.contentView addSubview:__contentView];
}

- (void)setInitAsyncBlock:(CellInitBlock)initAsyncBlock
{
    NSParameterAssert(initAsyncBlock);
    
    __contentView.frame = self.contentView.bounds;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        initAsyncBlock(__contentView);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentView addSubview:__contentView];
            if (_blockData->_autoLayoutBlock) {
                _blockData->_autoLayoutBlock(__contentView.bounds);
                _blockData->_autoLayoutBlock = nil;
            }
            
            if (_blockData->_updateBlock) {
                NSIndexPath *idp = [_collectionView indexPathForCell:self];
                _blockData->_updateBlock(idp);
            }
            
            [self setNeedsLayout];
        });
    });
    
}


- (void)setUpdateBlock:(CellIndexPathBlock)updateBlock
{
    _blockData->_updateBlock = updateBlock;
}

- (CellIndexPathBlock)updateBlock
{
    return _blockData->_updateBlock;
}

- (void)setLayoutBlock:(CellFrameBlock)layoutBlock
{
    _blockData->_layoutBlock = layoutBlock;
}

- (void)setAutoLayoutBlock:(CellFrameBlock)autoLayoutBlock
{
    _blockData->_autoLayoutBlock = autoLayoutBlock;
}

- (void)setSelectBlock:(CellIndexPathBlock)selectBlock
{
    _blockData->_selectBlock = selectBlock;
}

- (CellIndexPathBlock)selectBlock
{
    return _blockData->_selectBlock;
}

#pragma mark - data
- (id)modelData
{
    return _modelData;
}

- (id)layoutData
{
    return _layoutData;
}


- (BOOL)containModelData:(id)modelData
{
    if (modelData != _modelData) {
        _modelData = modelData;
        return NO;
    }
    return YES;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = UIEdgeInsetsInsetRect(self.contentView.bounds, _edge);
    __contentView.frame = bounds;
    if (_blockData->_layoutBlock) {
        _blockData->_layoutBlock(bounds);
    }
}


- (void)executeUpdate:(NSIndexPath *)indexPath
{
    if (_blockData->_updateBlock) {
        _blockData->_updateBlock(indexPath);
    }
}

- (void)executeSelect:(NSIndexPath *)indexPath
{
    if (_blockData->_selectBlock) {
        _blockData->_selectBlock(indexPath);
    }
}

- (void)registerContentViewClass:(Class)contentViewClass
{
    _contentViewClass = contentViewClass;
}
@end

@implementation TableHeaderFooter

{
    CellBlockData *_blockData;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    _blockData = [CellBlockData new];
    //self.contentView.backgroundColor  = [UIColor clearColor];
    return self;
}

#pragma mark - block
- (void)setInitBlock:(CellInitBlock)initBlock
{
    NSParameterAssert(initBlock);
    initBlock(self.contentView);
    if (_blockData->_autoLayoutBlock) {
        _blockData->_autoLayoutBlock(self.bounds);
    }
}

- (void)setLayoutBlock:(CellFrameBlock)layoutBlock
{
    _blockData->_layoutBlock = layoutBlock;
}


- (void)setUpdateBlock:(CellIndexPathBlock)updateBlock
{
    _blockData->_updateBlock = updateBlock;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_blockData->_layoutBlock) {
        _blockData->_layoutBlock(self.bounds);
    }
}

- (void)executeUpdate:(NSIndexPath *)indexPath
{
    if (_blockData->_updateBlock) {
        _blockData->_updateBlock(indexPath);
    }
}

- (void)executeSelect:(NSIndexPath *)indexPath
{
    if (_blockData->_selectBlock) {
        _blockData->_selectBlock(indexPath);
    }
}
@end

@implementation CollectionHeaderFooter

{
    CellBlockData *_blockData;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _blockData = [CellBlockData new];
    return self;
}

#pragma mark - block
- (void)setInitBlock:(CellInitBlock)initBlock
{
    NSParameterAssert(initBlock);
    initBlock(self);
    if (_blockData->_autoLayoutBlock) {
        _blockData->_autoLayoutBlock(self.bounds);
        _blockData->_autoLayoutBlock = nil;
    }
}

- (void)setLayoutBlock:(CellFrameBlock)layoutBlock
{
    _blockData->_layoutBlock = layoutBlock;
}

- (void)setUpdateBlock:(CellIndexPathBlock)updateBlock
{
    _blockData->_updateBlock = updateBlock;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_blockData->_layoutBlock) {
        _blockData->_layoutBlock(self.bounds);
    }
}



@end

@implementation CellConfigureDelegateObject
{
    CellConfigureBlock _block;
}
- (instancetype)initWithBlock:(CellConfigureBlock)block
{
    _block = block;
    return [self init];
}

- (void)onConfigureCell:(__kindof UIView * _Nonnull __weak)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    _block(cell,reuseIdentifier);
}

@end