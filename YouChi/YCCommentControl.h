//
//  YCZanShuVC.h
//  YouChi
//
//  Created by 李李善 on 15/8/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCInputControl.h"
#import "YCChihuoyingM.h"
typedef NS_ENUM(NSUInteger, YCButtonType) {
    YCButtonTypeCollect = 0,///收藏
    YCButtonTypeDelete,     ///删除
    YCButtonTypeMore,       ///更多
    YCButtonTypeYouChi,     ///我的收藏随手拍
};

@interface YCDotButton :UIButton
@property (nonatomic,assign) int number;
@end

IB_DESIGNABLE @interface YCCommentControl : UIControl
///按钮赞
@property (nonatomic,strong) UIButton *like;
///按钮评论
@property (nonatomic,strong) UIButton *comment;
///按钮收藏
@property (nonatomic,strong) UIButton *favorite;

@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,assign) BOOL isTranslation;
@property(nonatomic,assign) YCButtonType ButtonType;

- (void)updateWithIsLike:(BOOL)like isFavorite:(BOOL)favorite;
- (void)updateWithIsLike:(BOOL)like isFavorite:(BOOL)favorite likeCount:(int)likeCount commentCount:(int)commentCount;
- (void)updateWithModel:(YCChihuoyingM_1_2 *)m;
@end



IB_DESIGNABLE @interface YCLeftCommentControl : YCCommentControl
///分享
@property (nonatomic,strong) UIButton *share;
///输入框
@property (nonatomic,strong) YCInputControl *inputControl;
- (void)updatePlaceholder:(NSString *)placeholder;
@end