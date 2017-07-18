//
//  OFView.m
//  OrderingFood
//
//  Created by Mallgo on 15-3-23.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//

#import "YCView.h"
#import "MobClick.h"
#import <Masonry/Masonry.h>
#import <RDVTabBarController/RDVTabBarController.h>
@implementation YCView
- (void)setInitBlock:(YCViewInitBlock)initBlock
{
    NSParameterAssert(initBlock);
    initBlock(self);
}
- (void)setLayoutBlock:(YCViewLayoutBlock)layoutBlock
{
    if (layoutBlock != _layoutBlock) {
        _layoutBlock = layoutBlock;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_layoutBlock) {
        _layoutBlock(self,self.bounds);
    }
    
}
@end

@implementation UIView (OF)

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGSize)shadowOffset
{
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    self.layer.shadowOffset = shadowOffset;
}

- (CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat )shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}

- (UIColor *)shadowColor
{
    return (__bridge UIColor *)self.layer.shadowColor;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)borderColor
{
    return (__bridge UIColor *)self.layer.borderColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (BOOL)masksToBounds
{
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds:(BOOL)masksToBounds
{
    self.layer.masksToBounds = YES;
    
    
}

- (NSString *)bgColor
{
    return nil;
}

- (void)setBgColor:(NSString *)bgColor
{
    self.backgroundColor = [UIColor colorWithHexString:bgColor];
}

- (NSString *)bgImage
{
    return nil;
}

- (void)setBgImage:(NSString *)bgImage
{
    self.layer.contents = (__bridge id)[UIImage imageNamed:bgImage].CGImage;
    self.layer.contentsGravity = @"resizeAspectFill";
}

- (void)setHasTopLine:(BOOL)hasTopLine
{
    if (hasTopLine) {
        UIView *l = [UIView new];
        l.backgroundColor = [UIColor colorWithHex:0xb6b6b6];
        l.tag = 1001;
        [self addSubview:l];
        
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(l.superview);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
    } else {
        [[self viewWithTag:1001] removeFromSuperview];
    }
}

- (BOOL)hasTopLine
{
    return [self viewWithTag:1001] != nil;
}

- (void)setHasBottomLine:(BOOL)hasBottomLine
{
    if (hasBottomLine) {
        UIView *l = [UIView new];
        l.backgroundColor = [UIColor colorWithHex:0xb6b6b6];
        l.tag = 1002;
        [self addSubview:l];

        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(l.superview);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
    } else {
        [[self viewWithTag:1002] removeFromSuperview];
    }
    
}

- (BOOL)hasBottomLine
{
    return [self viewWithTag:1002] != nil;
}

- (void)setHasLeftLine:(BOOL)hasLeftLine{

    UIView *l = [UIView new];
    l.backgroundColor = [UIColor colorWithHex:0xb6b6b6];
    l.tag = 1003;
    [self addSubview:l];
    
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(l.superview);
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    [self bringSubviewToFront:l];
}
- (BOOL)hasLeftLine{
    return [self viewWithTag:1003] != nil;
}
- (void)setHasRightLine:(BOOL)hasRightLine{

    UIView *l = [UIView new];
    l.backgroundColor = [UIColor colorWithHex:0xb6b6b6];
    l.tag = 1004;
    [self addSubview:l];
    
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(l.superview);
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    [self bringSubviewToFront:l];
}
- (BOOL)hasRightLine{

    return [self viewWithTag:1004] != nil;
    
}


- (UIImage *)backgroundImage
{
    return nil;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.layer.contents=(__bridge id)backgroundImage.CGImage;
    self.layer.contentsGravity = @"resizeAspectFill";
}

/**
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)viewByTag:(NSInteger)tag
{
    return (id)[self viewWithTag:tag];
}

+ (id)viewByName:(NSString *)name
{
    return [[UINib nibWithNibName:name bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
}

+ (instancetype)viewByWhiteBackgroundColor
{
    UIView *v = [self new];
    v.backgroundColor = [UIColor whiteColor];
    return v;
}

+ (instancetype)viewByClass:(Class)aClass
{
    NSString *name = NSStringFromClass(aClass);
    return [self viewByName:name];
}

+ (instancetype)viewByClass
{
    NSString *name = NSStringFromClass(self);
    return [self viewByName:name];
}

- (UITableViewCell *)findTableViewCell
{
    UITableViewCell *c = (id)self.superview;
    while (![c isKindOfClass:[UITableViewCell class]]) {
        c = (id)c.superview;
        
    }
    return c;

}

- (UICollectionViewCell *)findCollectionViewCell
{
    UICollectionViewCell *c = (id)self.superview;
    
    while (![c isKindOfClass:[UICollectionViewCell class]]) {
        c = (id)c.superview;
        
    }
    return c;
}

+ (instancetype)newInSuperView:(UIView *)superView
{
    id v = [self new];
    [superView addSubview:v];
    return v;
}

- (instancetype)addInSuperView:(UIView *)superView
{
    [superView addSubview:self];
    return self;
}

-(void)backColor:(UIColor *)color{
    if (color) {
        self.backgroundColor = color;
    }
}
@end


@implementation UILabel (YC)
- (NSString *)textHexColor
{
    return nil;
}

- (void)setTextHexColor:(NSString *)textHexColor
{
    self.textColor = [UIColor colorWithHexString:textHexColor];
}

@end

@implementation UIImage (YC)

+ (UIImage *)cacheImagewith:(id )url
{
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:(id)url];
    }
    NSString *key = [[YYWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *img = [[YYWebImageManager sharedManager].cache getImageForKey:key];
    return img ?:APP_ICON;
}
@end


@implementation UIButton (YC)
@dynamic normalColor;
-(void)setNormalsetAttTitle:(NSAttributedString *)title{
    if (title) {
         [self setAttributedTitle:title forState:UIControlStateNormal];
    }
}
-(void)setNormalTitle:(NSString *)title{
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
}
-(void)setSelectTitle:(NSString *)title{
    if (title) {
        [self setTitle:title forState:UIControlStateSelected];
    }
}
-(void)setNormalTitleColor:(UIColor *)titleColor{
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
}
-(void)setSelectTitleColor:(UIColor *)titleColor{
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateSelected];
    }
    
}

-(void)setTitleFont:(float)font{
    if (font) {
        self.titleLabel.font = KFont(font);
    }
}

-(void)setNormalImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
}
-(void)setSelectImage:(UIImage *)selectimage{
    [self setImage:selectimage forState:UIControlStateSelected];
}

-(void)setNormalBackImage:(UIImage *)backImage{
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
}
-(void)setSelectBackImage:(UIImage *)selectBackImage{
    [self setBackgroundImage:selectBackImage forState:UIControlStateSelected];
}
-(void)addTarget:(id)target action:(SEL)action{
    if (target!=nil &&action != nil) {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setNormalColor:(NSString *)normalColor
{
    // 使用颜色创建UIImage
    CGSize imageSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    
    UIColor *color = [UIColor colorWithHexString:normalColor];
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    
    
    [self setBackgroundImage:pressedColorImg forState:UIControlStateNormal];
    
    color = [color colorWithAlphaComponent:0.5];
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    
    self.layer.cornerRadius = 2.0f;
    self.layer.masksToBounds = YES;
    self.opaque = NO;
}

- (int)numbersOfLine
{
    return (int)self.titleLabel.numberOfLines;
}

- (void)setNumbersOfLine:(int)numbersOfLine
{
    self.titleLabel.numberOfLines = numbersOfLine;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setNormalBgColor:(UIColor *)normalColor selectedBgColor:(UIColor *)selectedColor highLightedBgColor:(UIColor *)highLightedColor size:(CGSize)size
{
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);

    UIColor *color ;
    UIImage *img;
    if (normalColor) {
        color = normalColor;
        [color set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        img = UIGraphicsGetImageFromCurrentImageContext();
        [self setBackgroundImage:img forState:UIControlStateNormal];
    }

    if (selectedColor) {
        color = selectedColor;
        [color set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        img = UIGraphicsGetImageFromCurrentImageContext();
        [self setBackgroundImage:img forState:UIControlStateSelected];
    }
    
    if (highLightedColor) {
        color = highLightedColor;
        [color set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        img = UIGraphicsGetImageFromCurrentImageContext();
        [self setBackgroundImage:img forState:UIControlStateHighlighted];
    }

    UIGraphicsEndImageContext();



    self.layer.masksToBounds = YES;
    self.opaque = NO;
}

- (void)setNormalBgColor:(UIColor *)normalColor selectedBgColor:(UIColor *)selectedColor highLightedBgColor:(UIColor *)highLightedColor
{
    [self setNormalBgColor:normalColor selectedBgColor:selectedColor highLightedBgColor:highLightedColor size:self.bounds.size];
}

- (void)setNormalBgColor:(UIColor *)normalColor selectedBgColor:(UIColor *)selectedColor size:(CGSize)size
{
    [self setNormalBgColor:normalColor selectedBgColor:selectedColor highLightedBgColor:nil size:size];
}

- (void)setNormalBgColor:(UIColor *)normalColor selectedBgColor:(UIColor *)selectedColor
{
    [self setNormalBgColor:normalColor selectedBgColor:selectedColor size:self.bounds.size];
}

- (void)setNormalBg:(NSString *)normalHex selectedBg:(NSString *)selectedHex size:(CGSize)size
{
    [self setNormalBgColor:[UIColor colorWithHexString:normalHex] selectedBgColor:[UIColor colorWithHexString:selectedHex] size:size];
}


- (void)setNormalBg:(NSString *)normalHex selectedBg:(NSString *)selectedHex
{
    [self setNormalBg:normalHex selectedBg:selectedHex size:self.bounds.size];
}

@end


@implementation UIControl (OF)

- (void)executeActivitySignal:(RACSignal *)signal next:(YCNextBlock)nextBlock error:(YCErrorBlock)errorBlock completed:(YCCompleteBlock)completedBlock executing:(YCExecutingBlock)executingBlock
{
    //NSAssert(signal, @"signal不能为nil");
    if (!self.userInteractionEnabled) {
        return;
    }
    BOOL isSelected = self.isSelected;
    self.selected = !isSelected;
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView  alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:aiv];
    [self bringSubviewToFront:aiv];
    [aiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [aiv startAnimating];
    
    
    self.userInteractionEnabled = NO;
    if (executingBlock) {
        executingBlock(YES);
    }
    
    WSELF;
    [signal.deliverOnMainThread subscribeNext:^(id x) {
        SSELF;
        self.userInteractionEnabled = YES;
        [aiv stopAnimating];
        [aiv removeFromSuperview];
        if (nextBlock) {
            nextBlock(x);
        }
        
    } error:^(NSError *error) {
        SSELF;
        self.userInteractionEnabled = YES;
        self.selected = isSelected;
        [aiv stopAnimating];
        [aiv removeFromSuperview];
        if (errorBlock) {
            errorBlock(error);
        }
        
        if (executingBlock) {
            executingBlock(NO);
        }

        if (completedBlock) {
            completedBlock();
        }
    } completed:^{
        SSELF;
        self.userInteractionEnabled = YES;
        [aiv stopAnimating];
        [aiv removeFromSuperview];
        if (executingBlock) {
            executingBlock(NO);
        }
        
        if (completedBlock) {
            completedBlock();
        }
    }];

}

@end


@implementation UIBarItem (OF)



- (void)executeSignal:(RACSignal *)signal next:(YCNextBlock)nextBlock error:(YCErrorBlock)errorBlock completed:(YCCompleteBlock)completedBlock executing:(YCExecutingBlock)executingBlock
{
    NSAssert(signal, @"signal不能为nil");
    if (!self.enabled) {
        return;
    }
    WSELF;
    self.enabled = NO;
    if (executingBlock) {
        executingBlock(YES);
    }
    [[signal deliverOnMainThread] subscribeNext:^(id x) {
        SSELF;
        self.enabled = YES;
        if (nextBlock) {
            nextBlock(x);
        }
    } error:^(NSError *error) {
        SSELF;
        self.enabled = YES;
        if (errorBlock) {
            errorBlock(error);
        }
        if (executingBlock) {
            executingBlock(NO);
        }
        if (completedBlock) {
            completedBlock();
        }
    } completed:^{
        SSELF;
        self.enabled = YES;

        if (executingBlock) {
            executingBlock(NO);
        }

        if (completedBlock) {
            completedBlock();
        }
    }];
}
@end


@implementation UITableViewCell (YC)
- (void)setHasTopLine:(BOOL)hasTopLine
{
//    UIView *l = [UIView new];
//    l.backgroundColor = [UIColor colorWithHex:0xb6b6b6];
//    l.tag = 2001;
//    [self.contentView addSubview:l];
//    
//    [l mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(l.superview);
//        make.height.mas_equalTo(0.3);
//    }];
//    [self.contentView bringSubviewToFront:l];
}

- (BOOL)hasTopLine
{
    return [self.contentView viewWithTag:2001] != nil;
}

- (void)setHasBottomLine:(BOOL)hasBottomLine
{
//    UIView *l = [UIView new];
//    l.backgroundColor = [UIColor colorWithHex:0xb6b6b6];
//    l.tag = 2002;
//    [self.contentView addSubview:l];
//    
//    [l mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(l.superview);
//        make.height.mas_equalTo(0.3);
//    }];
//    [self.contentView bringSubviewToFront:l];
    
}

- (BOOL)hasBottomLine
{
    return [self.contentView viewWithTag:1002] != nil;
}

@end


@implementation UIView (YCImage)

- (void)yc_setImageWithURL:(id )imageURL placeholder:(UIImage *)placeholder
{
    if ([self isMemberOfClass:[UIImageView class]]) {
        self.clipsToBounds = YES;
        [(UIImageView *)self setImageWithURL:imageURL placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }
    
    else {
        self.layer.masksToBounds = YES;
        self.layer.contentMode = UIViewContentModeScaleAspectFill;
        [self.layer setImageWithURL:imageURL placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }
    
}

- (void)yc_shopFillImageWithURL:(id)imageURL placeholder:(UIImage *)placeholder width:(CGFloat)width height:(CGFloat)height
{
//    CGFloat ww = kScreenWidth;
//    if (width>ww) {
//        height = height/width*ww;
//        width = ww;
//    }
    imageURL = IMAGE_HOST_(imageURL, height, width);
    self.layer.masksToBounds = YES;
    self.layer.contentMode = UIViewContentModeCenter;
    WSELF;
    [self.layer setImageWithURL:imageURL placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        SSELF;
        self.layer.contentMode = UIViewContentModeScaleAspectFill;
    }];
}

- (void)ycShop_setImageWithURL:(id )imageURL placeholder:(UIImage *)placeholder
{
    imageURL = IMAGE_HOST_SHOP(imageURL);
    
    if ([self isMemberOfClass:[UIImageView class]]) {
        self.clipsToBounds = YES;
        [(UIImageView *)self setImageWithURL:imageURL placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }
    else {
        self.layer.masksToBounds = YES;
        self.layer.contentMode = UIViewContentModeScaleAspectFill;
        [self.layer setImageWithURL:imageURL placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }
    
}

- (void)ycNotShop_setImageWithURL:(id)imageURL placeholder:(UIImage *)placeholder
{

    imageURL = IMAGE_HOST_NOT_SHOP_(imageURL);
    if ([self isMemberOfClass:[UIImageView class]]) {
        self.clipsToBounds = YES;
        [(UIImageView *)self setImageWithURL:imageURL placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }
    
    else {
        self.layer.masksToBounds = YES;
        self.layer.contentMode = UIViewContentModeScaleAspectFill;
        [self.layer setImageWithURL:imageURL placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }
    
}

- (void)ycShop_setCompleteImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder{
    NSURL *url = [self yc_setimageWithURLStr:imageURL];
    [self ycShop_setImageWithURL:url placeholder:placeholder];
}

-(NSURL *)yc_setimageWithURLStr:(NSURL *)urlStr{
    if (!urlStr) {
        return nil;
    }
    NSString *url = nil;
    if ([url hasPrefix:@"http"]) {
        url = (id)urlStr;
    } else {
        url= [[NSString alloc]initWithFormat:@"%@%@",hostImage,urlStr];
    }
    //NSLog(@">> %@\n",img);
    return [NSURL URLWithString:url];

}


- (void)yc_initView
{
    ;
}
@end



