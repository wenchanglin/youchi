//
//  PostContainer.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/16.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDetailCell.h"
#import "ChatLiaoLiaoPostDataModel.h"

typedef  NS_ENUM(NSInteger, PostType) {
    PostAdDetail,
    PostActivityDetail,
    PostTopicDetail,
    PostQueryByUserid,
    PostMine,
    PostNormal
};

@protocol PostContainerDelegate <NSObject>

- (void)postContainerHeadImageViewClickByUserid:(NSString*)userid andUsername:(NSString*)username andUserAvatar:(NSString*)Avatar;
- (void)postContainerContentImageViewClickAtIndex:(NSInteger)index andImages:(NSArray*)images;
- (void)postContainerClickAtData:(ChatLiaoLiaoPostDataModel*)data andIndex:(NSInteger)index;
- (void)postContainerLongPressAtData:(ChatLiaoLiaoPostDataModel*)data;

@end

@interface PostContainer : UIView

@property (strong,nonatomic) id <PostContainerDelegate> delegate;


//@property (nonatomic) NSUInteger                    clickedIndex;
- (instancetype)initWithDatas:(NSArray*)datas andPostType:(PostType)postType;
//- (instancetype)initWithUsername:(NSArray*)usernames andPostID:(NSArray*)postids andUserID:(NSArray*)useridArray andAddtime:(NSArray*)addtimes andContent:(NSArray*)content andImages:(NSArray*)images andThumbsupDegree:(NSArray*)thumbsupDegree andCommentDegree:(NSArray*)commentDegree andPostType:(PostType)postType;

- (PostDetailCell*)cellAtIndex:(NSInteger)index;

- (void)loadMoreWithPage:(NSInteger)page andID:(NSString*)Id;
//- (void)removeWithPostID:(NSString*)postID;
- (void)changeWithData:(ChatLiaoLiaoPostDataModel*)data atIndex:(NSInteger)index;

@end