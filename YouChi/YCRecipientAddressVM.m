//
//  YCRecipientAddressVM.m
//  YouChi
//
//  Created by 朱国林 on 15/12/23.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCRecipientAddressM.h"
#import "YCRecipientAddressVM.h"

@interface YCRecipientAddressVM ()
@end

@implementation YCRecipientAddressVM
GETTER_LAZY_SUBJECT(addressChangedSignal);
GETTER_LAZY_SUBJECT(addressDeletedSignal);

-(instancetype)init{
    if (self ==[super init]) {
        self.title = @"选择收货地址";
    }
    return self;
}


-(NSInteger)numberOfSections{

    return self.modelsProxy.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{

    return 1;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.modelsProxy objectAtIndex:indexPath.section];
}


- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell1;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.f;
}


- (void )addModel:(id)model
{
    [self willChangeValueForKey:KP(self.modelsProxy)];
    [super addModel:model];
    [self didChangeValueForKey:KP(self.modelsProxy)];
}


- (void)removeModelAtIndex:(NSInteger)index
{
    [self willChangeValueForKey:KP(self.modelsProxy)];
    [super removeModelAtIndex:index];
    [self didChangeValueForKey:KP(self.modelsProxy)];
}


- (RACSignal *)mainSignal
{
    self.pageInfo.pageSize = 100;
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken]
                            } ;
    return [[ENGINE POST_shop_array:@"address/getMyShopUserAddressList.json" parameters:param parseClass:[YCRecipientAddressM class] parseKey:kContent pageInfo:self.pageInfo]doNext:^(NSArray * x){
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];
}


@end
