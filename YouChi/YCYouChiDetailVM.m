//
//  YCSpecialDrinkVM.m
//  YouChi
//
//  Created by sam on 15/5/19.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouChiDetailVM.h"
#import "YCCommentM.h"
#import "YCCatolog.h"
#import "YCViewModel+Logic.h"
@implementation YCYouChiDetailVM

@synthesize model;

- (void)dealloc
{
    //ok
}

- (instancetype)initWithYouChiId:(id)aId
{
    _youchiId = aId;
    self.Id = aId;
    return [self initWithParameters:@{
                                      kToken:[YCUserDefault currentToken],
                                      @"youchiId":aId,
                                      }];
}

- (instancetype)initWithId:(id)aId
{
    _youchiId = aId;
    self.Id = aId;
    return [self initWithParameters:@{
                                      kToken:[YCUserDefault currentToken],
                                      @"youchiId":aId,
                                      }];
}


- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    if(section==4){
        return 26.f;
    }
    else if(section==6){
        if ( [self numberOfItemsInSection:section] > 0){
            return KSectionHeight;
        }}
    return 0;
}

- (NSString *)headerIDInSection:(NSInteger)section
{
    if(section==4){
        return headerC;
    }
    else if (section == 6){
        return headerC2;
    }
    
    return nil;
}

#pragma mark --网络请求
- (RACSignal *)mainSignal{
    WSELF;
    return [[ENGINE POST_shop_object:apiCGetYouchiDetail parameters:self.parameters parseClass:[YCChihuoyingM_1_2 class] parseKey:nil]doNext:^(YCChihuoyingM_1_2 *x) {
        SSELF;
        [self willChangeValueForKey:KP(self.updateModel)];
        
        for (YCCommentM *m in x.youchiCommentList) {
            [m onSetupHeightWithWidth:kScreenWidth];
        }
        
        NSMutableAttributedString *desc;
        if (x.desc) {
            desc = [[NSMutableAttributedString alloc]initWithString:x.desc];
            desc.font          = KFont(kFontYouChiContent);
            desc.lineSpacing = 4;
        }
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, HUGE) insets:UIEdgeInsetsMake(14, 17, 14, 17)];
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:desc];
        
        YCCellNumberBlock numberBlock = [YCCellInfo number:^NSInteger(NSInteger section) {
            return 1;
        }];
        YCCellModelBlock modelBlock = [YCCellInfo model:^id(NSIndexPath *indexPath) {
            return x;
        }];
        
        [self.cellInfos setArray:@[
                                   [YCCellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath *indexPath) {
            return 70.f;
        } number:numberBlock model:modelBlock],
                                   [YCCellInfo cellInfoWithId:cell1 height:^CGFloat(NSIndexPath *indexPath) {
            //YCChihuoyingM_1_2 *m = x.youchiPhotoList[indexPath.row];
            CGFloat h = DAMAI_RATIO_2(SCREEN_WIDTH, 4, 3)+YCYouChiDetailInset*2;
            return h;
        } number:^NSInteger(NSInteger section) {
            return x.youchiPhotoList.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.youchiPhotoList[indexPath.row];
        }],
                                   [YCCellInfo cellInfoWithId:cell2 height:^CGFloat(NSIndexPath *indexPath) {
            return layout.textBoundingSize.height;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return layout;
        }],
                                   [YCCellInfo cellInfoWithId:cell3 height:^CGFloat(NSIndexPath *indexPath) {
            return 45.f;
        } number:numberBlock model:modelBlock],
                                   [YCCellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath *indexPath) {
            return 126.f;
        } number:numberBlock model:modelBlock],
                                   [YCCellInfo cellInfoWithId:cell5 height:^CGFloat(NSIndexPath *indexPath) {
            return 70.f;
        } number:numberBlock model:modelBlock],
                                   [YCCellInfo cellInfoWithId:cell6 height:^CGFloat(NSIndexPath *indexPath) {
            YCCommentM *m = x.youchiCommentList[indexPath.row];
            
            return m.cellHeight;
        } number:^NSInteger(NSInteger section) {
            return x.youchiCommentList.count;
        } model:^id(NSIndexPath *indexPath) {
            return  x.youchiCommentList[indexPath.row];
        }],
                                   ]];
        
        self.model = x;
        self.title = x.materialName;
        self.insertFrontSection = self.cellInfos.count-1;
        [self didChangeValueForKey:KP(self.updateModel)];
    }];
}

#pragma mark -


- (RACSignal *)replySignalId:(NSNumber *)Id replyCommentId:(NSNumber *)replyCommentId replyUserId:(NSNumber *)replyUserId comment:(NSString *)comment type:(YCCheatsType)type
{
    WSELF;
    return [[super replySignalId:Id replyCommentId:replyCommentId replyUserId:replyUserId comment:comment type:YCCheatsTypeYouChi]doNext:^(YCCommentM *x) {
        SSELF;
        if (!self.model.youchiCommentList) {
            self.model.youchiCommentList = [NSMutableArray new];
        }
        [x onSetupHeightWithWidth:kScreenWidth];
        [self.model.youchiCommentList insertObject:x atIndex:0];
    }];
}

- (RACSignal *)likeById:(NSNumber *)Id isLike:(BOOL)like type:(YCCheatsType)type{
    WSELF;
    return [[super likeById:Id isLike:like type:YCCheatsTypeYouChi]doNext:^(id x) {
        SSELF;
        __block BOOL hasMe ;
        __block NSUInteger where = 0;
        YCLoginUserM *user = [YCUserDefault currentUser].appUser;
        NSNumber *myId = user.Id;
        if (!self.model.youchiLikeList) {
            self.model.youchiLikeList = [NSMutableArray new];
        }
        [self.model.youchiLikeList enumerateObjectsUsingBlock:^(YCBaseUserImageModel *obj, NSUInteger idx, BOOL *stop) {
            if (myId.intValue == obj.userId.intValue) {
                hasMe = YES;
                where = idx;
                *stop = YES;
                
            }
        }];


        @try {
            if (like) {
                YCBaseUserImageModel *m = [YCBaseUserImageModel new];
                m.userImagePath = user.imagePath;
                m.userId = myId;
                [self.model.youchiLikeList insertObject:m atIndex:0];
                
            } else {
                [self.model.youchiLikeList removeObjectAtIndex:where];
            }
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }

    }];
}

- (RACSignal *)favoriteById:(NSNumber *)Id isFavorite:(BOOL)favorite type:(YCCheatsType)type
{
    return [super favoriteById:Id isFavorite:favorite type:YCCheatsTypeYouChi];
}

#pragma mark -
- (YCChihuoyingM_1_2 *)updateModel
{
    return self.model;
}


- (YCCheatsType)cheatsType
{
    return YCCheatsTypeYouChi;
}

- (NSString *)shareImageUrl
{
    YCBaseImageModel *pm = self.model.youchiPhotoList.firstObject;
    return IMAGE_HOST_NOT_SHOP_(pm.imagePath);
}

- (NSString *)shareHtml5UrlString
{
    return [[NSString alloc]initWithFormat:@"%@pGraph.html?share=1&id=%@",html_share,self.youchiId];
}

- (YCShareType)shareType
{
    return YCShareTypeYouChi;
}
@end
