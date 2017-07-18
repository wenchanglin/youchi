//
//  CommentContainer.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/24.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "CommentContainer.h"
#import "Masonry.h"
#import "AppConstants.h"
#import "commentCell.h"

@implementation CommentContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *commentImageView = [[UIImageView alloc] init];
    UIImage *commentImage = [UIImage imageNamed:@"talk2"];
    commentImage = [commentImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    commentImageView.image = commentImage;
    [self addSubview:commentImageView];
    [commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.width.and.height.equalTo(@25);
    }];
    
    UILabel *commentTitleLabel = [[UILabel alloc] init];
    commentTitleLabel.text = NSLocalizedString(@"pinglun", @"");
    commentTitleLabel.textColor = [AppConstants themeColor];
    [self addSubview:commentTitleLabel];
    [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentImageView.mas_centerY);
        make.left.equalTo(commentImageView.mas_right).with.offset(10);
    }];
    
    NSUInteger count = [_imageNameArray count];

    if (count != 0) {
        UIView *lastView = nil;
        for (int i = 1; i <= count; ++i)
        {
            CommentCell *subv = [[CommentCell alloc] initWithImageName:_imageNameArray[i - 1] andName:_nameArray[i - 1] andTime:_timeArray[i - 1] andContent:_contentArray[i - 1]];
            
            [self addSubview:subv];
            
            [subv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self);
                
                if ( lastView )
                {
                    make.top.mas_equalTo(lastView.mas_bottom);
                }
                else
                {
                    make.top.mas_equalTo(commentImageView.mas_bottom).with.offset(8);
                }
            }];
            
            lastView = subv;
        }
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastView.mas_bottom);
        }];
        
        return;
    }
    
    UILabel *noCommentLabel = [[UILabel alloc] init];
    noCommentLabel.text = NSLocalizedString(@"meiyoupinglun", @"");
    noCommentLabel.textColor = [AppConstants themeColor];
    [self addSubview:noCommentLabel];

    [noCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(commentImageView.mas_bottom).with.offset(10);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(noCommentLabel.mas_bottom).with.offset(10);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commentBeTouch" object:nil];
}

/*
- (void)setImageNameArray:(NSArray *)imageNameArray {
    if ([imageNameArray count] == 0) {
        _imageNameArray = [NSArray arrayWithObjects:@"introduceDetail", nil];
    }
    else {
        _imageNameArray = imageNameArray;
    }
}

- (void)setNameArray:(NSArray *)nameArray {
    if ([nameArray count] == 0) {
        _nameArray = [NSArray arrayWithObjects:@"introduceDetail", nil];
    }
    else {
        _nameArray = nameArray;
    }
}

- (void)setTimeArray:(NSArray *)timeArray {
    if ([timeArray count] == 0) {
        _timeArray = [NSArray arrayWithObjects:@"introduceDetail", nil];
    }
    else {
        _timeArray = timeArray;
    }
}

- (void)setDetailArray:(NSArray *)detailArray {
    if ([detailArray count] == 0) {
        _contentArray = [NSArray arrayWithObjects:@"introduceDetail", nil];
    }
    else {
        _contentArray = detailArray;
    }
}*/

@end
