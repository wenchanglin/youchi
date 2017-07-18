//
//  YCVideoDetailVM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/11.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCVideosDetailVM.h"
#import <NSAttributedString-DDHTML/NSAttributedString+DDHTML.h>
@implementation YCVideosDetailVM
@synthesize model;
- (void)dealloc
{
//OK
}


//m:当前点击视屏的model  recommends:当前点击视屏model所在的数组
- (instancetype)initWithModel:(YCVideoM *)m recommends:(NSMutableArray *)recommends
{
    self = [super init];
    if (self) {
        self.videoRecommends = [NSMutableArray array];
        if(recommends != nil ||recommends.count!=0)
        {
            [self.videoRecommends addObjectsFromArray:recommends];
            [self.videoRecommends removeObject:m];
        }
        self.Id =m.Id;
        self.title =m.title;
       
    }
    return self;
}


- (instancetype)initWithModel:(YCChihuoyingM_1_2 *)aModel
{
    self = [super init];
    if (self) {
        self.videoRecommends = [NSMutableArray array];
        self.Id = aModel.Id;
        self.title = aModel.title;
    }
    return self;
}

- (NSInteger)insertFrontSection
{
    return 4;
}
#pragma mark---- 区的数量
- (NSInteger)numberOfSections{

    return self.videoModel?5:0;
}
#pragma mark---- 单元格的数量
- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    if (section == 3) {
        return self.videoRecommends.count;
    }
    if (section == 4) {
        return self.videoCommentList.count;
    }
    return 1;
}
#pragma mark---- 返回cell
- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return cell1;
        }
            break;
        case 1:
        {

            return cell2;
        }
            break;
        case 2:
        {

            return cell3;
        }
            break;
        case 3:
        {
            
            return cell4;
        }
            break;
            
        default:
            return cell5;
            break;
    }

    return nil;
}

#pragma mark---- 高度
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width{
    
    switch (indexPath.section) {
        case 0:
        {
            YCChihuoyingM_1_2 *m = self.videoModel;
            return DAMAI_RATIO_2(SCREEN_WIDTH, m.imageWidth, m.imageHeight);
        }
            break;
        case 1:
        {
#warning mark--->>网络请求后，无法更加内容来计算单元格的高度
            YCChihuoyingM_1_2 *m = self.videoModel;
            return [m.desc heightForFontSize:12 andWidth:width-16.f-16.f]+40.f+11.f+35.f;
        }
            break;
        case 2:
        {
          return 66.f;
        }
            break;
        case 3:
        {
            return 119.f;
        }  break;

            
        default:
            return 70.f;
            break;
    }
    return 60.f;
}
#pragma mark---- 返回model
- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return self.videoRecommends[indexPath.row];
    }
    if (indexPath.section == 4) {
        return self.videoCommentList[indexPath.row];
    }
    return self.videoModel;
}



#pragma mark---- 视频信息
- (RACSignal *)mainSignal{
    WSELF;
    return [[ENGINE POST_shop_object:apiVideoDetail parameters:@{@"likePageSize":@10,@"videoId":self.Id } parseClass:[YCChihuoyingM_1_2 class] parseKey:nil]doNext:^(YCChihuoyingM_1_2 *x) {
         NSString *total = !x.totalFraction?@"0":[NSString stringWithFormat:@"%.1f",[x.totalFraction intValue] / 10.0 ];
        NSString *date = [x.createdDate substringToIndex:10];
        x.data= [NSString stringWithFormat:@"评分:%@  /  播放次数:%@  /  时间:%@",total,x.pv,date];
        
    
        SSELF;
        [self willChangeValueForKey:KP(self.updateModel)];
        self.videoModel = x;
        self.title = x.title;
        
        [self didChangeValueForKey:KP(self.updateModel)];
    }];
}
#pragma mark---- 视频推荐
-(RACSignal *)recommendSignal
{
    WSELF;
    NSDictionary *param = @{kToken:[YCUserDefault currentToken],@"videoId":self.Id} ;
    return [[ENGINE POST_shop_array:self.urlString parameters:param parseClass:[YCVideoM class] parseKey:@"videoList" pageInfo:self.pageInfo]doNext:^(id x){
        SSELF;
        self.videoRecommends = x;
        for (YCVideoM *m  in self.videoRecommends) {
            m.playTime = [NSString stringWithFormat:@"时间 %@",m.playTime];
            if ([m.Id intValue] ==[self.Id intValue]) {
                [self.videoRecommends removeObject:m];
            }
            
            
        }
    }];
}


#pragma mark---- 视频评论接口
- (RACSignal *)commentSignal{
    WSELF;
    return [[RACObserve(self, videoModel) ignore:nil]flattenMap:^RACStream *(id value) {
        return [[ENGINE POST_shop_array:apiVideoComment parameters:@{@"videoId":self.Id} parseClass:[YCCommentM class] parseKey:@"videoCommentList"  pageInfo:self.pageInfo ]doNext:^(NSArray<YCCommentM *> *commentList) {
            SSELF;
            self.videoCommentList = [NSMutableArray new];
            [self.videoCommentList  setArray:commentList];
            for (YCCommentM *m in commentList) {
                [m onSetupHeightWithWidth:kScreenWidth];
            }
        }];
    }];
}
#pragma mark---- 点赞
- (RACSignal *)likeById:(NSNumber *)Id isLike:(BOOL)like type:(YCCheatsType)type
{
    WSELF;
    return [[super likeById:Id isLike:like type:YCCheatsTypeVideo] doNext:^(id x) {
        SSELF;
        __block BOOL hasMe ;
        __block NSUInteger where ;
        YCLoginUserM *user = [YCUserDefault currentUser].appUser;
        NSNumber *myId = user.Id;
        if (!self.videoModel.videoLikeList) {
            self.videoModel.videoLikeList = [NSMutableArray new];
        }
        [self.videoModel.videoLikeList enumerateObjectsUsingBlock:^(YCBaseUserImageModel *obj, NSUInteger idx, BOOL *stop) {
            if (myId.intValue == obj.userId.intValue) {
                hasMe = YES;
                where = idx;
                *stop = YES;
            }
        }];
        
        
        @try {
            if (like) {
                YCBaseUserImageModel *m = [YCBaseUserImageModel new];
                m.userImage = user.imagePath;
                m.userId = myId;
                [self.videoModel.videoLikeList insertObject:m atIndex:0];
                
            } else {
                [self.videoModel.videoLikeList removeObjectAtIndex:where];
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

#pragma mark---- 收藏
- (RACSignal *)favoriteById:(NSNumber *)Id isFavorite:(BOOL)favorite type:(YCCheatsType)type
{
    return [super favoriteById:Id isFavorite:favorite type:YCCheatsTypeVideo];
}


- (RACSignal *)replySignalId:(NSNumber *)Id replyCommentId:(NSNumber *)replyCommentId replyUserId:(NSNumber *)replyUserId comment:(NSString *)comment type:(YCCheatsType)type{
    WSELF;
    return [[super replySignalId:Id replyCommentId:replyCommentId replyUserId:replyUserId comment:comment type:YCCheatsTypeVideo]doNext:^(YCCommentM *x) {
        SSELF;
        if (x) {
            if (!self.videoCommentList) {
                self.videoCommentList = [NSMutableArray new];
            }
            [x onSetupHeightWithWidth:kScreenWidth];
            [self.videoCommentList insertObject:x atIndex:0];
        }
    }];
}

#pragma mark -

- (YCChihuoyingM_1_2 *)updateModel
{
    return self.videoModel;
}

- (YCCheatsType)cheatsType
{
    return YCCheatsTypeVideo;
}

- (NSString *)shareImageUrl
{
    return self.videoModel.imagePath;
}

- (NSString *)shareHtml5UrlString
{
    return [[NSString alloc]initWithFormat:@"%@video.html?share=1&id=%@",html_share,self.videoModel.Id];
}

- (YCShareType)shareType
{
    return YCShareTypeVideo;
}
@end
