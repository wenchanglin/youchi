//
//  YCMySecretBookVM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCWorksRecipeVM.h"
#import "YCViewModel+Logic.h"
@implementation YCWorksRecipeVM
-(void)dealloc{
    //    ok
    
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell2;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    return [super heightForRowAtIndexPath:indexPath width:width] ;
    
}


- (RACSignal *)mainSignal
{
    WSELF;
    return [[ENGINE POST_shop_array:apiGetMyRecipeShareList parameters:@{kToken:[YCUserDefault currentToken],} parseClass:[YCChihuoyingM_1_2 class] parseKey:@"recipeList" pageInfo:self.pageInfo]doNext:^(NSArray *x) {
        SSELF;
        for (YCChihuoyingM_1_2 *m in x) {
            m.youchiType = @(YCCheatsTypeRecipe);
        }
        [self onSetupHeights:x width:kScreenWidth];
        super.nextBlock(x);
    }];
}

- (RACSignal *)likeById:(NSNumber *)Id isLike:(BOOL)like type:(YCCheatsType)type
{
    return [super likeById:Id isLike:like type:YCCheatsTypeRecipe];
}
@end
