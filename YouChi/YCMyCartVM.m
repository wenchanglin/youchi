//
//  YCMyCartVM.m
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
/**
 TODO: + 说明：
 如果代码中有该标识，说明在标识处有功能代码待编写，待实现的功能在说明中会简略说明。
 
 FIXME: + 说明：
 如果代码中有该标识，说明标识处代码需要修正，甚至代码是错误的，不能工作，需要修复，如何修正会在说明中简略说明。
 
 MARK: + 说明：
 如果代码中有该标识，说明标识处代码虽然实现了功能，但是实现的方法有待商榷，希望将来能改进，要改进的地方会在说明中简略说明。
 */
#import "YCMyCartVM.h"

@implementation YCMyCartVM
@dynamic model;

-(instancetype)init{
    if(self ==[super init])
    {
        self.title = @"购物车";
        self.CartIds =[NSMutableArray new];
        self.isAllSelected = 1;
    }
    return self;
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section{
    return self.modelsProxy.count;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell0;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 162;
}
- (RACSignal *)mainSignal{
    
    
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken],
                            } ;
    
    return [[ENGINE POST_shop_array:@"cart/getMyCartList.json" parameters:param parseClass:[YCAboutGoodsM class] pageInfo:self.pageInfo]doNext:^(NSArray * x){
        
        self.totalPrice = nil;
        
        for (YCAboutGoodsM *m in x) {
            
            float total = m.productPrice.floatValue * m.qty.intValue;
            
            self.totalPrice = [NSString stringWithFormat:@"%.2f",total+self.totalPrice.floatValue];
            [self.CartIds addObject:m.cartId];
            
        }
        
        if (self.totalPrice == nil) {
            self.totalPrice = @"0.00";
        }
        
        if (self.nextBlock) {
            self.nextBlock(x);
        }
        
    }];
    
    
}

#pragma mark --更新购物车
- (RACSignal *)updateMyCartWithProductId:(NSNumber *)productId productSpecId:(NSNumber *)productSpecId count:(NSNumber *) count{
    
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken],
                            @"productId":productId,
                            @"productSpecId":productSpecId,
                            @"count":count,
                            } ;
    
    NSString *path = @"cart/updateCartItemCount.json";
    
    NSAssert(path, @"路径不能为空,说明没有这个type");
    return [ENGINE POSTBool:path parameters:param];
    
    
}

@end
