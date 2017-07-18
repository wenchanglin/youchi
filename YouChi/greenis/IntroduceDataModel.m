//
//  IntroduceDataModel.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/20.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "IntroduceDataModel.h"

@implementation IntroduceDataModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"imageUrl" : @"ImgUrl",
             @"formulaName" : @"FormulaName",
             @"introduction" : @"Introduction",
             @"steps" : @"Steps",
             @"formulaID" : @"FormulaID",
             @"ingredients" : @"Ingredients",
             @"videoUrl" : @"VideoUrl",
             @"share_url" : @"shareUrl",
             //@"ingredients" : @"Ingredients",
             };
}
@end

@implementation IntroduceDatas

@end
