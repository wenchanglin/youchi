//
//  YCimageSelVC.m
//  YouChi
//
//  Created by 李李善 on 15/8/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCImageSelectControl.h"
#import "UIButton+MJ.h"
#import <UIImageView+WebCache.h>
#import "YCMarcros.h"
#import "YCView.h"
#import "YCModel.h"
#import <Masonry/Masonry.h>
@interface YCImageSelectControl ()
{
    UIColor *_selectedColor;
    UIView *_lastSelectedView;
}
@end
@implementation YCImageSelectControl
- (void)dealloc{
    //ok
}
- (void)prepareForInterfaceBuilder
{
    //[self _init];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

/*
 _images           用来存储选项
 _selectedIndex    默认选择哪一下
 _selectedColor    默认选中的颜色
 opaque            self是否透明
 _showSelected     是否显示选项
 */
- (void)_init
{
    _selectedIndex = 0;
//    _selectedColor = [UIColor colorWithHex:0xff9900];
    _selectedColor = color_title;
    
    self.opaque = YES;
    _showSelected = NO;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


/*
 borderWidth  边厚度
 */

- (void)reset
{
    _lastSelectedView.borderWidth = 0;
    [self.elements.firstObject setBorderWidth:2];
    _lastSelectedView = self.elements.firstObject;
    _selectedIndex = 0;
}

/*
 set是否显示选择
 */

- (void)setShowSelected:(BOOL)showSelected
{
    if (_showSelected != showSelected) {
        _showSelected = showSelected;
        if (showSelected) {
            [self reset];
        } else {
            [self.elements makeObjectsPerformSelector:@selector(setBorderWidth:) withObject:@(0)];
        }
    }
}

/*
 set选择哪一项
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        if (!_showSelected) {
            return;
        }
        
        _lastSelectedView.borderWidth = 0;
        UIView *v = self.elements[MIN(selectedIndex, _imageCount-1)];
        v.borderWidth = 2;
        _lastSelectedView = v;
    }
}

/*
 
 */

- (void)setImageCount:(NSInteger)imageCount
{
    if (_imageCount != imageCount) {
        _imageCount = imageCount;
        [self.elements makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSMutableArray *elements = [NSMutableArray new];
        
        for (int n = 0; n<_imageCount; n++) {
            UIView *iv = [UIView new];
            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.clipsToBounds = YES;
            iv.userInteractionEnabled = YES;
            iv.borderColor = _selectedColor;
            
            [self addSubview:iv];
            
            [elements addObject:iv];
        }
        self.elements = elements.copy;
        
        [self setNeedsLayout];
    }
}

- (void)setShowDefault:(BOOL)showDefault
{
    if (showDefault != _showDefault) {
        _showDefault = showDefault;
        UIView *v = [self viewByTag:100];
        [v removeFromSuperview];
        
        if (showDefault) {
            v = [UIView new];
            v.tag = 100;
            [self addSubview:v];
            [self sendSubviewToBack:v];
            v.userInteractionEnabled = NO;
            v.opaque = YES;
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
            
            UIImage *img = [UIImage imageNamed:@"还没有相关的秘籍"];
            UIImageView *iv = [[UIImageView alloc]initWithImage:img];
            [v addSubview:iv];
            
            UILabel *l = [UILabel new];
            l.text = @"还没有相关的秘籍";
            l.font = [UIFont systemFontOfSize:12];
            l.textColor = [UIColor colorWithHex:0xa7a7ab];
            [v addSubview:l];
            
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.equalTo(l);
                make.right.equalTo(l.mas_left).offset(-8);
            }];
            
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.top.bottom.equalTo(v);
                
            }];
        }
        
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    NSUInteger idx = [self.elements indexOfObject:touch.view];
    
    if (idx != NSNotFound) {
        self.selectedIndex = idx;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *v = [super hitTest:point withEvent:event];
    if (v.hidden || (v == self)) {
        return nil;
    }
    return v;
}

- (void)updateImagesWithPageModels:(NSArray<YCBaseImageModel *> *)models
{
    [self.elements enumerateObjectsUsingBlock:^(UIImageView *iv, NSUInteger idx, BOOL *stop) {
        if (models.count>idx) {
            iv.hidden = NO;
            YCBaseImageModel  *pm = models[idx];
            if (isOldOSS(pm.imagePath)) {
                [iv ycNotShop_setImageWithURL:pm.imagePath placeholder:PLACE_HOLDER];
            } else {
                [iv yc_setImageWithURL:IMAGE_HOST_1_2_get(pm.imagePath) placeholder:PLACE_HOLDER];
            }
            
        } else {
            iv.hidden = YES;
        }
        
    }];
}

- (void)updateShopImagesWithPageModels:(NSArray<YCBaseImageModel *> *)models
{
    [self.elements enumerateObjectsUsingBlock:^(UIImageView *iv, NSUInteger idx, BOOL *stop) {
        if (models.count>idx) {
            iv.hidden = NO;
            YCBaseImageModel  *pm = models[idx];
            if (!isOldOSS(pm.imagePath)) {
                [iv ycShop_setImageWithURL:pm.imagePath placeholder:PLACE_HOLDER];
            } else {
                [iv yc_setImageWithURL:IMAGE_HOST_1_2(pm.imagePath) placeholder:PLACE_HOLDER];
            }
            
        } else {
            iv.hidden = YES;
            //[iv.layer cancelCurrentImageRequest];
        }
        
    }];
}
@end
