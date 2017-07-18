//
//  IntroduceDetailStepViewCell.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/19.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroduceDetailStepViewCellDelegate <NSObject>

- (void)stepViewCellTouch:(NSInteger)index;

@end

@interface IntroduceDetailStepViewCell : UIView

@property (strong, nonatomic)UIImageView *imageView;
@property (nonatomic)NSInteger tag;
@property (strong, nonatomic)id <IntroduceDetailStepViewCellDelegate> delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (instancetype)initWithRemark:(NSString*)remarkText AndImageUrl:(NSString*)imageUrl AndTag:(NSInteger)index;

@end
