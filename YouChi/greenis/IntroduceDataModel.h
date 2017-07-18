//
//  IntroduceDataModel.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/20.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstants.h"

@interface IntroduceDataModel : NSObject

@property (strong,nonatomic) NSString * effect;
@property (strong,nonatomic) NSString * formulaID;
@property (strong,nonatomic) NSString * formulaName;
@property (strong,nonatomic) NSString * imageUrl;
@property (strong,nonatomic) NSString * ingredients;
@property (strong,nonatomic) NSString * introduction;
@property (strong,nonatomic) NSString * steps;
@property (strong,nonatomic) NSString * userNickName;
@property (strong,nonatomic) NSString * videoUrl;
@property (strong,nonatomic) NSString * albumsTotal;
@property (strong,nonatomic) NSString * commentTotal;
@property (strong,nonatomic) NSString * friendsTotal;
@property (strong,nonatomic) NSString * stepTotal;
@property (strong,nonatomic) NSString * tagsTotal;
@property (strong,nonatomic) NSString * shareUrl;

@end

@interface IntroduceDatas : NSObject
@property (nonatomic, strong) NSArray *datas;
@end

