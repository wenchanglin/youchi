//
//  YCChihuoyingModel.h
//  YouChi
//
//  Created by sam on 15/5/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModel.h"
#import <YYKit/YYKit.h>
//@class YCChihuoyingRecipeM;
//
//@interface YCChihuoyingM : YCBaseImageModel
//@property (nonatomic,strong) NSURL *userImage,*html5Path;
//@property (nonatomic,strong) NSString *userName,*levelName,*difficulty;
//@property (nonatomic,strong) NSNumber *commentCount,*likeCount,*youchiType,*stepCount,*maxSpendTime,*clickLike,*recipeId;
//@property (nonatomic,strong) NSArray *youchiLikeList,*youchiPhotoList,*recipeMaterialList,*recipeStepList,*recipeCommentList;
//@property (nonatomic,strong) YCChihuoyingRecipeM *recipe;
//
//
//@property (nonatomic,readonly) NSString *chihuo_genzuo;
//@property (nonatomic,readonly) NSString *chihuo_suishoupai;
//@property (nonatomic,readonly) NSString *chihuo_fenxiang;
//
//@property (nonatomic,readonly) NSURL *shareImageUrl;
//@end
//
//
//
//

@interface YCChihuoyingRecipeM : YCBaseImageModel
@property (nonatomic,strong) NSString *categoryName,*difficulty,*effect,*tips,*userName,*levelName;
@property (nonatomic,strong) NSNumber *commentCount,*likeCount,*youchiType,*stepCount,*isFavorite,*clickLike;
@property (nonatomic,strong) NSArray *youchiLikeList,*youchiPhotoList,*recipeMaterialList,*recipeStepList,*recipeCommentList;
@property (nonatomic,strong) NSURL *html5Path,*userImage;
@end



@interface YCChihuoyingM_1_2 : YCBaseImageModel
@property (nonatomic,strong) NSString *userImage,*userName,*signature;
@property (nonatomic,strong) NSString *html5Path,*originalAction,*cellId;
@property (nonatomic,strong) NSString *levelName,*difficulty,*title,*comment,*totalFraction,*area,*city,*locationDesc,*materialName,*filePath,*fileId,*data,*name;
@property (nonatomic,strong) NSNumber *commentCount,*likeCount,*favoriteCount,*stepCount,*pv,*isLike,*isFavorite,*recipeCount,*userId;
@property (nonatomic,strong) NSArray *youchiPhotoList,*userList,*youchiMaterialList,*youchiStepList ,*recipeList,*recipeMaterialList,*recipeStepList,*newsList,*videoList,*youchiList,*content;
@property(nonatomic,strong) NSMutableArray *youchiCommentList,*youchiLikeList,*recipeLikeList,*recipeCommentList,*videoCommentList,*videoLikeList;
@property (nonatomic,strong) NSNumber * youchiType,*minSpendTime,*maxSpendTime,*replyUserId,*replyCommentId;

@property (nonatomic,assign) NSUInteger selectedIndex;
@property (nonatomic,readonly) NSString * replyUserName;

@property (nonatomic,strong) YYTextLayout *textLayout;
@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) NSAttributedString *ui_desc;
@end


@interface YCMaterialList : YCBaseImageModel
@property (nonatomic,strong) NSString *quantity;
@property (nonatomic,strong) NSString *materialName;

@end

@interface YCStepList : YCBaseImageModel
@property (nonatomic,strong) NSAttributedString *ui_desc;
@property (nonatomic,strong) YYTextLayout *layout;
@property (nonatomic,assign) CGFloat cellHeight;
@end
