//
//  ChatCollectionContainer.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/10/27.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatCollectionContainerDelegate <NSObject>

- (void)chatCollectionContainerClickByUserID:(NSString*)userid andUserAvatar:(NSString*)Avatar andUsername:(NSString*)username;

@end

@interface ChatCollectionContainer : UIView

@property (strong,nonatomic) id <ChatCollectionContainerDelegate> delegate;

//- (instancetype)initWithAvatars:(NSArray*)Avatars andSavedImage:(NSArray*)savedImages andNickname:(NSArray*)nicknames andUserID:(NSArray*)userIDs;

- (instancetype)initWithDatas:(NSArray*)datas;

@end
