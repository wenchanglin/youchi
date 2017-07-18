//
//  collectionViewCell.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/9/17.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionViewCellDelegate <NSObject>

- (void)collectionViewCellClickAtKeyword:(NSString*)keyword;

@end

@interface CollectionViewCell : UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (instancetype)initWithTitle:(NSString*)title andIndex:(NSInteger)index andColor:(UIColor*)color andIsTouchEnabled:(BOOL)isTouch;

@property (strong, nonatomic) id <CollectionViewCellDelegate> delegate;

@end
