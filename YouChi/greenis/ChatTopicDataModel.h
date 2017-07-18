//
//  ChatTopicDataModel.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/10.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatTopicDataModel : NSObject

@property (strong,nonatomic) NSString* addTime;
@property (strong,nonatomic) NSString* content;
@property (strong,nonatomic) NSString* Id;
@property (strong,nonatomic) NSString* forumPostTotal;
@property (strong,nonatomic) NSString* hotDegree;
@property (strong,nonatomic) NSString* imageUrl;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* shareUrl;

@end

@interface ChatTopicDatas : NSObject
@property (nonatomic, strong) NSArray *datas;
@end
