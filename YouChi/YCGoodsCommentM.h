//
//  YCGoodsCommentM.h
//  YouChi
//
//  Created by sam on 16/1/22.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import "YCLoginM.h"
#import <YYKit/YYKit.h>
@interface YCGoodsCommentM : YCBaseImageModel
@property (nonatomic,strong) NSString *orderPayDate,*nickName;
@property (nonatomic,strong) NSNumber *isClickLike,*productShowoffId;
@property (nonatomic,strong) NSMutableArray *shopProductShowoffImages;
@property (nonatomic,strong) YCLoginUserM *user;
@property (nonatomic,strong) YYTextLayout *layout;
@property (nonatomic,assign) CGFloat cellHeight;
@end
