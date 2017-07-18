//
//  YCVideoDetailVM.h
//  YouChi
//
//  Created by 朱国林 on 15/8/11.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCChihuoyingM.h"
#import "YCVideoM.h"
#import "YCVideoVM.h"
#import "YCDetailControlVCP.h"
#import "YCCommentM.h"


@interface YCVideosDetailVM : YCVideoVM<YCDetailControlDatasource>
//commentModel 当前视频的评论(为了装当前视频的网络请求回来的评论)

@property (nonatomic,strong) NSMutableArray<YCCommentM *> *videoCommentList;
//videoModel 当前视频内容(为了装当前视频的网络请求回来的内容)
@property (nonatomic,strong) YCChihuoyingM_1_2 *videoModel;

@property (nonatomic,strong) YCCommentM *replyModel;

@property(nonatomic,assign)BOOL isUpdate;//判断时否要下载视频推荐

@property(nonatomic,strong)NSMutableArray * videoCommends;//videoCommends 装————视频评论

@property(nonatomic,strong)NSMutableArray * videoRecommends;//videoRecommends 装————视频推荐
- (RACSignal *)commentSignal;//评论请求
- (RACSignal *)recommendSignal;//推荐请求
- (instancetype)initWithModel:(YCVideoM *)m recommends:(NSMutableArray *)recommends;
@end
