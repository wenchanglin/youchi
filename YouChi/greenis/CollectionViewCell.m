//
//  collectionViewCell.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/9/17.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Masonry.h"

@interface CollectionViewCell ()
{
    
}

@property (strong, nonatomic) UILabel       *titleLabel;
@property (nonatomic) NSInteger             index;
@property (nonatomic) BOOL                  isTouchEnabled;

@end

@implementation CollectionViewCell

- (instancetype)initWithTitle:(NSString*)title andIndex:(NSInteger)index andColor:(UIColor*)color andIsTouchEnabled:(BOOL)isTouch{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _index = index;
        _isTouchEnabled = isTouch;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = title;
        if (color != nil) {
            _titleLabel.textColor = color;
        }

        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];

    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isTouchEnabled) return;
    
    [self setBackgroundColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0]];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isTouchEnabled) return;

    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    if (touchPoint.x > 0 && touchPoint.x < self.frame.size.width && touchPoint.y > 0 && touchPoint.y < self.frame.size.height)
    {
        [_delegate collectionViewCellClickAtKeyword:_titleLabel.text];
        
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isTouchEnabled) return;

    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesCancelled:touches withEvent:event];
    
//    NSLog(@"touchesCancelled");
}

@end
