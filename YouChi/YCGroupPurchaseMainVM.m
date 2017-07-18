//
//  YCGroupPurchaseMainVM.m
//  YouChi
//
//  Created by 李李善 on 16/5/14.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupPurchaseMainVM.h"
#import "NSAttributedString+YYText.h"
#import "NSMutableAttributedString+Edit.h"
@implementation YCGroupPurchaseMainVM

/**
 * productId  商品ID
 * productSpecId 规格ID
 * qty   商品数量
 * userAddressId 统一收货地址ID
 *
 @return Signal
 */
-(RACSignal *)mainSignal{ // sponsorGroupBuy.json
    WSELF;
    
    NSString *path = nil;
    NSMutableDictionary *dic =  @{
                                  kToken:[YCUserDefault currentToken],
                                  }.mutableCopy;;
    if (self.isSponsor) {
        path = @"groupBuy/confirmGroupBuy.json";
    } else {
        path = @"groupBuy/getOneGroupBuyDetails.json";
        
    }
    
    [dic addEntriesFromDictionary:self.parameters];
    
    
    return [[ENGINE POST_shop_object:path parameters:dic parseClass:[YCCreateGroupPurchaseM class] parseKey:kContent]doNext:^(YCCreateGroupPurchaseM *x) {
        SSELF;
        self.title = x.shopProduct.productName;
        self.Id = x.shopProduct.productId;
        self.groupBuyId = x.groupBuyId;
        
        self.orderId = x.orderId;
        
        YCGroupTag tag = x.tag.intValue;
        BOOL hasJieSuan = (tag == YCGroupTagStatusSubmittedOrderDidPay);
        
        
        YCCellNumberBlock numberBlock = [YCCellInfo number:^NSInteger(NSInteger section) {  // 530
            return 1;
        }];
        YCCellModelBlock modelBlock = [YCCellInfo model:^id(NSIndexPath *indexPath) {
            return x;
        }];
        
        self.AddressM = x.shopUserAddress;
        
        x.shopProduct.brief = x.shopProduct.productName;
        YYTextLayout *textLayout = [YYTextLayout creatTextLayoutWith:x.shopProduct.brief desc:x.shopProduct.desc];
        
        
        ///描述-->查看配送地址和评论用到
        x.shopShipping = x.shopProduct.shopShipping;
        x.imagePath = x.shopProduct.imagePath;
        x.desc =x.shopProduct.desc;
        x.brief = x.shopProduct.brief;
        
        ///商品图片排序
        x.shopProduct.shopProductImages = [x sortShopProductImagesByImages:x.shopProduct.shopProductImages];
        
        ///编辑数组（包含配送地区和商品评价）
        NSArray *titles = [self onShopShipping:x.shopShipping ShopComment:x.commentCount.intValue];
        //NSArray *colorS =@[KBGCColor(@"#F39C11"),KBGCColor(@"#58D68D"),KBGCColor(@"#E84C3D")];
        
        ///商品图片排序
        [self onSequenceShopProductImages:x.shopProduct.shopProductImages];
        
        
        [self.cellInfos setArray:@[
                                   //自动播放
                                   [YCCellInfo cellInfoWithId:KGroupC0 height:^CGFloat(NSIndexPath *indexPath) {
            CGFloat h = DAMAI_RATIO_2(SCREEN_WIDTH, 4, 3);
            return h;
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
                                   
                                   //
                                   [YCCellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath *indexPath) {
            return 95;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return x.shopUserAddress;
        }],
                                   //详情内容
                                   [YCCellInfo cellInfoWithId:KGroupC3 height:^CGFloat(NSIndexPath *indexPath) {return textLayout.textBoundingSize.height;//+2*YCCreateGroupPurchaseTop+7;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return textLayout;
        }],
                                   
                                   //数量/价格
                                   [YCCellInfo cellInfoWithId:cell3_0 height:^CGFloat(NSIndexPath *indexPath) {
            return 63;
        } number:^NSInteger(NSInteger section) {
            return 1;
        } model:modelBlock],
                                   //规格
                                   [YCCellInfo cellInfoWithId:cell5 height:^CGFloat(NSIndexPath *indexPath) {
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
            
            return 0;
            
        } model:^id(NSIndexPath *indexPath) {
            return x.shopProduct.shopProductVerifys;
        }],
                                   
                                   
                                   //结算情况
                                   [YCCellInfo cellInfoWithId:@"c20" height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:^NSInteger(NSInteger section) {
            if (!hasJieSuan) {
                return 0;
            }
            return 1;
        }],
                                   //结算情况详情
                                   [YCCellInfo cellInfoWithId:@"c21" height:^CGFloat(NSIndexPath *indexPath) {
            return 89.f;
        } number:^NSInteger(NSInteger section) {
            if (!hasJieSuan) {
                return 0;
            }
            return x.shopGroupBuySubs.count;
        } model:^id(NSIndexPath *indexPath) {
            return x;
        }],
                                   
                                   
                                   
                                   //攻略
                                   [YCCellInfo cellInfoWithId:KGroupC6 height:^CGFloat(NSIndexPath *indexPath) {
            return 53;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return @"团拼攻略";
        }],
                                   
                                   //攻略内容
                                   [YCCellInfo cellInfoWithId:KGroupC7 height:^CGFloat(NSIndexPath *indexPath) {
            return 40;
        } number:^NSInteger(NSInteger section) {
            return x.shopProduct.shopProductStrategys.count;
        } model:^id(NSIndexPath *indexPath) {
            YCShopProductStrategyModel *m = x.shopProduct.shopProductStrategys[indexPath.row];
            
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
        } number:numberBlock],
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
        } number:numberBlock],
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
                                   [YCCellInfo cellInfoWithId:KGroupC17 height:^CGFloat(NSIndexPath *indexPath) {
            return 50;
        } number:numberBlock],
                                   
                                   
                                   ]];
        
                
        
        self.model = x;
        [self updateSelectCount];
        self.selectedshopSpecIndex = 0;
        
    }];
}



- (NSNumber *)specId
{
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


#pragma mark-------退出团拼
-(RACSignal *)ondissolveGroupBuy{
    NSString *path = @"groupBuy/cancelGroupBuy.json";
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POST_shop:path parameters:@{
                                               @"groupBuyId":self.groupBuyId,
                                               kToken:[YCUserDefault currentToken]
                                               } parseClass:[YCGroupPurchaseMainM class] parseKey:nil pageInfo:nil];
    
    
}

#pragma mark-------结算前 ，修改发货地址
-(RACSignal *)onModifyGroupBuyAddress{
    NSString *path = @"groupBuy/modifyGroupBuyAddress.json";
    
    return [ENGINE POST_shop:path parameters:@{
                                               @"groupBuyId":self.groupBuyId,
                                               @"userAddressId":self.AddressM.userAddressId,
                                               kToken:[YCUserDefault currentToken]
                                               } parseClass:[YCGroupPurchaseMainM class] parseKey:nil pageInfo:nil];
    
    
}


-(RACSignal *)onSelectSpecChangePrice
{
    CHECK_SIGNAL(!self.Id && !self.specId, @"参数出错");
    
    NSString *path = @"groupBuy/computingGroupBuyPrice.json";
    
    NSLog(@"%@",self.Id);
    NSLog(@"%@",self.specId);
    NSLog(@"%zd",self.count);
    return [[ENGINE POST_shop_array:path parameters:@{
                                                      @"productId":self.Id,
                                                      @"productSpecId":self.specId,
                                                      @"qty":@(self.count),
                                                      kToken:[YCUserDefault currentToken],
                                                      } parseClass:[YCPayGroupPurchaseM class] pageInfo:nil]doNext:^(YCPayGroupPurchaseM * x) {
        
        
        //        self.price = x.object;
    }];
    
    
}


- (RACSignal *)joinGroup
{
    WSELF;
    return [[ENGINE POST_shop_object:@"groupBuy/joinGroupBuy.json" parameters:@{
                                                                                @"groupBuyId":self.groupBuyId
                                                                                ,@"qty":self.model.qty,
                                                                                @"specId":self.specId,
                                                                                kToken:[YCUserDefault currentToken],} parseClass:[YCCreateGroupPurchaseM class] parseKey:kContent] flattenMap:^RACStream *(id value) {
        SSELF;
        return self.mainSignal;
    }];
}



@end
