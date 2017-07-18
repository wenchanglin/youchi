
//
//  YCPayGroupPurchaseVM.m
//  YouChi
//
//  Created by 李李善 on 16/5/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPayGroupPurchaseVM.h"


@implementation YCPayGroupPurchaseVM
@synthesize model;

-(RACSignal *)mainSignal{
    
    NSString *url;
    if (self.groupPeople == YCGroupPurchaseMember) {
        url = @"groupBuy/joinGroupBuy.json";
    }else{
        url = @"groupBuy/getOneGroupBuyDetails.json";
    }
    
    if (self.isSponsor) {
        url = @"groupBuy/confirmGroupBuy.json";
    }
    
    NSMutableDictionary *param = self.parameters.mutableCopy;
    [param addEntriesFromDictionary:@{kToken:[YCUserDefault currentToken]}];
    
    WSELF;
    
    return [[ENGINE POST_shop_object:url parameters:param parseClass:[YCPayGroupPurchaseM class] parseKey:kContent]doNext:^(YCPayGroupPurchaseM * x) {
        SSELF;
        YCGroupTag tag = x.tag.intValue;
        self.title = x.shopProduct.productName;
        
        BOOL isJieSuan = (tag == YCGroupTagStatusSubmittedOrderDidPay);
        
        //TODO:将id在这里改了一下
        YCCellNumberBlock numberBlock = [YCCellInfo number:^NSInteger(NSInteger section) {
            return 1;
        }];
        YCCellModelBlock modelBlock = [YCCellInfo model:^id(NSIndexPath *indexPath) {
            return x;
        }];
        
        self.groupBuyId = x.groupBuyId;
        self.Id = x.shopProduct.productId;
        
        ///描述-->查看配送地址和评论用到
        x.brief = x.shopProduct.productName;
        x.desc = x.shopProduct.desc;
        x.shopShipping = x.shopProduct.shopShipping;
        x.commentCount = x.shopProduct.commentCount;
        x.imagePath = x.shopProduct.imagePath;
        
        ///商品图片排序
        x.shopProduct.shopProductImages = [x sortShopProductImagesByImages:x.shopProduct.shopProductImages];
        
        YYTextLayout *textLayout = [x creatDescTextLayout];
        ///设置统一收货地址
        self.AddressM = x.shopUserAddress;
        ///编辑数组（包含配送地区和商品评价）
        NSArray *titles = [self onShopShipping:x.shopProduct.shopShipping ShopComment:x.shopProduct.commentCount.intValue];
        
        //NSArray *colorS =@[KBGCColor(@"#F39C11"),KBGCColor(@"#58D68D"),KBGCColor(@"#E84C3D")];
        
        CGFloat adheight = DAMAI_RATIO_2(SCREEN_WIDTH, 4, 3);
        [self.cellInfos setArray:@[
                                   //自动播放
                                   [YCCellInfo cellInfoWithId:KGroupC0 height:^CGFloat(NSIndexPath *indexPath) {
            
            return adheight;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return x.shopProduct;
        }],
                                   //开团人
                                   [YCCellInfo cellInfoWithId:cell1 height:^CGFloat(NSIndexPath *indexPath) {
            return 230;
        } number:numberBlock model:modelBlock],
                                   
                                   //收货地址
                                   [YCCellInfo cellInfoWithId:cell2 height:^CGFloat(NSIndexPath *indexPath) {
            return 43.f+YCCreateGroupTop;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return @"统一收货地址";
        }],
                                   [YCCellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath *indexPath) {
            return 95;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return x.shopUserAddress;
        }],
                                   
                                   //详情内容
                                   [YCCellInfo cellInfoWithId:KGroupC3 height:^CGFloat(NSIndexPath *indexPath) {
            return textLayout.textBoundingSize.height;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return textLayout;
        }],
                                   
                                   //价格/商品数量
                                   [YCCellInfo cellInfoWithId:cell5 height:^CGFloat(NSIndexPath *indexPath) {
            return 63;
        } number:^NSInteger(NSInteger section) {
            return 1;
        } model:modelBlock],
                                   
                                   //规格
                                   [YCCellInfo cellInfoWithId:cell6 height:^CGFloat(NSIndexPath *indexPath) {
            return 50.f;
        } number:^NSInteger(NSInteger section) {
            return x.shopProduct.shopSpecs.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopProduct.shopSpecs[indexPath.row];
            
        }],
                                   //商品认证
                                   [YCCellInfo cellInfoWithId:KGroupC8 height:^CGFloat(NSIndexPath *indexPath) {
            return 65;
        } number:^NSInteger(NSInteger section) {
            return 0;  //暂时隐藏
        } model:^id(NSIndexPath *indexPath) {
            return x.shopProduct.shopProductVerifys;
        }],
                                   
                                   //结算情况与发货情况表题
                                   [YCCellInfo cellInfoWithId:cell7 height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:^NSInteger(NSInteger section) {
            if (!isJieSuan) {
                return 0;
            }
            return 1;
        }],
                                   //结算情况详情
                                   [YCCellInfo cellInfoWithId:cell9 height:^CGFloat(NSIndexPath *indexPath) {
            return 89.f;
        } number:^NSInteger(NSInteger section) {
            if (!isJieSuan) {
                return 0;
            }
            return x.shopGroupBuySubs.count;
        } model:^id(NSIndexPath *indexPath) {
            return x;
        }],
                                   
                                   //攻略
                                   [YCCellInfo cellInfoWithId:@"c20" height:^CGFloat(NSIndexPath *indexPath) {
            return 50;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return @"团拼攻略";
        }],
                                   
                                   //攻略内容
                                   [YCCellInfo cellInfoWithId:@"c21" height:^CGFloat(NSIndexPath *indexPath) {
            return 50;
        } number:^NSInteger(NSInteger section) {
            
            return x.shopProduct.shopProductStrategys.count;;
        } model:^id(NSIndexPath *indexPath) {
            YCShopProductStrategyModel *m = x.shopProduct.shopProductStrategys[indexPath.row];
            
            return m;
        }],
                                   
                                   //团拼玩法
                                   [YCCellInfo cellInfoWithId:@"c22" height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:numberBlock model:nil],
                                   //团拼玩法内容
                                   [YCCellInfo cellInfoWithId:@"c23" height:^CGFloat(NSIndexPath *indexPath) {
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
        } number:numberBlock],
                                   
                                   //图片
                                   [YCCellInfo cellInfoWithId:KGroupC16 height:^CGFloat(NSIndexPath *indexPath) {
            YCShopProductImagesM *m = x.shopProduct.shopProductImages[indexPath.row];
            //增加了高度之后图片在滚动的时候就不会挡住 图片上下方的控件了，具体原因不明
            CGFloat h = DAMAI_RATIO_2(SCREEN_WIDTH, m.width,m.height);
            return h>0?h: DAMAI_RATIO_2(SCREEN_WIDTH, 389,341);
            
        } number:^NSInteger(NSInteger section) {
            return x.shopProduct.shopProductImages.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopProduct.shopProductImages[indexPath.row];
        }],
                                   //保障
                                   [YCCellInfo cellInfoWithId:KGroupC17 height:^CGFloat(NSIndexPath *indexPath) {
            return 50;
        } number:numberBlock],
                                   
                                   ]];
        
        self.model =x;
        //更新选择商品数量
        [self updateSelectCount];
        
        self.selectedshopSpecIndex = 0;
        
        self.orderId = x.orderId;
        
        //如果是发起人，去掉团拼攻略
        if (self.isSponsor) {
            self.parameters = @{@"groupBuyId":x.groupBuyId};
            self.isSponsor = NO;
        }
        
        // 若提交过订单，记录选择的数量
        for (YCShopGroupBuySubM *m in self.model.shopGroupBuySubs) {
            if (m.isMe.boolValue) {
                self.count = m.qty.integerValue;
            }
        }
        
    }];
}

- (NSNumber *)specId
{
    if (self.model.shopProduct.shopSpecs.count == 0) {
        return @(0);
    }
    return [self.model.shopProduct.shopSpecs[self.selectedshopSpecIndex] specId]?:@(0);
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
    if (self.model.shopProduct.shopSpecs.count==0) {
        return 0;
    }
    YCShopSpecM *specsM = self.model.shopProduct.shopSpecs[self.selectedshopSpecIndex];
    return specsM.specQty.intValue;
}




/**
 *   催他结算
 *
 *  @param payUserId  对方ID
 *
 *  @return 催他结算信号
 */
#pragma mark-------催他结算
-(RACSignal *)onUrgePay:(NSNumber *)payUserId groupBuyId:(NSNumber *)groupBuyId {
    CHECK_SIGNAL(!payUserId, @"参数错误");
    NSString *path = @"groupBuy/urgePay.json";
    //TODO:groupBuyId没有输入
    NSMutableDictionary *param = @{
                                   @"payUserId":payUserId,
                                   @"groupBuyId":groupBuyId,
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    
    return [ENGINE POST_shop:path parameters:param parseClass:nil parseKey:nil pageInfo:nil];
    
}

#pragma mark-------踢人
-(RACSignal *)onCancelOtherKickUserId:(NSNumber *)userId{
    
    NSString *path = @"groupBuy/kickOne.json";
    //TODO:groupBuyId没有输入
    NSMutableDictionary *param = @{
                                   @"groupBuyId":self.groupBuyId,
                                   @"kickUserId":userId,
                                   kToken:[YCUserDefault currentToken],
                                   }.mutableCopy;
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    
    return [ENGINE POST_shop:path parameters:param parseClass:nil parseKey:nil pageInfo:nil];
}




@end
