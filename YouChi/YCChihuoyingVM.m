//
//  YCChihuoyingVM.m
//  YouChi
//
//  Created by sam on 15/5/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCChihuoyingVM.h"
#import "YCViewModel+Logic.h"
#import "YCCellManagerFrame.h"
#import "YCViewInfo.h"
#import "UIView+YC.h"

@implementation YCChihuoyingVM
- (void)dealloc{
    //ok
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.modelsProxy?[super numberOfItemsInSection:section]:0;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCChihuoyingM_1_2 *m = [self modelForItemAtIndexPath:indexPath];
    return m.cellHeight;
}


- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    YCChihuoyingM_1_2 *m = [self modelForItemAtIndexPath:indexPath];
    return m.cellId;
}

- (void)onSetupHeights:(NSArray *)models width:(CGFloat)width
{
    CGFloat w;
    for (YCChihuoyingM_1_2 *m in models) {
        w = width = SCREEN_WIDTH;
        switch (m.youchiType.intValue) {
            case YCCheatsTypeYouChi:
            {
                NSMutableAttributedString *text = [NSMutableAttributedString new];
                if (m.materialName == nil) {
                    m.materialName = @"";
                }
                
                NSMutableAttributedString *materialName = [[NSMutableAttributedString alloc]initWithString:m.materialName];
                [materialName appendString:@"\n"];
                materialName.font = KFont(kFontYouChiTitle);
                materialName.lineSpacing = 10;
                if (m.desc == nil) {
                    m.desc = @"";
                }
                NSMutableAttributedString *desc = [[NSMutableAttributedString alloc]initWithString:m.desc];
                desc.font = KFont(kFontYouChiContent);
                desc.color = [UIColor colorWithHex:0x000000];
                desc.lineSpacing = 4;
                
                [text appendAttributedString:materialName];
                [text appendAttributedString:desc];
                
                YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(w, HUGE) insets:UIEdgeInsetsMake(8, 15, 8, 15)];
                tc.maximumNumberOfRows = 5;
                tc.truncationType = YYTextTruncationTypeEnd;
                
                
                m.textLayout = [YYTextLayout layoutWithContainer:tc text:text];
                
                CGFloat h = 50+w*3/4+w*5/32+20+m.textLayout.textBoundingSize.height+42;
                if (m.recipeList.count>0) {
                    h += 80;
                }
                h += 10;
                m.cellHeight = h;
                m.cellId = cell1;
            }
                break;
            case YCCheatsTypeRecipe:
            {
                m.cellHeight = w*3/4.2+50+[m.name heightForFontSize:16 andWidth:w-15-15]+15+42+10;
                m.cellId = cell2;
            }
                break;
            case YCCheatsTypeAd:
            {
                m.cellHeight = DAMAI_RATIO_2(kScreenWidth, m.imageWidth, m.imageHeight)+36;
                m.cellId = cell3;
            }
                break;
            case YCCheatsTypeUserList:
            {
                m.cellHeight = m.userList.count*58+37+10;
                m.cellId = cell4;
            }
                break;
            default:
                //NSAssert(NO, @"无这种类型的cell");
                break;
        }
    }

}


#pragma mark--获取吃货营列表，随手拍则有youchiPhotoList,分享果单和跟做果单则有recipe对象。
- (RACSignal *)mainSignal
{
    WSELF;
    NSDictionary *param = @{kToken:[YCUserDefault currentToken]} ;
    NSString *path = self.urlString;

    
    return [[ENGINE POST_shop_array:path parameters:param parseClass:[YCChihuoyingM_1_2 class] pageInfo:self.pageInfo]doNext:^(NSArray *x) {
        SSELF;
       
        [self onSetupHeights:x width:kScreenWidth];
        if (self.nextBlock) {
            self.nextBlock(x);
        }
        
    }];
}


#pragma mark -换一批
- (RACSignal *)onChangeGuysSignal:(NSIndexPath *)index
{
    WSELF;
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken]
                            } ;
    NSString *path = apiCGetRandom;
    return [[ENGINE POST_shop_array:path parameters:param parseClass:[YCMeM class] parseKey:nil pageInfo:nil]doNext:^(id x) {
        SSELF;
        YCChihuoyingM_1_2 *m = [self modelForItemAtIndexPath:index];
        m.userList = x;
    }];
}

- (RACSignal *)likeByByModel:(YCChihuoyingM_1_2 *)m
{
    BOOL isLike = !m.isLike.boolValue;
    return [[self likeById:m.Id isLike:isLike type:m.youchiType.intValue]doNext:^(NSNumber *value) {
        m.isLike = @(isLike);
        m.likeCount = value;
    }];
}

- (RACSignal *)favoriteByModel:(YCChihuoyingM_1_2 *)m
{
    BOOL isFavorite = !m.isFavorite.boolValue;
    return [[self favoriteById:m.Id isFavorite:isFavorite type:m.youchiType.intValue]doNext:^(NSNumber *value) {
        m.isFavorite = @(isFavorite);
        m.favoriteCount = value;
    }];
}
@end

@implementation YCChihuoyingOtherVM
- (void)dealloc{
    //ok
}

- (NSString *)title
{
    return @"相关秘籍";
}

#pragma mark--获取吃货营列表，随手拍则有youchiPhotoList,分享果单和跟做果单则有recipe对象。
- (RACSignal *)mainSignal
{
    WSELF;
    
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken],
                            @"youchiId":self.Id,
                            } ;
    
    return [[ENGINE POST_shop_array:apiCRecipeList parameters:param parseClass:[YCChihuoyingM_1_2 class] parseKey:@"recipeList" pageInfo:self.pageInfo ]doNext:^(NSArray *x) {
        SSELF;
        for (YCChihuoyingM_1_2 *m in x) {
            m.youchiType = @(YCCheatsTypeRecipe);
        }
        [self onSetupHeights:x width:kScreenWidth];
        if (self.nextBlock) {
            self.nextBlock(x);
        }
        
    }];
}



@end