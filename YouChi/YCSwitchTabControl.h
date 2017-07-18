//
//  YCSwitchTabControl.h
//  YouChi
//
//  Created by 李李善 on 15/8/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCMarcros.h"
@interface YCSwitchTabControl : UIControl
@property(nonatomic,readonly) NSUInteger numberOfSegments;
@property(nonatomic,assign) NSInteger selectedSegmentIndex;
@property(nonatomic,assign) NSInteger loginsSegmentIndex;
@property(nonatomic,assign) BOOL isSegmentLineHidden;

@property(nonatomic,strong) UIFont *segmentFont UI_APPEARANCE_SELECTOR;

@property(nonatomic,strong) UIColor *selectedColor UI_APPEARANCE_SELECTOR;

@property(nonatomic,strong) UIColor *selectedTitleColor UI_APPEARANCE_SELECTOR;

@property(nonatomic,strong) UIColor *normalColor UI_APPEARANCE_SELECTOR;

@property(nonatomic,strong) UIImage *selectedImage;
@property(nonatomic,strong,readonly) UIView *segmentLine;

@property(nonatomic,assign) CGFloat segmentLineHeight UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *segmentLineColor UI_APPEARANCE_SELECTOR;

- (void)insertSegmentWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage;
- (void)insertSegmentWithTitle:(NSString *)title image:(NSString *)image ;
- (void)insertselectedImage:(NSArray *)images;

- (void)buttonCornerRadius:(CGFloat)cornerRadius;

- (void)setNormalBGColor:(UIColor*)normalColor selectedBGColor:(UIColor *)selectedColor;

- (void)setAllButtonSelected:(BOOL)selected;
- (void)setButtonSelected:(BOOL)selected at:(NSInteger )index;
- (void)onCreachSpecialWithSelColor:(UIColor *)selColor  normalColor:(UIColor *)normalColor font:(CGFloat)font;
- (void)segmentLineScrollToIndex:(NSInteger )index animate:(BOOL)animate;
@end

