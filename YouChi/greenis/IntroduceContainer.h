//
//  IntroduceContainer.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/20.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroduceDetailCell.h"

@protocol IntroduceContainerDelegate <NSObject>

- (void)introduceContainerClickAtData:(NSObject*)data;

@end

@interface IntroduceContainer : UIView

@property (strong,nonatomic) id <IntroduceContainerDelegate> delegate;
@property (nonatomic) NSInteger                                 totalCount;

//@property (nonatomic) NSUInteger                    clickedIndex;

//- (instancetype)initWithImages:(NSArray*)images andFormulaNames:(NSArray*)formulas andIntroductions:(NSArray*)introductions andSavedImages:(NSArray*)savedImages  withStyle:(IntroduceStyle)style;
- (instancetype)initWithDatas:(NSArray*)datas andStyle:(IntroduceStyle)style;

- (void)loadMoreWithPage:(NSInteger)page andID:(NSString*)ID;

@end
