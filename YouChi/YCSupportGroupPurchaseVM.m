//
//  YCSupportGroupPurchaseVM.m
//  YouChi
//
//  Created by 李李善 on 16/5/17.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSupportGroupPurchaseVM.h"

@implementation YCSupportGroupPurchaseVM
-(RACSignal *)mainSignal{
    
    WSELF;
    return [[ENGINE POST_shop:@"groupBuy/getOneGroupBuyProductDetails.json" parameters:self.parameters parseClass:[YCSupportGroupPurchaseM class] parseKey:nil pageInfo:nil]doNext:^(YCSupportGroupPurchaseM* x) {
        
        self.title = x.productName;
        //TODO:将id在这里改了一下
        self.Id = x.productId;
        self.productId = x.productId;
        
        YCCellNumberBlock numberBlock = [YCCellInfo number:^NSInteger(NSInteger section) {
            return 1;
        }];
        YCCellModelBlock modelBlock = [YCCellInfo model:^id(NSIndexPath *indexPath) {
            return x;
        }];
        
        ///编辑开团人字符串
        x.openGroupMan = [self onOpenGroupPeopleWithNumber:[x.sponsorCount integerValue]];
        ///编辑参团人字符串
        x.joinInGroupMan = [self onJoinPeopleWithNumber:[x.joinCount integerValue]];
        
        
        x.brief = x.productName;
        YYTextLayout *textLayout = [x creatDescTextLayout];
        
        NSArray *colorS =@[KBGCColor(@"#F39C11"),KBGCColor(@"#58D68D"),KBGCColor(@"#E84C3D")];
        
        
        ///编辑数组（包含配送地区和商品评价）
        NSArray *titles = [self onShopShipping:x.shopShipping ShopComment:x.commentCount.intValue];
        ///商品图片排序
        x.shopProductImages = [x sortShopProductImagesByImages:x.shopProductImages];
        
        
        SSELF;
        [self.cellInfos setArray:@[
        //自动播放
        [YCCellInfo cellInfoWithId:KGroupC0 height:^CGFloat(NSIndexPath *indexPath) {
            CGFloat h = DAMAI_RATIO_2(SCREEN_WIDTH, 4, 3);
            return h;
        } number:numberBlock model:modelBlock],
                                   
                                   //参团人/开团数
                                   [YCCellInfo cellInfoWithId:cell1 height:^CGFloat(NSIndexPath *indexPath) {
            return 78;
        } number:numberBlock model:modelBlock],
                                   
                                   
                                   //详细描述
                                   [YCCellInfo cellInfoWithId:KGroupC3 height:^CGFloat(NSIndexPath *indexPath) {return textLayout.textBoundingSize.height+2*YCCreateGroupPurchaseTop+7;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return textLayout;
        }],
                                   
                                   //数量/价格
                                   [YCCellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath *indexPath) {
            return 63;
        } number:numberBlock model:modelBlock],
                                   
                                   //规格
                                   [YCCellInfo cellInfoWithId:cell5 height:^CGFloat(NSIndexPath *indexPath) {
            return 45.f;
        } number:^NSInteger(NSInteger section) {
            return x.shopSpecs.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopSpecs[indexPath.row];
        }],
                                   
                                   //商品认证
                                   [YCCellInfo cellInfoWithId:KGroupC8 height:^CGFloat(NSIndexPath *indexPath) {
            return 65;
        } number:^NSInteger(NSInteger section) {
            return x.shopProductVerifys.count>0?1:0;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopProductVerifys;
            
        }],
                                   
                                   //攻略
                                   [YCCellInfo cellInfoWithId:KGroupC6 height:^CGFloat(NSIndexPath *indexPath) {
            return 50;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return @"团拼攻略";
        }],
                                   
                                   //攻略内容
                                   [YCCellInfo cellInfoWithId:KGroupC7 height:^CGFloat(NSIndexPath *indexPath) {
            return 40;
        } number:^NSInteger(NSInteger section) {
            
            return x.shopProductStrategys.count;
        } model:^id(NSIndexPath *indexPath) {
            YCShopProductStrategyModel *m = x.shopProductStrategys[indexPath.row];
            
            return m;
        }],
                                   
                                   //团拼玩法
                                   [YCCellInfo cellInfoWithId:KGroupC9 height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:numberBlock model:nil],
                                   //团拼玩法内容
                                   [YCCellInfo cellInfoWithId:KGroupC10 height:^CGFloat(NSIndexPath *indexPath) {
            return 112.f;
        } number:numberBlock],
                                   
                                   
                                   //发货信息
                                   [YCCellInfo cellInfoWithId:KGroupC12 height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:numberBlock model:nil],
                                   //商品评价，配送地址
                                   [YCCellInfo cellInfoWithId:KGroupC13 height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:^NSInteger(NSInteger section) {
            return titles.count;
        } model:^id(NSIndexPath *indexPath) {
            return titles[indexPath.row];
        }],
                                   //往上拉动
                                   [YCCellInfo cellInfoWithId:KGroupC14 height:^CGFloat(NSIndexPath *indexPath) {
            return 57;
        } number:numberBlock model:nil],
                                   //图文详情
                                   [YCCellInfo cellInfoWithId:KGroupC15 height:^CGFloat(NSIndexPath *indexPath) {
            return 64;
        } number:^NSInteger(NSInteger section) {
            return 1;
        }],
                                   //图片
                                   [YCCellInfo cellInfoWithId:KGroupC16 height:^CGFloat(NSIndexPath *indexPath) {
            
            YCShopProductImagesM *m = x.shopProductImages[indexPath.row];
            //增加了高度之后图片在滚动的时候就不会挡住 图片上下方的控件了，具体原因不明
            CGFloat h = DAMAI_RATIO_2(SCREEN_WIDTH, m.width,m.height);
            return h>0?h: DAMAI_RATIO_2(SCREEN_WIDTH, 389,341);
            
        } number:^NSInteger(NSInteger section) {
            return x.shopProductImages.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopProductImages[indexPath.row];
        }],
                                   
                                   //保障
                                   [YCCellInfo cellInfoWithId:KGroupC17 height:^CGFloat(NSIndexPath *indexPath) {
            return 50;
        } number:^NSInteger(NSInteger section) {
            return 1;
        }],
                                   
                                   ]];
        
        
        self.model = x;
        
        [self updateSelectCount];
        
    }];
    
}
/**
 *  更新商品数量
 */
- (void)updateSelectCount
{
    if (self.sum >0) {
        self.count = 1;
        
        YCShopSpecM *specsM = self.model.shopSpecs[self.selectedshopSpecIndex];
        // 最低折扣
        YCShopProductStrategyModel *discountM = self.model.shopProductStrategys.lastObject;
        self.price = [NSString stringWithFormat:@"%.2f",specsM.specMoneyPrice.floatValue * discountM.discount.floatValue];
        
    } else {
        self.count = 0;
    }
}

/// 更新最低价钱
- (void)updatePrice:(NSInteger ) count{
    
    YCShopSpecM *specsM   = self.model.shopSpecs[self.selectedshopSpecIndex];
    // 最低折扣
    YCShopProductStrategyModel *discountM = self.model.shopProductStrategys.lastObject;
    self.price = [NSString stringWithFormat:@"%.2f",specsM.specMoneyPrice.floatValue *discountM.discount.floatValue * count];// 默认最低价
}

- (RACSignal *)sponsorGroupBuy
{
    
    return [ENGINE POST_shop:@"groupBuy/sponsorGroupBuy.json" parameters:@{
                                                                           @"productId":self.Id,
                                                                           @"productSpecId":self.specId,
                                                                           @"qty":@(self.count),
                                                                           kToken:[YCUserDefault currentToken],
                                                                           } parseClass:[YCShopProductStrategyModel class] parseKey:@"shopProductStrategys" pageInfo:nil];
}

//自动播放   ---cell0)
#define KGroupC0 cell0
//详细描述---cell3)
#define KGroupC3 cell3

//认证   ---cell8)
#define KGroupC8 cell8
//发货信息---cell12)
#define KGroupC12 cell12
//商品评价，配送地址 ---cell12)
#define KGroupC13 cell13
//往上拉动---cell14)
#define KGroupC14 cell14
//图文详情---cell15)
#define KGroupC15 cell15
//图片   ---cell16)
#define KGroupC16 cell16
//保障   ---cell17)
#define KGroupC17 cell17

#pragma mark-------参团人 OKcell1)
#pragma mark-------价钱和选择数量 cell4)
#pragma mark-------规格 OKcell5)
#pragma mark-------攻略 OKcell6)cell7)
#pragma mark-------团拼玩法cell9)cell10)



@end
