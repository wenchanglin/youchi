//
//  introduceDetailView.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/16.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroduceDataModel.h"
#import "ChatTopicDataModel.h"
#import "ChatActivityDataModel.h"

typedef  NS_ENUM(NSInteger, IntroduceStyle) {
    StyleRecipe,
    StyleActivity,
    StyleTopic
};

@protocol IntroduceDetailCellDelegate <NSObject>

- (void)introduceDetailCellClickAtData:(NSObject*)data;

@end

@interface IntroduceDetailCell : UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

//- (instancetype)initWithImageName:(NSString*)imageName isFromHttp:(BOOL)isFromHttp andTitle:(NSString*)Title andIntroduction:(NSString*)introduction andIndex:(NSInteger)index withStyle:(IntroduceStyle)style;
- (instancetype)initWithData:(NSObject*)data andStyle:(IntroduceStyle)style;

- (instancetype)initWithStyleRecipe;
- (void)updateIntroduceDataModel:(IntroduceDataModel *)m;

@property (strong, nonatomic) id <IntroduceDetailCellDelegate> delegate;

@end
