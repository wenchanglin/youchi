//
//  YCTableVIewCell.m
//  YouChi
//
//  Created by sam on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableVIewCell.h"


@implementation YCTableVIewCell
{
    UIView *yc_contentView;
    BOOL isIOS_8;
}
- (void)dealloc
{
    //NSLog(@"YCTableVIewCell");
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupContentView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setupContentView];
    }
    return self;
}

- (void)_setupContentView
{
    isIOS_8 = [UIDevice currentDevice].systemVersion.floatValue>7 && [UIDevice currentDevice].systemVersion.floatValue<9;
    if (isIOS_8) {
        yc_contentView = [UIView new];
        [self.contentView addSubview:yc_contentView];
        [self.contentView sendSubviewToBack:yc_contentView];
        self.contentView.backgroundColor = [UIColor clearColor];
        yc_contentView.frame = self.bounds;
    } else {
        yc_contentView = self.contentView;
    }
    
    self.selectedBackgroundView = [UIView new];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (_reuseBlock) {
        _reuseBlock(self,self.contentView,self.reuseIdentifier);
    }
}

- (void)setDelegate:(UIViewController<YCTableVIewCellDelegate> *)delegate
{
    if (delegate != _delegate ) {
        _delegate = delegate;
        if ([delegate respondsToSelector:@selector(onConfigureCell:reuseIdentifier:)]) {
            [delegate onConfigureCell:self reuseIdentifier:self.reuseIdentifier];
        }
    }
}

- (void)setInitBlock:(YCCellInitBlock)initBlock
{
    NSParameterAssert(initBlock);
    initBlock(self,yc_contentView,self.reuseIdentifier);
    if (self.autoLayoutBlock) {
        self.autoLayoutBlock(self,yc_contentView,yc_contentView.bounds);
        self.autoLayoutBlock = nil;
    }
}

- (void)setInitAsyncBlock:(YCCellInitBlock)initBlock
{
    NSParameterAssert(initBlock);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_async(queue, ^{
        UIView *view = [UIView new];
        initBlock(self,view,self.reuseIdentifier);
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *v in view.subviews) {
                [v removeFromSuperview];
                [yc_contentView addSubview:v];
            }
            
            if (self.autoLayoutBlock) {
                self.autoLayoutBlock(self,yc_contentView,yc_contentView.bounds);
                self.autoLayoutBlock = nil;
            }
            
            
            
            UITableView *tv = [(UITableViewController *)self.delegate tableView];
            NSIndexPath *ip = [tv indexPathForCell:self];
            if (self.updateBlock && ip) {
                self.updateBlock(self,yc_contentView,ip);
            }
            
            [self setNeedsLayout];
        });
    });
}

- (void)setLayoutBlock:(YCCellLayoutBlock)layoutBlock
{
    if (layoutBlock != _layoutBlock) {
        _layoutBlock = layoutBlock;
    }
}

- (void)setAutoLayoutBlock:(YCCellLayoutBlock)autoLayoutBlock
{
    if (autoLayoutBlock != _autoLayoutBlock) {
        _autoLayoutBlock = autoLayoutBlock;
        [self setNeedsLayout];
    }
}

- (void)setUpdateBlock:(YCCellUpdateBlock)updateBlock
{
    if (updateBlock != _updateBlock) {
        _updateBlock = updateBlock;
    }
}

- (void)setSelectBlock:(YCCellSelectBlock)selectBlock
{
    if (selectBlock != _selectBlock) {
        _selectBlock = selectBlock;
    }
}

- (BOOL)checkIsHasSetData:(id)data
{
    if (data != _data) {
        _data = data;
        return NO;
    }
    return YES;
}

- (void)layoutSubviews
{
    dispatch_async_on_main_queue(^{
        [super layoutSubviews];
    });
    if (isIOS_8) {
        yc_contentView.frame = self.bounds;
        
    }
    if (_layoutBlock) {
        self.selectedBackgroundView.frame = yc_contentView.frame;
        _layoutBlock(self,yc_contentView,self.bounds);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateAtIndexPath:(NSIndexPath *)indexPath
{
    if (_updateBlock) {
        _updateBlock(self,yc_contentView,indexPath);
    }
}

- (void)setBackgroundClearColor
{
    [self setBackgroundColor:[UIColor clearColor]];
    yc_contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setContentViewClearColor
{
    yc_contentView.backgroundColor = [UIColor clearColor];
}
@end
