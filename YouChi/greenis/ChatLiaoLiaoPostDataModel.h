//
//  ChatLiaoLiaoPostDataModel.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/23.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatLiaoLiaoPostDataModel : NSObject

@property (strong,nonatomic) NSString* addtime;
@property (strong,nonatomic) NSString* clickDegree;
@property (strong,nonatomic) NSString* commentDegree;
@property (strong,nonatomic) NSString* content;
@property (strong,nonatomic) NSString* hotDegree;
@property (strong,nonatomic) NSString* Id;
@property (strong,nonatomic) NSString* avatar;
@property (strong,nonatomic) NSString* thumbsupDegree;
@property (strong,nonatomic) NSString* userId;
@property (strong,nonatomic) NSString* userName;
@property (strong,nonatomic) NSString* image1URL;
@property (strong,nonatomic) NSString* image2URL;
@property (strong,nonatomic) NSString* image3URL;
@property (strong,nonatomic) NSString* image4URL;
@property (strong,nonatomic) NSString* image5URL;
@property (strong,nonatomic) NSString* image6URL;
@property (strong,nonatomic) NSString* image7URL;
@property (strong,nonatomic) NSString* image8URL;
@property (strong,nonatomic) NSString* image9URL;
@property (strong,nonatomic) NSString* thumbImage1URL;
@property (strong,nonatomic) NSString* thumbImage2URL;
@property (strong,nonatomic) NSString* thumbImage3URL;
@property (strong,nonatomic) NSString* thumbImage4URL;
@property (strong,nonatomic) NSString* thumbImage5URL;
@property (strong,nonatomic) NSString* thumbImage6URL;
@property (strong,nonatomic) NSString* thumbImage7URL;
@property (strong,nonatomic) NSString* thumbImage8URL;
@property (strong,nonatomic) NSString* thumbImage9URL;
@property (strong,nonatomic) NSString* liked;

@end

@interface ChatLiaoLiaoPostDatas : NSObject
@property (nonatomic, strong) NSMutableArray *datas;
@end