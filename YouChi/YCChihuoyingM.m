
//  YCChihuoyingModel.m
//  YouChi
//
//  Created by sam on 15/5/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCChihuoyingM.h"
#import "YCCatolog.h"
#import "YCMeM.h"
#import "YCCommentM.h"
#import "YCNewsM.h"

#import "YCVideoM.h"
//@implementation YCChihuoyingM
//- (void)dealloc{
//    //ok
//}
//
//@end


@implementation YCChihuoyingRecipeM

- (void)dealloc{
    //ok
}


@end

@implementation YCChihuoyingM_1_2
- (void)dealloc{
    //ok
}



+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"userList":[YCMeM class],
             @"newsList": [YCNewsList class],
             @"videoList":[YCVideoM class],
             @"youchiList":[YCChihuoyingM_1_2 class],
             
             
             @"youchiPhotoList":[YCBaseImageModel class],
             @"youchiMaterialList":[YCMaterialList class],
             @"youchiStepList":[YCBaseImageModel class],
             @"youchiCommentList":[YCCommentM class],
             @"youchiLikeList":[YCBaseUserImageModel class],
             @"youchiPhotoList":[YCBaseImageModel class],
             @"youchiStepList":[YCBaseImageModel class],
             
             
             
             @"videoLikeList":[YCBaseUserImageModel class],
             @"videoCommentList":[YCCommentM class],
             
             @"recipeList":[YCBaseImageModel class],
             @"recipeCommentList":[YCCommentM class],
             @"recipeLikeList":[YCBaseUserImageModel class],
             @"recipeMaterialList":[YCMaterialList class],
             @"recipeStepList":[YCStepList class],
             };
}
@end

@implementation YCMaterialList
- (void)dealloc{
    //ok
}


@end


@implementation YCStepList
@synthesize ui_desc;
-(void)dealloc{
    //    ok
    
}
@end