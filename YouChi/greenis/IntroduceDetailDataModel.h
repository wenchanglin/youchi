//
//  IntroduceDetailDataModel.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/13.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroduceDetailDataModel : NSObject
//简介的图片数组
@property (retain,nonatomic,readonly) NSMutableArray * originalImageUrlArray;
@property (retain,nonatomic,readonly) NSMutableArray * remarkArray;
@property (retain,nonatomic,readonly) NSMutableArray * idArray;
@property (retain,nonatomic,readonly) NSMutableArray * thumbImageUrlArray;

- (instancetype)initWithFormulaId:(NSString*)formulaId; 

@end
