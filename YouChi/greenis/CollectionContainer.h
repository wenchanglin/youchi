//
//  CollectionView.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/9/17.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionContainerDelegate <NSObject>

- (void)collectionContainerClickAtKeyword:(NSString*)keyword;

@end

@interface CollectionContainer : UIView

@property (strong,nonatomic) id <CollectionContainerDelegate> delegate;

- (instancetype)initWithTags:(NSArray*)tags;

@end
