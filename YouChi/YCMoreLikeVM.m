//
//  YCVideoMoreLikeVM.m
//  YouChi
//
//  Created by 朱国林 on 15/9/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMoreLikeVM.h"
#import "YCChihuoyingM.h"
#import "YCFollowsM.h"
#import "YCChihuoyingM.h"
#import "YCMoreLikeM.h"

@implementation YCMoreLikeVM
-(void)dealloc{
    //    ok
    
}
- (instancetype)initWithId:(id)aId withMoreTepy:(YCMoreLikeType)type{

    if (self = [super init]) {
        self.Id = aId;
        self.type = type;
    }
    return self;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return  cell1;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

- (RACSignal *)mainSignal{
    
    NSString *apiUrl;
    NSString *parameter;
    
    switch (self.type) {
        case YCMoreLikeTypeVideo:
        {
            apiUrl = apiGetVideoMoreLikeList;
            parameter = @"videoId";
        }
            break;
        case YCMoreLikeTypeYouChi:
        {
            apiUrl = apiGetyouchiMoreLikeList;
            parameter = @"youchiId";
        }
            break;
        case YCMoreLikeTypeRecipe:
        {
            apiUrl = apiGetrecipeMoreLikeList;
            parameter = @"recipeId";
        }
        default:
            break;
    }
    
    return [[ENGINE POST_shop_array:apiUrl parameters:@{
                                                        kToken:[YCUserDefault currentToken],
                                                        parameter:self.Id,
                                                        } parseClass:[YCMoreLikeM class] parseKey:@"userLikeList" pageInfo:self.pageInfo]doNext:^(NSArray *x) {
        self.title = [NSString stringWithFormat:@"%d人觉得很赞",self.totalNum];
        for (YCMoreLikeM *m in x) {
            m.createdDate = [m.createdDate substringToIndex:10];
        }
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];
}

@end

