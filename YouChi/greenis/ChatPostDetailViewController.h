//
//  ChatPostDetailViewController.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/2.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatLiaoLiaoPostDataModel.h"

@protocol PostDetailViewDelegate <NSObject>

- (void)postDetailViewChangeWithData:(ChatLiaoLiaoPostDataModel*)data andIndex:(NSInteger)index;

@end

@interface ChatPostDetailViewController : UIViewController

@property (strong, nonatomic) id <PostDetailViewDelegate> delegate;

- (instancetype)initWithData:(ChatLiaoLiaoPostDataModel*)data andIndex:(NSInteger)index;

@end
