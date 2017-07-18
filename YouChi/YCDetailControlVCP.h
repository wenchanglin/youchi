//
//  YCChihuoyingVCP.h
//  YouChi
//
//  Created by 李李善 on 15/8/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCCommentControl.h"

@class YCRunLabel;
@class YCCommentM;
@class YCChihuoyingM_1_2;
@protocol YCDetailControlDatasource <NSObject>
@property (nonatomic,strong,readonly) YCChihuoyingM_1_2 *updateModel;
@property (nonatomic,strong) YCCommentM *replyModel;
@property (nonatomic,assign,readonly) YCCheatsType cheatsType;
@property (nonatomic,assign,readonly) YCShareType shareType;
@property (nonatomic,strong,readonly) NSString *shareImageUrl;
@property (nonatomic,strong,readonly) NSString *shareHtml5UrlString;

- (RACSignal *)likeById:(NSNumber *)Id isLike:(BOOL)like type:(YCCheatsType)type;
- (RACSignal *)favoriteById:(NSNumber *)Id isFavorite:(BOOL)favorite type:(YCCheatsType)type;
@end


@interface YCDetailControlVCP : YCKeyboardViewController
@property (nonatomic,weak) YCTableViewController *tableViewController;

@property (nonatomic,strong) YCViewModel <YCDetailControlDatasource> *viewModel;
@property (strong, nonatomic) IBOutlet YCLeftCommentControl *inputBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBarComstraints;
@property (assign,nonatomic) BOOL isMoreCommentList;
@property (weak, nonatomic) IBOutlet YCRunLabel *lRunTitle;


@end

