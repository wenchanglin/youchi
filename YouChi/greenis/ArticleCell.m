//
//  ArticleCell.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/25.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "ArticleCell.h"
#import "AppConstants.h"
#import "FileOperator.h"
#import "Masonry.h"


@interface ArticleCell ()
{
    
}

@property (strong,nonatomic) UIImageView    *imageView;
@property (strong,nonatomic) UILabel        *titleLabel;
@property (nonatomic) NSInteger             index;

@end

@implementation ArticleCell
- (void)updateArticleDataModel:(ArticleDataModel *)m
{
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], m.imageUrl];
    [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
    _titleLabel.text = m.title;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        
        
        
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = ([AppConstants uiScreenWidth] - 60) / 6;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        
        
    }
    return self;
}

- (void)yc_initView
{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        //            make.bottom.equalTo(self.mas_bottom).with.offset(-25);
        make.width.equalTo(self).with.offset(-20);
        make.centerX.equalTo(self);
        make.height.equalTo(_imageView.mas_width);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).with.offset(5);
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(-10);
    }];
}

- (instancetype)initWithImageName:(NSString*)imageName andTitle:(NSString*)Title andIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _index = index;
        
        _imageView = [[UIImageView alloc] init];
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], imageName];
        
        [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
        
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = ([AppConstants uiScreenWidth] - 60) / 6;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = Title;

        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
//            make.bottom.equalTo(self.mas_bottom).with.offset(-25);
            make.width.equalTo(self).with.offset(-20);
            make.centerX.equalTo(self);
            make.height.equalTo(_imageView.mas_width);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).with.offset(5);
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(-10);
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
    
    //    NSLog(@"%f, %f, %f, %f, %f, %f", self.frame.size.width, self.frame.size.height, self.frame.origin.x, self.frame.origin.y, touchPoint.x, touchPoint.y);
    if (touchPoint.x > 0 && touchPoint.x < self.frame.size.width && touchPoint.y > 0 && touchPoint.y < self.frame.size.height)
    {
        //        NSLog(@"_titleLabel.text");
        [_delegate articleCellClickAtIndex:_index];
    }
    if (_selectBlock) {
        _selectBlock();
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesCancelled:touches withEvent:event];
}


@end
