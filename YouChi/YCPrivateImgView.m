//
//  YCPrivateImgView.m
//  YouChi
//
//  Created by sam on 15/6/29.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPrivateImgView.h"
#import <Masonry/Masonry.h>
#import "YCView.h"


#define BorderWidth 3
#define DefualtImgW 150
#define Margin 10

@interface YCPrivateImgView ()
@property(strong,nonatomic) NSMutableArray *statesImages;
@property(weak,nonatomic) UIImageView *defaultImage;
@end
@implementation YCPrivateImgView
- (void)dealloc{
    //ok
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self addDefualtImg];
        self.clipsToBounds = NO;
    };
    return self;
}

// 初始化默认图片
- (void)addDefualtImg{
    
    CGRect bound = self.bounds;
    CGFloat cy = CGRectGetMidY(bound);
    CGFloat w = CGRectGetWidth(bound);
    CGFloat h = CGRectGetHeight(bound);
    CGFloat bianchang = MIN(w, h);
    
    CGFloat xx = [UIScreen mainScreen].bounds.size.width;
    
    UIImageView *imgV = [[UIImageView alloc] init];
    self.defaultImage = imgV;
    
    imgV.frame = CGRectMake(0, 0, bianchang/2, bianchang/2);
    
    imgV.center = CGPointMake(xx/2, cy);
    
    imgV.clipsToBounds = YES;
    imgV.borderColor = [UIColor whiteColor];
    imgV.borderWidth = BorderWidth;
    imgV.cornerRadius = bianchang/2/2;
    imgV.image = [UIImage imageNamed:@"私人订制默认"];
    
    [self addSubview:imgV];
    self.defaultImage.hidden = YES;
   
}

// 懒加载
- (NSMutableArray *)statesImages
{
    if (!_statesImages) {
        _statesImages = [NSMutableArray array];
    }
    return _statesImages;
}


- (void)setCount:(NSInteger)count{

    for (UIView *v in self.statesImages) {
        [v removeFromSuperview];
    }
    [self.statesImages removeAllObjects];
    
    if (count) {
        self.defaultImage.hidden = YES;
        
        for (int i = 0; i< count; i ++) {
            
            UIImageView *imgV = [[UIImageView alloc] init];
            [self addSubview:imgV];
            [self.statesImages addObject:imgV];
            imgV.borderColor = [UIColor whiteColor];
            imgV.borderWidth = BorderWidth;
            imgV.clipsToBounds = YES;
        }
    }else{
    
        self.defaultImage.hidden = NO;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bound = self.bounds;
    CGFloat cx = CGRectGetMidX(bound);
    CGFloat cy = CGRectGetMidY(bound);
    
    CGFloat margin = Margin;
    CGFloat w = CGRectGetWidth(bound);
    CGFloat h = CGRectGetHeight(bound);
    CGFloat bianchang ;
    //bianchang = bianchang - margin;
    
    switch (self.statesImages.count) {
        case 0:
        {
            bianchang = MIN(w, h);
            UIView *v = self.defaultImage;
            v.frame = CGRectMake(0,0,bianchang/1.1,bianchang/1.1);

            v.center = CGPointMake(cx, cy);
            v.cornerRadius = bianchang/1.1/2;

        }
            break;
        case 1:
        {
            bianchang = MIN(w, h);
            UIView *v = self.statesImages[0];
            v.frame = CGRectMake(0,0,bianchang/1.1,bianchang/1.1);

            v.center = CGPointMake(cx, cy);
            v.cornerRadius = bianchang/1.1/2;

        }
            break;
            
        case 2:
        {
            bianchang = MIN(w/2, h)-margin;
            UIView *v1 = self.statesImages[0];
            UIView *v2 = self.statesImages[1];
            
            CGPoint p1 = CGPointMake(w/4-margin/4, cy);
            CGPoint p2 = CGPointMake(w/4*3+margin/4, cy);
            
            v1.frame = v2.frame = CGRectMake(0, 0, bianchang,bianchang);


            v1.center = p1;
            v1.cornerRadius = v2.cornerRadius = bianchang/2;
            
            v2.center = p2;
            
        }
            break;
            
        case 3:
        {
            bianchang = MIN(w/3, h)-margin;
            UIView *v1 = self.statesImages[0];
            UIView *v2 = self.statesImages[1];
            UIView *v3 = self.statesImages[2];
            
            CGPoint p1 = CGPointMake(w/2, h/2-bianchang/2);
            CGPoint p2 = CGPointMake(w/6, h-bianchang/2-bianchang/4);
            CGPoint p3 = CGPointMake(w/6*5, h-bianchang/2-bianchang/4);
            
            v1.frame = v2.frame = v3.frame = CGRectMake(0, 0, bianchang,bianchang);

            v1.center = p1;
            v2.center = p2;
            v3.center = p3;
            
            v1.cornerRadius = v2.cornerRadius = v3.cornerRadius = bianchang/2;
            
            
        }
            break;
        default:
            break;
    }
}

-(NSArray *)showImg{

    return self.statesImages;
}


@end

