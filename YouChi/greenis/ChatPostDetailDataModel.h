//
//  ChatPostDetailDataModel.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/23.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatPostDetailDataModel : NSObject

@property (retain,nonatomic,readonly) NSMutableArray * addTimeArray;
@property (retain,nonatomic,readonly) NSMutableArray * contentArray;
@property (retain,nonatomic,readonly) NSMutableArray * userIdArray;
@property (retain,nonatomic,readonly) NSMutableArray * avatarArray;
@property (retain,nonatomic,readonly) NSMutableArray * usernameArray;
@property (retain,nonatomic,readonly) NSMutableArray * nickNameArray;

- (instancetype)initWithID:(NSInteger)ID forUpdate:(BOOL)isUpdate;

@end
