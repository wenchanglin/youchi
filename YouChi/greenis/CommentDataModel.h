//
//  CommentDataModel.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/23.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentDataModel : NSObject

@property (strong,nonatomic,readonly) NSMutableArray                *imageNameArray;
@property (strong,nonatomic,readonly) NSMutableArray                *nameArray;
@property (strong,nonatomic,readonly) NSMutableArray                *timeArray;
@property (strong,nonatomic,readonly) NSMutableArray                *contentArray;

- (instancetype)initWithFormulaId:(NSString*)formulaId AndCommentCount:(int)count forUpdate:(BOOL)isUpdate;

@end
