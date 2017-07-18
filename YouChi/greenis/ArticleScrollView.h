//
//  ArticleScrollView.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/21.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArticleScrollViewDelegate <NSObject>

- (void)articleScrollViewClickAtIndex:(NSInteger)index;

@end

@interface ArticleScrollView : UIScrollView

@property (strong,nonatomic) NSArray                *dataArray;

/*
@property (retain,nonatomic,readwrite) NSArray *imageArray;
@property (retain,nonatomic,readwrite) NSArray *titleArray;
@property (retain,nonatomic,readwrite) NSMutableArray *savedImageArray;*/

@property (strong, nonatomic) id <ArticleScrollViewDelegate> articleDelegate;

@end
