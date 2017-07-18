//
//  YCYouChiShopVM.m
//  YouChi
//
//  Created by 李李善 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouChiShopVM.h"

@implementation YCYouChiShopVM

//*
- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSections
{
    return self.modelsProxy.count>0? self.modelsProxy.count+1:0;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    YCYouChiShopM *m = [self modelForItemAtIndexPath:indexPath];
    YCStyleType type = m.styleType.intValue;
    if (indexPath.section == 0) {
        return cell7;
    } else if (type == YCStyleTypeAd) {
        return cell8;
    } else if (type == YCStyleTypeNav) {
        return cell9;
    }
    
    
    //c1 - c4
    return self.cellIds[type];
    
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //搜索
    if (indexPath.section == 0) {
        return 47;
    }
    YCYouChiShopM *m = [self modelForItemAtIndexPath:indexPath];
    YCStyleType type = m.styleType.intValue;
    //广告，四个按钮
    if (type == YCStyleTypeAd) {
        return DAMAI_RATIO(SCREEN_WIDTH, 400);
    } else if (type == YCStyleTypeNav) {
        CGFloat h = DAMAI_RATIO(SCREEN_WIDTH, 256);
        if (self.newsTextLayout) {
            h += self.newsTextLayout.textBoundingSize.height;
        }
        return h;
    }
    //商品图片
    NSString *cellId = [self cellIDAtIndexPath:indexPath];
    CGFloat add = 2;
    YCShopRecommendSubitems *srs0 = m.shopRecommendSubitems.firstObject;
    CGFloat h = 0;
    if (cellId == cell1) {
        h = DAMAI_RATIO_2(SCREEN_WIDTH, srs0.width,srs0.height);
        if (h>0) {
            return h+add;
        }
        
    }
    
    if (cellId == cell4) {
        YCShopRecommendSubitems *srs1 = m.shopRecommendSubitems[1];
        YCShopRecommendSubitems *srs3 = m.shopRecommendSubitems.lastObject;
        float sum = srs1.width+srs3.width;
        float w = DAMAI_RATIO_2(SCREEN_WIDTH, sum, srs3.width);
        h += DAMAI_RATIO_2(w, srs3.width, srs3.height);
        if (h>0) {
            return h+add;
        }
    }
    
    h = DAMAI_RATIO_2(SCREEN_WIDTH/m.shopRecommendSubitems.count, srs0.width, srs0.height);
    if (h>0) {
        return h+add;
    }
    
    //如果数据得到的高度为0则用大麦定义的高度
    return DAMAI_RATIO_2(SCREEN_WIDTH, 723, 408)+add;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }
    
    YCYouChiShopM *m = self.modelsProxy[indexPath.section-1];
    return m;
}


- (RACSignal *)mainSignal
{
    NSDictionary *param = @{@"version":@(2)};
    //一次性加载
    self.pageInfo.pageSize = 100;
    return [[[ENGINE POST_shop_array:@"home/getHomeList.json" parameters:param parseClass:[YCYouChiShopM class] pageInfo:self.pageInfo] retry:3]doNext:^(NSArray<YCYouChiShopM* > *x) {
        
        if (self.nextBlock) {
            
            [self setupNewsTextLayoutFrom:x];
            self.insertBackSection = self.numberOfSections;
            self.nextBlock(x);
            self.pageInfo.loadmoreId = @(0);
        }
    }];
}

- (RACSignal *)lastCouponCreat
{
    NSMutableDictionary *param = @{
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    NSString *path = @"coupon/lastCouponCreat.json";
    
    return [[ENGINE POST_shop_object:path parameters:param parseClass:[YCLastCouponAndOrder class] parseKey:kContent]doNext:^(YCLastCouponAndOrder *x) {
        
        YCCache *cache =  [YCCache sharedCache];
        
        NSString *lastCouponCreatDate = [cache.dataBase objectForKey:YCLastCouponCreatDate];
        NSString *lastOrderDate = [cache.dataBase objectForKey:YCLastOrderDate];
        
        // 优惠劵
        if (x.lastCouponCreatDate.integerValue > lastCouponCreatDate.integerValue) {
            // 有最新优惠劵
            [cache.dataBase setObject:@(1) forKey:YCCouponStatueSave];
            
            
        }else if (x.lastCouponCreatDate.integerValue < lastCouponCreatDate.integerValue){
            
            [cache.dataBase setObject:@(0) forKey:YCCouponStatueSave];
        }
        
        // 订单
        if (x.lastOrderDate.integerValue > lastOrderDate.integerValue) {
            
            [cache.dataBase setObject:@(1) forKey:YCOrderStatueSave];
            
        }else if (x.lastOrderDate.integerValue < lastOrderDate.integerValue){
            
            [cache.dataBase setObject:@(0) forKey:YCOrderStatueSave];
        }
        
        
        [cache.dataBase setObject:[NSString stringWithFormat:@"%@",x.lastCouponCreatDate] forKey:YCLastCouponCreatDate];
        [cache.dataBase setObject:[NSString stringWithFormat:@"%@",x.lastOrderDate] forKey:YCLastOrderDate];
    }];
}

- (void)setupNewsTextLayoutFrom:(NSArray<YCYouChiShopM *> *)x
{
    if (!x) {
        self.newsTextLayout = nil;
        return;
    }
    
    for (YCYouChiShopM *m in x) {
        if (m.styleType.intValue == YCStyleTypeNav && m.shopFunds) {
            
            UIFont *minf = KFont(14);
            UIFont *maxf = KFont(22);
            NSMAString *newsStr = [NSMAString new];
            
            NSMAString *title = NSMAString_initWithString(m.shopFunds.fundsTitle);
            [title appendString:@"\n"];
            title.font = minf;
            title.color = [UIColor lightGrayColor];
            
            NSMAString *desc = NSMAString_initWithString(m.shopFunds.balance);
           
            desc.font = maxf;
            desc.color = [UIColor orangeColor];
            NSMAString *yuan = NSMAString_initWithString(@"元");
            yuan.attributes = title.attributes;
            [desc appendAttributedString:yuan];
             [desc appendString:@"\n"];
            
            NSMAString *link = NSMAString_initWithString(@"查看活动详情");
            link.attributes = title.attributes;
            UIImage *img = IMAGE(@"结算与发货规则");
            NSMAString *to = [NSMAString attachmentStringWithContent:img contentMode:UIViewContentModeScaleAspectFit attachmentSize:img.size alignToFont:minf alignment:YYTextVerticalAlignmentCenter];
            [link appendString:@" "];
            [link appendAttributedString:to];
            [link appendString:@"\n"];
            
            [link setTextHighlightRange:link.rangeOfAll color:nil backgroundColor:[UIColor grayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [[NSNotificationCenter defaultCenter]postNotificationName:YCYouChiShopNewsTapNotification object:containerView];
            }];
            
            
            [newsStr appendAttributedString:title];
            [newsStr appendAttributedString:desc];
            [newsStr appendAttributedString:link];
            newsStr.lineSpacing = 4;
            YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH, HUGE) insets:UIEdgeInsetsMake(4, 20, 4, 20)];
            YYTextLayout *tl = [YYTextLayout layoutWithContainer:tc text:newsStr];
            
            
            self.newsTextLayout = tl;
            
            break;
        }
    }
}

- (RACSignal *)popWindowSignal
{
    return [ENGINE POST_shop_array:@"/home/getCPMs.json" parameters:nil parseClass:[YCYouChiShopPopM class] pageInfo:nil];
}
@end
