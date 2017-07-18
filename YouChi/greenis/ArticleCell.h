//
//  ArticleCell.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/25.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ArticleDataModel.h"
@protocol ArticleCellDelegate <NSObject>

- (void)articleCellClickAtIndex:(NSInteger)index;

@end

typedef void(^ArticleCellSelectBlock)(void);
@interface ArticleCell : UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (instancetype)initWithImageName:(NSString*)imageName andTitle:(NSString*)Title andIndex:(NSInteger)index;

- (void)updateArticleDataModel:(ArticleDataModel *)m;
@property (nonatomic,strong) ArticleCellSelectBlock selectBlock;
- (void)setSelectBlock:(ArticleCellSelectBlock)selectBlock;

@property (strong, nonatomic) id <ArticleCellDelegate> delegate;

@end