//
//  OFView.h
//  OrderingFood
//
//  Created by Mallgo on 15-3-23.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <EDColor/EDColor.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "YCCatolog.h"
#import "YCMarcros.h"
#import <POP/POP.h>
#import <YYKit/YYKit.h>
#import "YCDefines.h"

@class YCView;
typedef void(^YCViewInitBlock)(__weak YCView *view);
typedef void(^YCViewLayoutBlock)(__weak YCView *view,CGRect frame);
@interface YCView : UIView
@property (nonatomic,strong) YCViewLayoutBlock layoutBlock;
- (void)setInitBlock:(YCViewInitBlock)initBlock;
- (void)setLayoutBlock:(YCViewLayoutBlock)layoutBlock;
@end

IB_DESIGNABLE
@interface UIView (OF)
@property (nonatomic,assign) IBInspectable  CGFloat cornerRadius;
@property (nonatomic,assign) IBInspectable  CGFloat borderWidth;
@property (nonatomic,assign) IBInspectable  CGSize shadowOffset;
@property (nonatomic,assign) IBInspectable  CGFloat shadowOpacity;
@property (nonatomic,strong) IBInspectable  UIColor *shadowColor;
@property (nonatomic,strong) IBInspectable  UIColor *borderColor;
@property (nonatomic,assign) IBInspectable  BOOL masksToBounds;
@property (nonatomic,strong) IBInspectable  NSString *bgColor;
@property (nonatomic,strong) IBInspectable  NSString *bgImage;

@property (nonatomic,assign) IBInspectable BOOL hasTopLine;
@property (nonatomic,assign) IBInspectable BOOL hasBottomLine;
@property (nonatomic,assign) IBInspectable BOOL hasLeftLine;
@property (nonatomic,assign) IBInspectable BOOL hasRightLine;


@property (nonatomic,strong) UIImage *backgroundImage;
/**
 *  根据Tag获取控件
 *
 *  @param tag 值
 */
- (id)viewByTag:(NSInteger )tag;
/**
 *  根据名字加载xib
 *
 *  @param name xib的名字
 */
+ (id)viewByName:(NSString *)name;


/************************************************/

/**
 *  创建白色View，并返回
 */
+ (instancetype)viewByWhiteBackgroundColor;
/**
 *  根据类名加载xib
 *
 *  @param aClass 类名
 */
+ (instancetype)viewByClass:(Class)aClass;
/**
 *  根据self本身名字加载xib
 */
+ (instancetype)viewByClass;


/************************************************/

/**
 *  查找本身的父类(UITableViewCell）
 */
- (__kindof UITableViewCell *)findTableViewCell;
/**
 *  查找本身的父类(UICollectionViewCell）
 */
- (__kindof UICollectionViewCell *)findCollectionViewCell;

/************************************************/
/**
 *  创建并将本身到(想添加的父类)
 *
 *  @param superView 父类
 */
+ (instancetype)newInSuperView:(UIView *)superView;
/**
 *  将本身到(想添加的父类)
 *
 *  @param superView 父类
 */
- (instancetype)addInSuperView:(UIView *)superView;

/**
 *  设置背景颜色
 *
 *  @param color 背景颜色
 */
-(void)backColor:(UIColor *)color;
@end

IB_DESIGNABLE
@interface UILabel (YC)
@property (nonatomic,strong) IBInspectable  NSString *textHexColor;
@end

@interface UIImage (YC)
+ (UIImage *)cacheImagewith:(id )url;
@end

IB_DESIGNABLE
@interface UIButton (YC)
@property (nonatomic,assign) IBInspectable NSString *normalColor;
@property (nonatomic,assign) IBInspectable int numbersOfLine;
/**
 *  设置多样式标题(默认状态)
 *
 *  @param setAttributedTitle 标题
 */
-(void)setNormalsetAttTitle:(NSAttributedString *)title;
/**
 *  设置标题(默认状态)
 *
 *  @param title 标题
 */
-(void)setNormalTitle:(NSString *)title;
/**
 *  设置标题(选中状态)
 *
 *  @param title 标题
 */
-(void)setSelectTitle:(NSString *)title;
/**
 *  设置标题大小
 *
 *  @param font 大小
 */
-(void)setTitleFont:(float)font;
/**
 *  设置标题颜色(默认状态)
 *
 *  @param titleColor 颜色
 */
-(void)setNormalTitleColor:(UIColor *)titleColor;
/**
 *  设置标题颜色(选中状态)
 *
 *  @param titleColor 颜色
 */
-(void)setSelectTitleColor:(UIColor *)titleColor;
/**
 *  设置图标(默认状态)
 *
 *  @param image 图片
 */
-(void)setNormalImage:(UIImage *)image;
/**
 *  设置选择图标(选择状态)
 *
 *  @param selectimage 选择图片
 */
-(void)setSelectImage:(UIImage *)selectimage;
/**
 *  设置背景图标(默认状态)
 *
 *  @param image 背景图片
 */
-(void)setNormalBackImage:(UIImage *)backImage;
/**
 *  设置选择背景图标(选择状态)
 *
 *  @param selectimage 选择背景图片
 */
-(void)setSelectBackImage:(UIImage *)selectBackImage;
/**
 *  添加点击事件(默认点击状态)
 *
 *  @param target 目标 action 方法名
 */
-(void)addTarget:(id)target action:(SEL)action;
- (void)setNormalBgColor:(UIColor *)normalColor selectedBgColor:(UIColor *)selectedColor highLightedBgColor:(UIColor *)highLightedColor size:(CGSize)size;
- (void)setNormalBgColor:(UIColor *)normalColor selectedBgColor:(UIColor *)selectedColor highLightedBgColor:(UIColor *)highLightedColor;
- (void)setNormalBgColor:(UIColor *)normalColor selectedBgColor:(UIColor *)selectedColor size:(CGSize )size;
- (void)setNormalBgColor:(UIColor *)normalColor selectedBgColor:(UIColor *)selectedColor;
- (void)setNormalBg:(NSString *)normalHex selectedBg:(NSString *)selectedHex size:(CGSize )size;
- (void)setNormalBg:(NSString *)normalHex selectedBg:(NSString *)selectedHex;


@end

@interface UIControl (YC)
- (void)executeActivitySignal:(RACSignal *)signal next:(YCNextBlock)nextBlock error:(YCErrorBlock)errorBlock completed:(YCCompleteBlock)completedBlock executing:(YCExecutingBlock)executingBlock;
@end

@interface UIBarItem (YC)
- (void)executeSignal:(RACSignal *)signal next:(YCNextBlock)nextBlock error:(YCErrorBlock)errorBlock completed:(YCCompleteBlock)completedBlock executing:(YCExecutingBlock)executingBlock;
@end

IB_DESIGNABLE
@interface UITableViewCell (YC)
@property (nonatomic,assign) IBInspectable BOOL hasTopLine;
@property (nonatomic,assign) IBInspectable BOOL hasBottomLine;

@end

@interface UIView (YCImage)
- (void)yc_setImageWithURL:(id)imageURL placeholder:(UIImage *)placeholder;
- (void)yc_shopFillImageWithURL:(id)imageURL placeholder:(UIImage *)placeholder width:(CGFloat )width height:(CGFloat )height;
- (void)ycShop_setImageWithURL:(id)imageURL placeholder:(UIImage *)placeholder;
- (void)ycNotShop_setImageWithURL:(id )imageURL placeholder:(UIImage *)placeholder;
- (void)ycShop_setCompleteImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;


- (void)yc_initView;
@end

