//
//  introduceDetailView.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/16.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "IntroduceDetailCell.h"
#import "Masonry.h"
#import "AppConstants.h"
#import "FileOperator.h"

#import "UIImageView+YYWebImage.h"

@interface IntroduceDetailCell ()
{

}

@property (strong,nonatomic) UIImageView    *imageView;
@property (strong,nonatomic) UILabel        *titleLabel;
@property (strong,nonatomic) UILabel        *introductionLabel;
@property (nonatomic) NSInteger             index;
@property (nonatomic) IntroduceStyle        introduceStyle;
@property (strong,nonatomic) NSObject       *data;
@end

@implementation IntroduceDetailCell
- (void)updateIntroduceDataModel:(IntroduceDataModel *)m
{
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], m.imageUrl];
    [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
    _titleLabel.text = m.formulaName;
    _introductionLabel.text = m.introduction;
}

- (instancetype)initWithStyleRecipe
{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        
        
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 10;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.font = [UIFont systemFontOfSize:14];
        _introductionLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_introductionLabel];
        
        
        
        
    }
    return self;
}

- (void)yc_initView
{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.left.equalTo(self).offset(8);
        make.width.equalTo(_imageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_top).with.offset(8);
        make.left.equalTo(_imageView.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imageView.mas_bottom).with.offset(-8);
        make.left.equalTo(_imageView.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
}

- (instancetype)initWithData:(NSObject*)data andStyle:(IntroduceStyle)style {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _data = data;
        
//        NSLog(@"data = %@", data);
        
        _introduceStyle = style;
        
        if (_introduceStyle == StyleRecipe) {
            _imageView = [[UIImageView alloc] init];
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], ((IntroduceDataModel*)data).imageUrl];
            
            [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
            
            _imageView.layer.masksToBounds = YES;
            _imageView.layer.cornerRadius = 10;
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView.clipsToBounds = YES;
            
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = [UIFont systemFontOfSize:15];
            _titleLabel.text = ((IntroduceDataModel*)data).formulaName;
            
            _introductionLabel = [[UILabel alloc] init];
            _introductionLabel.font = [UIFont systemFontOfSize:14];
            _introductionLabel.textColor = [UIColor lightGrayColor];
            _introductionLabel.text = ((IntroduceDataModel*)data).introduction;
            
            [self addSubview:_imageView];
            [self addSubview:_titleLabel];
            [self addSubview:_introductionLabel];
            
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(8);
                make.bottom.equalTo(self.mas_bottom).with.offset(-8);
                make.left.equalTo(self.mas_left).with.offset(8);
                make.width.equalTo(_imageView.mas_height);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imageView.mas_top).with.offset(8);
                make.left.equalTo(_imageView.mas_right).with.offset(8);
                make.right.equalTo(self.mas_right).with.offset(-20);
            }];
            
            [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_imageView.mas_bottom).with.offset(-8);
                make.left.equalTo(_imageView.mas_right).with.offset(8);
                make.right.equalTo(self.mas_right).with.offset(-20);
            }];
        }
        else if (_introduceStyle == StyleActivity) {
            _imageView = [[UIImageView alloc] init];
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], ((ChatActivityDataModel*)data).imageUrl];
            
            [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
            
            _imageView.layer.masksToBounds = YES;
            _imageView.layer.cornerRadius = 10;
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = [UIFont systemFontOfSize:15];
            _titleLabel.text = ((ChatActivityDataModel*)data).name;
            
            _introductionLabel = [[UILabel alloc] init];
            _introductionLabel.font = [UIFont systemFontOfSize:14];
            _introductionLabel.textColor = [UIColor lightGrayColor];
            _introductionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Nrencanyu", @""), ((ChatActivityDataModel*)data).forumPostTotal];
            
            [self addSubview:_imageView];
            [self addSubview:_titleLabel];
            [self addSubview:_introductionLabel];
            
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(8);
                make.bottom.equalTo(self.mas_bottom).with.offset(-8);
                make.left.equalTo(self.mas_left).with.offset(8);
                make.width.equalTo(_imageView.mas_height);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imageView.mas_top).with.offset(8);
                make.left.equalTo(_imageView.mas_right).with.offset(8);
                make.right.equalTo(self.mas_right).with.offset(-20);
            }];
            
            [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_imageView.mas_bottom).with.offset(-8);
                //                make.right.equalTo(_imageView.mas_right).with.offset(8);
                make.right.equalTo(self.mas_right).with.offset(-20);
            }];
        }
        else if (_introduceStyle == StyleTopic) {
            _imageView = [[UIImageView alloc] init];
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], ((ChatTopicDataModel*)data).imageUrl];
            
            [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
            
            _imageView.layer.masksToBounds = YES;
            _imageView.layer.cornerRadius = 10;
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = [UIFont systemFontOfSize:15];
            _titleLabel.text = [NSString stringWithFormat:@"#%@#", ((ChatTopicDataModel*)data).name];
            
            _introductionLabel = [[UILabel alloc] init];
            _introductionLabel.font = [UIFont systemFontOfSize:14];
            _introductionLabel.textColor = [UIColor lightGrayColor];
            _introductionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Nrencanyu", @""), ((ChatTopicDataModel*)data).forumPostTotal];
            
            [self addSubview:_imageView];
            [self addSubview:_titleLabel];
            [self addSubview:_introductionLabel];
            
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(8);
                make.bottom.equalTo(self.mas_bottom).with.offset(-8);
                make.left.equalTo(self.mas_left).with.offset(8);
                make.width.equalTo(_imageView.mas_height);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imageView.mas_top).with.offset(8);
                make.left.equalTo(_imageView.mas_right).with.offset(8);
                make.right.equalTo(self.mas_right).with.offset(-20);
            }];
            
            [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_imageView.mas_bottom).with.offset(-8);
                make.right.equalTo(self.mas_right).with.offset(-20);
            }];
        }
        
        if (_imageView.image == nil) {
            _imageView.image = [UIImage imageNamed:@"activityImage.png"];
        }
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
        [_delegate introduceDetailCellClickAtData:_data];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesCancelled:touches withEvent:event];
}

@end
