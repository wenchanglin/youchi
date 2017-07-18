//
//  ChatAdDataModel.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/10/23.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatAdDataModel : NSObject

@property (strong,nonatomic) NSString  *adType;
@property (strong,nonatomic) NSString  *addtime;
@property (strong,nonatomic) NSString  *content;
@property (strong,nonatomic) NSString  *Id;
@property (strong,nonatomic) NSString  *imageUrl;
@property (strong,nonatomic) NSString  *name;
@property (strong,nonatomic) NSString  *shareUrl;
@property (strong,nonatomic) NSString  *topicIdFk;

@end

@interface ChatADDatas : NSObject
@property (nonatomic, strong) NSArray *datas;
@end

