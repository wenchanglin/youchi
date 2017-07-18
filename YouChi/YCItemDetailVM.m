//
//  YCItemDetailVM.m
//  YouChi
//
//  Created by sam on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCItemDetailVM.h"
#import "YCViewModel+Logic.h"

@interface YCItemDetailM ()

@end
@implementation YCItemDetailVM
@synthesize model;

- (RACSignal *)mainSignal
{
    WSELF;
    CHECK_SIGNAL(!self.Id, @"没有id");
    return [[ENGINE POST_shop_object:@"product/getProductDetailById.json" parameters:@{
                                                                                       @"productId":self.Id,
                                                                                       kToken:[YCUserDefault currentToken]} parseClass:[YCItemDetailM class] parseKey:kContent]doNext:^(YCItemDetailM *x) {
        SSELF;
        self.model = x;
        
        self.title = x.productName;
        
        //预售
        _isPresell = x.isPresell.boolValue;
        
        
        ///商品图片排序
        x.shopProductImages = [x.shopProductImages sortedArrayUsingComparator:^NSComparisonResult(YCShopProductImagesM  *_Nonnull obj1, YCShopProductImagesM  *_Nonnull obj2) {
            if (obj1.seqNo.intValue>obj2.seqNo.intValue) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        
        ///如果有视频则显示，并删除商品图片的第一张
        YCShopProductImagesM *vidieoImage = x.videoPath?x.shopProductImages.firstObject:nil;
        if (vidieoImage && x.shopProductImages.count) {
            NSMutableArray *images = x.shopProductImages.mutableCopy;
            [images removeObjectAtIndex:0];
            x.shopProductImages = images;
            x.htmlPosition -= 1;
        }
        
        YYTextLayout *textLayout = [x creatDescTextLayout];
        
        ///编辑数组（包含配送地区和商品评价）
        NSString *isShipping = x.shopShipping.isShipping.boolValue?@"可配送地区":@"不可配送地区";
        NSString *comment = [NSString stringWithFormat:@"商品评价(%d)",x.commentCount.intValue];
        NSMutableArray *titles = @[isShipping,comment].mutableCopy;
        if (x.shopPostagePolicy) {
            [titles addObject:@"邮费策略"];
        }

        
        
        YCCellNumberBlock numberBlock = [YCCellInfo number:^NSInteger(NSInteger section) {
            return 1;
        }];
        
        YCCellModelBlock modelBlock = [YCCellInfo model:^id(NSIndexPath *indexPath) {
            return x;
        }];
        
        CGFloat adHeight = DAMAI_RATIO_2(SCREEN_WIDTH, 4, 3);
        [self.cellInfos setArray: @[
                                    [YCCellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath *indexPath) {
            
            return adHeight;
        } number:numberBlock model:modelBlock],
                                    
                                    [YCCellInfo cellInfoWithId:cell1 height:^CGFloat(NSIndexPath *indexPath) {
            return 78;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            SSELF;
            return x.shopSpecs[self.selectedshopSpecIndex];
        }],
                                    
                                    [YCCellInfo cellInfoWithId:cell2 height:^CGFloat(NSIndexPath *indexPath) {
            return textLayout.textBoundingSize.height;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return textLayout;
        }],
                                    
                                    [YCCellInfo cellInfoWithId:cell3 height:^CGFloat(NSIndexPath *indexPath) {
            return 63;
        } number:numberBlock model:modelBlock],
                                    
                                    [YCCellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath *indexPath) {
            return 63;
        } number:^NSInteger(NSInteger section) {
            return x.shopSpecs.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopSpecs[indexPath.row];
        }],
                                    //／认证
                                    [YCCellInfo cellInfoWithId:cell6 height:^CGFloat(NSIndexPath *indexPath) {
            return 65;
        } number:^NSInteger(NSInteger section) {
            return x.shopProductVerifys.count>0?1:0;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopProductVerifys;
        }],
                                    
                                    [YCCellInfo cellInfoWithId:cell7 height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:^NSInteger(NSInteger section) {
            return 1;
        } model:modelBlock],
                                    ///配送，评价，邮费
                                    [YCCellInfo cellInfoWithId:cell8 height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:^NSInteger(NSInteger section) {
            return titles.count;
        } model:^id(NSIndexPath *indexPath) {
            return titles[indexPath.row];
        }],
                                    
                                    [YCCellInfo cellInfoWithId:cell9 height:^CGFloat(NSIndexPath *indexPath) {
            return 57;
        } number:numberBlock model:nil],
                                    
                                    [YCCellInfo cellInfoWithId:cell10 height:^CGFloat(NSIndexPath *indexPath) {
            return 64;
        } number:^NSInteger(NSInteger section) {
            return 1;
        }],
                                    //视频
                                    [YCCellInfo cellInfoWithId:cell5 height:^CGFloat(NSIndexPath *indexPath) {
            
            
            CGFloat h = DAMAI_RATIO_2(SCREEN_WIDTH, vidieoImage.width,vidieoImage.height);
            return h>0?h: DAMAI_RATIO_2(SCREEN_WIDTH, 389,341);
        } number:^NSInteger(NSInteger section) {
            return vidieoImage?1:0;
        } model:^id(NSIndexPath *indexPath) {
            return vidieoImage;
        }],
                                    //图片
                                    [YCCellInfo cellInfoWithId:cell11 height:^CGFloat(NSIndexPath *indexPath) {
            
            YCShopProductImagesM *m = x.shopProductImages[indexPath.row];
            
            CGFloat h = DAMAI_RATIO_2(SCREEN_WIDTH, m.width,m.height);
            return h>0?h: DAMAI_RATIO_2(SCREEN_WIDTH, 389,341);
            
        } number:^NSInteger(NSInteger section) {
            return x.shopProductImages.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopProductImages[indexPath.row];
        }],
                                    
                                    [YCCellInfo cellInfoWithId:cell12 height:^CGFloat(NSIndexPath *indexPath) {
            return 50;
        } number:^NSInteger(NSInteger section) {
            return 1;
        }],
                                    [YCCellInfo cellInfoWithId:cell13 height:^CGFloat(NSIndexPath *indexPath) {
            return (kScreenWidth-2)/2+50+50;
        } number:^NSInteger(NSInteger section) {
            return x.shopProductRecommends.count/2+x.shopProductRecommends.count%2;
        } model:^id(NSIndexPath *indexPath) {
            NSUInteger loc = 2*indexPath.row ;
            NSUInteger end = MIN(x.shopProductRecommends.count , loc+2);
            return  [x.shopProductRecommends subarrayWithRange:NSMakeRange(loc, end-loc)];
            
        }]
                                    ]];
        
        self.model = x;
        [self updateSelectCount];
    }];
}

- (RACSignal *)cartNumberSignal
{
    WSELF;
    return [[RACObserve(self, model) filter:^BOOL(id value) {
        if (!value || !USER_DEFAULT.isCurrentUserValid) {
            return NO;
        }
        return YES;
    }] flattenMap:^RACStream *(id value) {
        SSELF;
        return [self getMyCartList];
    }];
}


- (BOOL)isYoumiPay
{
    return self.youMiModel && self.youMiModel.isMoneyPay.boolValue == NO;
}

- (NSNumber *)specId
{
    return [self.model.shopSpecs[self.selectedshopSpecIndex] specId]?:@(0);
}

/**
 *  更新商品数量
 */
- (void)updateSelectCount
{
    if (self.sum >0) {
        self.count = 1;
    } else {
        self.count = 0;
    }
}

/**
 *  这里必须要将main请求回来的数据 X－>self.model（否则sum永远为0）
 *
 *  @return 商品现存的数量
 */
- (NSInteger)sum
{
    if (self.model.shopSpecs.count==0) {
        return 0;
    }
    YCShopSpecM *specsM = self.model.shopSpecs[self.selectedshopSpecIndex];
    return specsM.specQty.intValue;
}

- (NSString *)videoPath
{
    return self.model.videoPath;
}

- (RACSignal *)presellSignal
{
    NSString *path = @"orderPresell/getVirtualOrderPresell.json";
    NSMutableDictionary *param = @{@"productId":self.Id,@"productSpecId":self.specId,@"qty":@(1),kToken:[YCUserDefault currentToken],}.mutableCopy;
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [[ENGINE POST_shop_object:@"orderPresell/getVirtualOrderPresell.json" parameters:param parseClass:[YCAboutGoodsM class] parseKey:kContent ] doNext:self.nextBlock];
}


/**
 *  商品图片排序
 *
 *  @param Images 图片数组
 */
-(void)onSequenceShopProductImages:(NSArray *)images
{
    images = [images sortedArrayUsingComparator:^NSComparisonResult(YCShopProductImagesM  *_Nonnull obj1, YCShopProductImagesM  *_Nonnull obj2) {
        return obj1.seqNo.intValue>obj2.seqNo.intValue;
    }];
}


/**
 *  编辑数组（包含配送地区和商品评价）
 *
 *  @param shopShipping 商品配送对象
 *  @param count        商品评论数
 *
 *  @return 数组
 */
-(NSArray *)onShopShipping:(YCShopSpecs*)shopShipping ShopComment:(int)count
{
    NSString *isShipping = shopShipping.isShipping.boolValue?@"可配送地区":@"不可配送地区";
    return @[[NSString stringWithFormat:@"商品评价(%d)",count], isShipping];
}


@end
