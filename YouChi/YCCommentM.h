//
//  YCChihuoyingCommentM.h
//  YouChi
//
//  Created by sam on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import "YCMeM.h"
#import "YCChihuoyingM.h"
@interface YCCommentM : YCBaseUserImageModel
@property (nonatomic,strong) NSString *comment,*replyUserName,*levelName;
@property (nonatomic,strong) NSNumber *replyCommentId,*replyUserId,*youchiId;


///
@property (nonatomic,strong,readonly) NSAttributedString *ui_comment;
@property CGFloat cellHeight;

- (void)onSetupHeightWithWidth:(float)width;
@end

