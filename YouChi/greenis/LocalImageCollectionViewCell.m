//
//  LocalImageCollectionViewCell.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/24.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "LocalImageCollectionViewCell.h"
#import "Masonry.h"

@implementation LocalImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _selectImageView = [[UIImageView alloc] init];
        
        [self addSubview:_imageView];
        [_imageView addSubview:_selectImageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.right.equalTo(_imageView);
            make.width.and.height.mas_equalTo(([UIScreen mainScreen].bounds.size.width / 4.0f - 10) / 3);
        }];
    }
    return self;
}

- (void)sendValue:(id)dic
{
    self.imageView.image = [dic objectForKey:@"img"];
    selectFlag = [[dic objectForKey:@"flag"] boolValue];
    if (selectFlag)
    {
        self.selectImageView.image = [UIImage imageNamed:@"imageSelect"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"imageUnselect"];
    }
}

- (void)setSelectFlag:(BOOL)flag
{
    selectFlag = flag;
    
    if (selectFlag)
    {
        self.selectImageView.image = [UIImage imageNamed:@"imageSelect"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"imageUnselect"];
    }
}

@end
