//
//  ChatCollectionViewCell.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/10/27.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatCollectionViewCellDelegate <NSObject>

- (void)chatCollectionViewCellClickByUserID:(NSString*)userid andUserAvatar:(NSString*)Avatar andUsername:(NSString*)username;
@end

@interface ChatCollectionViewCell : UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (instancetype)initWithImageUrl:(NSString*)ImageUrl andUserName:(NSString*)UserName andUserID:(NSString*)UserID andIsTouchEnabled:(BOOL)isTouch;

@property (strong, nonatomic) id <ChatCollectionViewCellDelegate> delegate;

@end
