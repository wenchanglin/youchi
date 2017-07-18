//
//  IntroduceDetailViewController.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/21.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroduceDataModel.h"
//枚举器
typedef NS_ENUM(NSInteger,MessageViewState) {
    MessageViewStateShowFace,
    MessageViewStateShowShare,
    MessageViewStateShowNone,
};

@interface IntroduceDetailViewController : UIViewController
/*
@property (strong, nonatomic) NSString *formulaName;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *formulaId;
@property (strong, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSString *ingredients;
@property (strong, nonatomic) NSString *videoUrl;
@property (strong, nonatomic) NSString *stepStr;
@property (strong, nonatomic) NSString *shareUrl;
*/
- (instancetype)initWithData:(IntroduceDataModel*)data;

//- (instancetype)initWithFormulaID:(NSString*)formulaID andIntroduction:(NSString*)introduction andIngredients:(NSString*)ingredients andVideoUrl:(NSString*)videoUrl andStepStr:(NSString*)stepStr andFormulaName:(NSString*)formulaName andImageName:(NSString*)imageName andShareUrl:(NSString*)shareUrl;

@end
