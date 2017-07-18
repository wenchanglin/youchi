//
//  IntroduceDetailStepViewCell.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/19.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "IntroduceDetailStepViewCell.h"
#import "Masonry.h"
#import "FileOperator.h"
#import "AppConstants.h"
#import "UIImageView+YYWebImage.h"

@implementation IntroduceDetailStepViewCell
@synthesize tag;

- (instancetype)initWithRemark:(NSString*)remarkText AndImageUrl:(NSString*)imageUrl AndTag:(NSInteger)index {
    self = [super init];
    if (self) {
        self.tag = index;
        
        UILabel *remarkLabel = [[UILabel alloc] init];
        remarkLabel.text = remarkText;
        remarkLabel.numberOfLines = 0;
        
        _imageView = [[UIImageView alloc] init];
        
        NSString *imageHttpUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], imageUrl];
        
        [_imageView setImageWithURL:[NSURL URLWithString:imageHttpUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:remarkLabel];
        [self addSubview:_imageView];
        
        [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(10);
            make.right.equalTo(self).with.offset(-20);
        }];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remarkLabel.mas_bottom).with.offset(10);
            make.left.equalTo(remarkLabel).with.offset(20);
            make.right.equalTo(remarkLabel).with.offset(-20);
//            make.width.mas_equalTo([AppConstants uiScreenWidth] - 40);
            make.height.mas_equalTo(([AppConstants uiScreenWidth] - 40) / 3 * 2);
        }];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0]];
    
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.x > 0 && touchPoint.x < self.frame.size.width && touchPoint.y > 0 && touchPoint.y < self.frame.size.height)
    {
        [_delegate stepViewCellTouch:self.tag];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesCancelled:touches withEvent:event];
}

@end
