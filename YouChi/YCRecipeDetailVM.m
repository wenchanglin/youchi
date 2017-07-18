//
//  YCSmallHelperTwoDetailedVM.m
//  YouChi
//
//  Created by 李李善 on 15/5/26.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRecipeDetailVM.h"
#import "YCCommentM.h"
#import <NSAttributedString-DDHTML/NSAttributedString+DDHTML.h>
@implementation YCRecipeDetailVM
@synthesize model;
- (void)dealloc{
    //ok
}



 //*/
#pragma mark -- header
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        return 40.f;
    }
    if(section==7){
        if ( [self numberOfItemsInSection:section] > 0){
            return KSectionHeight;
        }
    }
    
    return 0;
}

- (NSString *)headerIDInSection:(NSInteger)section
{
    if (section == 4) {
        return cell4;
    }
    if (section == 7) {
        return cell7;
    }
    return nil;
}

- (RACSignal *)mainSignal
{
    WSELF;
    return [[ENGINE POST_shop_object:apiCGetRecipeDetail parameters:@{kToken:[YCUserDefault currentToken],@"recipeId":self.Id} parseClass:[YCChihuoyingM_1_2 class] parseKey:nil]doNext:^(YCChihuoyingM_1_2 *x) {
        SSELF;
        [self willChangeValueForKey:KP(self.updateModel)];
        for (YCCommentM *m in x.recipeCommentList) {
            [m onSetupHeightWithWidth:kScreenWidth];
        }
        
        int count = (int)x.recipeStepList.count;
        [x.recipeStepList enumerateObjectsUsingBlock:^(YCStepList *step, NSUInteger idx, BOOL *stop) {
            NSMutableAttributedString *desc  = [[NSMutableAttributedString alloc]initWithString:@(idx+1).stringValue];
            desc.font = KFont(18);
            desc.color = UIColorHex(#eaa93b);
            
            NSMutableAttributedString *countstep = [[NSMutableAttributedString alloc]initWithString:[[NSString alloc] initWithFormat:@"/%d %@",(int)count,step.desc]];
            countstep.font = KFont(14);
            
            [desc appendAttributedString:countstep];
            
            YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, HUGE) insets:UIEdgeInsetsMake(4, 8, 4, 8)];
            YYTextLayout *layout = [YYTextLayout layoutWithContainer:tc text:desc];
            step.layout = layout;
            step.cellHeight = DAMAI_RATIO_2(kScreenWidth, step.imageWidth,step.imageHeight)+layout.textBoundingSize.height;
            
        }];

        

        NSMutableAttributedString *desc  = [[NSMutableAttributedString alloc]initWithString:x.desc];
        desc.font  = [UIFont systemFontOfSize:12];
        desc.lineSpacing = 6;
        desc.color = KBGCColor(@"#929292");
        
        YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH, HUGE) insets:UIEdgeInsetsMake(10, 21, 10, 21)];
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:tc text:desc];

        YCCellNumberBlock numberBlock = [YCCellInfo number:^NSInteger(NSInteger section) {
            return 1;
        }];
        YCCellModelBlock modelBlock = [YCCellInfo model:^id(NSIndexPath *indexPath) {
            return x;
        }];
        
        
        [self.cellInfos setArray:@[
                                   [YCCellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath *indexPath) {
            return DAMAI_RATIO_2(SCREEN_WIDTH, x.imageWidth, x.imageHeight);
        } number:numberBlock model:modelBlock],
                                   [YCCellInfo cellInfoWithId:cell1 height:^CGFloat(NSIndexPath *indexPath) {
            return 120;
        } number:numberBlock model:modelBlock],
                                   [YCCellInfo cellInfoWithId:cell2 height:^CGFloat(NSIndexPath *indexPath) {
            return layout.textBoundingSize.height;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return layout;
        }],
                                   [YCCellInfo cellInfoWithId:cell3 height:^CGFloat(NSIndexPath *indexPath) {
            return 40;
        } number:numberBlock model:modelBlock],
                                   [YCCellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath *indexPath) {
            return 40;
        } number:^NSInteger(NSInteger section) {
            return x.recipeMaterialList.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.recipeMaterialList[indexPath.row];
        }],
                                   [YCCellInfo cellInfoWithId:cell5 height:^CGFloat(NSIndexPath *indexPath) {
            YCStepList *pm = x.recipeStepList[indexPath.row];
            return pm.cellHeight;
        } number:^NSInteger(NSInteger section) {
            return x.recipeStepList.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.recipeStepList[indexPath.row];
        }],
                                   [YCCellInfo cellInfoWithId:cell6 height:^CGFloat(NSIndexPath *indexPath) {
            return 70.f;
        } number:numberBlock model:modelBlock],
                                   [YCCellInfo cellInfoWithId:cell7 height:^CGFloat(NSIndexPath *indexPath) {
            YCStepList *pm = x.recipeCommentList[indexPath.row];
            return pm.cellHeight;
        } number:^NSInteger(NSInteger section) {
            return x.recipeCommentList.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.recipeCommentList[indexPath.row];
        }],

                                   
                                   ]];

        
        self.model = x;
        self.title = self.model.name;
        self.insertFrontSection = self.cellInfos.count-1;
        [self didChangeValueForKey:KP(self.updateModel)];
    }];
}


#pragma mark -
- (RACSignal *)replySignalId:(NSNumber *)Id replyCommentId:(NSNumber *)replyCommentId replyUserId:(NSNumber *)replyUserId comment:(NSString *)comment type:(YCCheatsType)type
{
    WSELF;
    return [[super replySignalId:Id replyCommentId:replyCommentId replyUserId:replyUserId comment:comment type:YCCheatsTypeRecipe]doNext:^(YCCommentM *x) {
        SSELF;
        if (!self.model.recipeCommentList) {
            self.model.recipeCommentList = [NSMutableArray new];
        }
        [x onSetupHeightWithWidth:kScreenWidth];
        [self.model.recipeCommentList insertObject:x atIndex:0];
    }];
}

#pragma mark -
- (RACSignal *)likeById:(NSNumber *)Id isLike:(BOOL)like type:(YCCheatsType)type
{
    WSELF;
    return [[super likeById:Id isLike:like type:YCCheatsTypeRecipe]doNext:^(id x) {
        SSELF;
        __block BOOL hasMe ;
        __block NSUInteger where ;
        YCLoginUserM *user = [YCUserDefault currentUser].appUser;
        NSNumber *myId = user.Id;
        if (!self.model.recipeLikeList) {
            self.model.recipeLikeList = [NSMutableArray new];
        }
        [self.model.recipeLikeList enumerateObjectsUsingBlock:^(YCBaseUserImageModel *obj, NSUInteger idx, BOOL *stop) {
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
                [self.model.recipeLikeList insertObject:m atIndex:0];
                
            } else {
                [self.model.recipeLikeList removeObjectAtIndex:where];
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

#pragma mark -
- (RACSignal *)favoriteById:(NSNumber *)Id isFavorite:(BOOL)favorite type:(YCCheatsType)type
{
    return [super favoriteById:Id isFavorite:favorite type:YCCheatsTypeRecipe];
}

- (YCChihuoyingM_1_2 *)updateModel
{
    return self.model;
}


- (YCCheatsType)cheatsType
{
    return YCCheatsTypeRecipe;
}

- (NSString *)shareImageUrl
{
    return IMAGE_HOST_NOT_SHOP_(self.model.imagePath);
}

- (NSString *)shareHtml5UrlString
{
    return [[NSString alloc]initWithFormat:@"%@cheats.html?share=1&id=%@",html_share,self.model.Id];
}

- (YCShareType)shareType
{
    return YCShareTypeRecipe;
}
@end
