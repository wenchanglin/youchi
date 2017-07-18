//
//  PostDetailCell.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/16.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatLiaoLiaoPostDataModel.h"

@protocol PostDetailCellDelegate <NSObject>

- (void)postDetailCellHeadImageViewClickByUserid:(NSString*)userid andUsername:(NSString*)username andUserAvatar:(NSString*)Avatar;
- (void)postDetailCellContentImageViewClickAtIndex:(NSInteger)index andImages:(NSArray*)images;
- (void)postDetailCellClickAtData:(ChatLiaoLiaoPostDataModel*)data andIndex:(NSInteger)index;
- (void)postDetailCellLongPressAtData:(ChatLiaoLiaoPostDataModel*)data;
- (void)postDetailCellChangeWithData:(ChatLiaoLiaoPostDataModel*)data andIndex:(NSInteger)index;

@end

@interface PostDetailCell : UIView
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
*/

- (instancetype)initWithData:(ChatLiaoLiaoPostDataModel*)data andIsLikeable:(BOOL)isLikeable andIndex:(NSInteger)index;
//- (instancetype)initWithUsername:(NSString*)username andPostID:(NSString*)postid andUserID:(NSString*)userid andAddtime:(NSString*)addtime andContent:(NSString*)content andImages:(NSArray*)images andThumbsupDegree:(NSString*)thumbsupDegree andCommentDegree:(NSString*)commentDegree andIndex:(NSInteger)index;
- (void)changeWithData:(ChatLiaoLiaoPostDataModel*)data;

@property (strong, nonatomic) id <PostDetailCellDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary   *postDataModel;
@property (nonatomic) BOOL                          isLikeable;

@end
