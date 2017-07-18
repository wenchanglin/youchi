//
//  ArticleScrollView.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/21.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "ArticleScrollView.h"

#import "Masonry.h"
#import "AppConstants.h"

#import "UIImageView+YYWebImage.h"
#import "FileOperator.h"
#import "ArticleCell.h"
#import "ArticleDataModel.h"

@interface ArticleScrollView () <ArticleCellDelegate>
{

}

@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UIView         *container;

@end

@implementation ArticleScrollView

#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.bounces = NO;
        
        _container = [UIView new];
        _container.backgroundColor = [UIColor whiteColor];
        [self addSubview:_container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.equalTo(self);
        }];
        
        _imageViews = [NSMutableArray arrayWithCapacity:100];
    }
    return self;
}

- (void)updateConstraints {
    
    [super updateConstraints];
    
    for (UIView *view in _container.subviews) {
        [view removeFromSuperview];
    }
    
    NSUInteger count = [_dataArray count];
//    NSLog(@"[Article imageArray count] = %lu", (unsigned long)[_imageArray count]);
    ArticleCell *lastView = nil;
    for (int i = 0; i < count; ++i)
    {
        ArticleCell *articleCell;

        articleCell = [[ArticleCell alloc] initWithImageName:((ArticleDataModel*)[_dataArray objectAtIndex:i]).imageUrl andTitle:((ArticleDataModel*)[_dataArray objectAtIndex:i]).title andIndex:i];

        articleCell.delegate = self;
//        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        /*
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        imageView.tag = i;
//        imageView.image = [_imageArray objectAtIndex:i];
        imageView.layer.masksToBounds=YES;
        imageView.layer.cornerRadius=([AppConstants uiScreenWidth] - 60) / 6;
*/
        [_container addSubview:articleCell];
//        [_imageViews addObject:imageView];
        
        [articleCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_container);
            //make.bottom.equalTo(_container).with.offset(-10);
            make.width.mas_equalTo([AppConstants uiScreenWidth] / 3);
            make.height.mas_equalTo([AppConstants uiScreenWidth] / 3 + 30);
            
            if ( lastView )
            {
                make.left.mas_equalTo(lastView.mas_right);
            }
            else
            {
                make.left.mas_equalTo(_container.mas_left);
            }
        }];
        
        lastView = articleCell;
    }
    
    if (lastView != nil) {
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

- (void)articleCellClickAtIndex:(NSInteger)index {
    NSLog(@"articleScrollViewClickAtIndex");
    [_articleDelegate articleScrollViewClickAtIndex:index];
}

- (void)dealloc {
    NSLog(@"article dealloc");
}

@end

