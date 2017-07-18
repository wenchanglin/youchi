//
//  YCTableViewHeaderFooterView.m
//  YouChi
//
//  Created by sam on 16/1/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewHeaderFooterView.h"

@implementation YCTableViewHeaderFooterView
- (void)setHeaderDelegate:(UIViewController<YCTableVIewHeaderFooterViewDelegate> *)headerDelegate
{
    if (headerDelegate != _headerDelegate) {
        _headerDelegate = headerDelegate;
        if ([_headerDelegate respondsToSelector:@selector(onConfigureHeader:reuseIdentifier:)]) {
            [_headerDelegate onConfigureHeader:self reuseIdentifier:self.reuseIdentifier];
        }
    }
}

- (void)setFooterDelegate:(UIViewController<YCTableVIewHeaderFooterViewDelegate> *)footerDelegate
{
    if (footerDelegate != _footerDelegate) {
        _footerDelegate = footerDelegate;
        if ([_headerDelegate respondsToSelector:@selector(onConfigureHeader:reuseIdentifier:)]) {
            [_headerDelegate onConfigureHeader:self reuseIdentifier:self.reuseIdentifier];
        }
    }
}

- (void)setInitBlock:(YCHeaderFooterInitBlock)initBlock
{
    initBlock(self,self.contentView,self.reuseIdentifier);
}

- (void)setLayoutBlock:(YCHeaderFooterLayoutBlock)layoutBlock
{
    if (layoutBlock != _layoutBlock) {
        _layoutBlock = layoutBlock;
        //[self setNeedsLayout];
    }
}

- (void)setUpdateBlock:(YCHeaderFooterUpdateBlock)updateBlock
{
    if (updateBlock != _updateBlock) {
        _updateBlock = updateBlock;
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
    [super layoutSubviews];
    if (_layoutBlock) {
        _layoutBlock(self,self.contentView,self.bounds);
    }
}

@end
