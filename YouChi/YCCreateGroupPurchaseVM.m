 //
//  YCYCCreateGroupPurchaseVM.m
//  YouChi
//
//  Created by 李李善 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.  @"groupBuy/getOneGroupBuyProductDetails.json"
//

#import "YCCreateGroupPurchaseVM.h"
#import "NSMutableAttributedString+Edit.h"
#import "YCSupportGroupPurchaseVM.h"
@implementation YCCreateGroupPurchaseVM
- (instancetype)initWithProductId:(NSNumber *)productId productSpecId:(NSNumber *)productSpecId qty:(NSNumber *)qty
{
    return [self initWithParameters:@{
                                      @"productId":productId,
                                      @"productSpecId":productSpecId,
                                      @"qty":qty,
                                      }];
}

- (instancetype)initWithProductId:(NSNumber *)productId
{
    return [self initWithParameters:@{
                                      @"productId":productId,
                                      }];
}

-(RACSignal *)mainSignal{
    WSELF;
    
    NSString *path = @"groupBuy/sponsorGroupBuy.json";

    NSMutableDictionary *param = self.parameters.mutableCopy;
    [param addEntriesFromDictionary:@{kToken:[YCUserDefault currentToken]}];
    return [[ENGINE POST_shop_object:path parameters:param
                                    parseClass:[YCSupportGroupPurchaseM class] parseKey:kContent]doNext:^(YCSupportGroupPurchaseM* x) {
        SSELF;
        //商品ID
        self.Id = x.productId;
        self.title = x.productName;
                
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
        
        if (self.shopProductStrategys) {
            [x.shopProductStrategys setArray:self.shopProductStrategys];
        }
        for (YCShopProductStrategyModel *m in x.shopProductStrategys) {
            //这里攻略里面的价格用到这里
            [self onEditShopStrategy:m];
        }
        
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
                                   //收货地址标题
                                   [YCCellInfo cellInfoWithId:cell2 height:^CGFloat(NSIndexPath *indexPath) {
            return 43;
        } number:numberBlock model:nil],
                                   //收货地址＋
                                   [YCCellInfo cellInfoWithId:cell4 height:^CGFloat(NSIndexPath *indexPath) {
            return 95;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            SSELF;
            return self.AddressM;
        }],
                                   //详情内容
                                   [YCCellInfo cellInfoWithId:KGroupC3 height:^CGFloat(NSIndexPath *indexPath) {
            return textLayout.textBoundingSize.height;
        } number:numberBlock model:^id(NSIndexPath *indexPath) {
            return textLayout;
        }],
                                   //数量/价格
                                   [YCCellInfo cellInfoWithId:cell5 height:^CGFloat(NSIndexPath *indexPath) {
            return 63;
        } number:^NSInteger(NSInteger section) {
            return x.shopProductStrategys.count;
        } model:^id(NSIndexPath *indexPath) {
            YCShopProductStrategyModel *m = x.shopProductStrategys[indexPath.row];
            
            return m;
        }],
                                   //规格
                                   [YCCellInfo cellInfoWithId:cell6 height:^CGFloat(NSIndexPath *indexPath) {
            return 45.f;
        } number:^NSInteger(NSInteger section) {
            return x.shopSpecs.count;
        } model:^id(NSIndexPath *indexPath) {
            return x.shopSpecs[indexPath.row];
        }],
                                   
                                   ]];
        self.model = x;
        //更新选择商品数量
        [self updateSelectCount];
//        [self onSelectSpecChangePrice];
    }];
    
}


- (NSNumber *)specId
{
    NSNumber *specId = @(0);
    if (self.model.shopSpecs.count==0) {
        return specId;
    }
    @try {
        specId = [self.model.shopSpecs[self.selectedshopSpecIndex] specId];
    }
    @catch (NSException *exception) {
    }
    @finally {
        return specId;
    }
    
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


/**
 *  编辑团拼的攻略
 *
 *  @param m 攻略对象
 */
-(void)onEditShopStrategy:(YCShopProductStrategyModel*)m{
    
    if (m.ltCount.intValue==0) {
        m.detailInfo = [NSString stringWithFormat:@"(%d人以上)",m.gteCount.intValue];
    }else{
        m.detailInfo = [NSString stringWithFormat:@"(%d～%d人)",m.gteCount.intValue,m.ltCount.intValue];
    }
}


-(RACSignal *)onSelectSpecChangePrice
{
    CHECK_SIGNAL(!self.Id && !self.specId, @"参数出错");

    NSString *path = @"groupBuy/computingGroupBuyPriceBySpec.json";
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    
   
    return [[ENGINE POST_shop_array:path parameters:@{
                                                @"productId":self.Id,
                                                @"productSpecId":self.specId,
                                                @"qty":@(self.count),
                                                kToken:[YCUserDefault currentToken],
                                                } parseClass:[YCShopProductStrategyModel class] pageInfo:nil]doNext:^(NSArray * x) {
        
        
        if (x) {
            
            for (YCShopProductStrategyModel *m  in x) {
                [self onEditShopStrategy:m];
            }
            [self.model.shopProductStrategys setArray:x];
            
        }
        
        
    }];
    
    
}


/**
 *  已有XXX人开团或者已有XXX人参团
 *
 *  @param font      指定文本的大小
 *  @param color     指定文本的颜色
 *  @param textStr   总文本
 *  @param numberStr 指定的文本
 *
 *  @return NSMutableAttributedString对象
 */
-(NSMutableAttributedString *)onCrearchAttribFont:(UIFont *)font Color:(UIColor*)color Text:(NSString *)textStr NumberStr:(NSString *)numberStr{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:textStr];
    //    NSRange rang =[text onEditText:numberStr];
    NSRange rang = [textStr rangeOfString:numberStr];
    [text setFont:KFont(16) range:rang];
    [text setColor:color range:rang];
    return text;
}

/**
 *  编辑开团人字符串
 *
 *  @param number 多少开团人
 *
 *  @return 编辑好的字符串
 */
-(NSMutableAttributedString *)onOpenGroupPeopleWithNumber:(NSInteger)number{
    
    NSString *numStr =[NSString stringWithFormat:@"%ld",number];
    
    NSString * textstr = [NSString stringWithFormat:@"已有%@人开团",numStr];
    
    return [self onCrearchAttribFont:KFont(16) Color:[UIColor blackColor] Text:textstr NumberStr:numStr];
}
/**
 *  编辑参团人字符串
 *
 *  @param number 多少参团人
 *
 *  @return 编辑好的字符串
 */
-(NSMutableAttributedString *)onJoinPeopleWithNumber:(NSInteger)number{
    
    NSString *numStr =[NSString stringWithFormat:@"%ld",number];
    
    NSString * textstr = [NSString stringWithFormat:@"已有%@人参团",numStr];
    
    return [self onCrearchAttribFont:KFont(16) Color:[UIColor blackColor] Text:textstr NumberStr:numStr];
}




@end
