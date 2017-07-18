//
//  YCGoodsCommentVM.m
//  YouChi
//
//  Created by 朱国林 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGoodsCommentVM.h"
#import "YCView.h"
@implementation YCGoodsCommentVM
@synthesize model;
- (NSInteger)numberOfSections{
    
    return 2;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
    return self.modelsProxy.count;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return cell0;
    }
    
    return cell1;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 123.f;
    }
    YCGoodsCommentM *m = [self modelForItemAtIndexPath:indexPath];
    return m.cellHeight;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }
    return self.modelsProxy[indexPath.row];
}
#pragma mark --头部高
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 1) {
        return 36;
    }
    return 0;
}

- (NSString *)headerIDInSection:(NSInteger)section
{
    return headerC;
}

- (RACSignal *)mainSignal
{
    return [[ENGINE POST_shop_array:@"product/getProductShowOffByProductId.json" parameters:@{@"productId":self.Id,kToken:[YCUserDefault currentToken]} parseClass:[YCGoodsCommentM class] parseKey:kContent pageInfo:self.pageInfo ]doNext:^(NSArray *x) {
        
        
        if (self.nextBlock) {
            self.insertBackSection = 1;
            [x enumerateObjectsUsingBlock:^(YCGoodsCommentM  *_Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
                m.orderPayDate = [[YCDateFormatter shareDateFormatter] stringFromNumber:(id)m.orderPayDate];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:m.desc?:@""];
                str.font = [UIFont systemFontOfSize:14];
                str.lineSpacing = 8;
                [str appendString:@"\n"];
                
                YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH-40-8-8, HUGE) insets:UIEdgeInsetsMake(2, 0, 10, 8)];
                m.layout = [YYTextLayout layoutWithContainer:container text:str];
                m.cellHeight = 48+m.layout.textBoundingSize.height+30+50+((m.shopProductShowoffImages.count==0)?0:70)+YCGoodsCommentInset;
                
                
                m.createdDate = [NSString stringWithFormat:@"评论日期：%@",[m.createdDate substringWithRange:NSMakeRange(0, m.createdDate.length-3)]];
                
                m.orderPayDate = [m.orderPayDate substringWithRange:NSMakeRange(0, m.orderPayDate.length-3)];
                m.orderPayDate = [NSString stringWithFormat:@"购买日期：%@",m.orderPayDate];
                
                
                
            }];
            self.insertBackSection = 1;
            self.nextBlock(x);
            self.pageInfo.loadmoreId = @(0);
        }
    }];
}

- (RACSignal *)clickLikeForProductShowoffByProductShowoffId:(NSNumber *)Id actionType:(BOOL)actionType
{
    return [ENGINE POSTBool:@"product/clickLikeForProductShowoff.json" parameters:@{@"productShowoffId":Id,@"actionType":@(actionType),kToken:[YCUserDefault currentToken]}];
}
@end
