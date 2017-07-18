//
//  YCPrivateDetailednessVM.m
//  YouChi
//
//  Created by 李李善 on 15/5/18.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPrivateDetailednessVM.h"

@implementation YCPrivateDetailednessVM
- (void)dealloc{
    //ok
}
- (instancetype)initWithViewModel:(id)viewModel
{
    self = [super initWithViewModel:viewModel];
    if (self) {
        self.states = [NSMutableArray arrayWithCapacity:3];
        self.privateBookingVM = viewModel;
    }
    return self;
}

#pragma mark --网络请求
- (RACSignal *)mainSignal
{
    return [[ENGINE POST_shop_array:apiGetAll parameters:nil parseClass:[YCPrivateDetailednessM class] parseKey:@"allState" pageInfo:nil ] doNext:self.nextBlock];
}

- (RACSignal *)userStateSignal
{
    WSELF;
    return [[ENGINE POST_shop_array:apiGetUser parameters:@{kToken:[YCUserDefault currentToken]} parseClass:[YCPrivateDetailednessStateM class] pageInfo:nil]doNext:^(NSArray *x) {
        SSELF;
        for (YCBaseModel *m in x) {
            [self.states addObject:m];
        }
    }];
}

- (RACSignal *)updateStateSignal
{
    WSELF;
    NSMutableArray *states = [NSMutableArray arrayWithCapacity:self.states.count];

    for (YCPrivateDetailednessStateM *m in self.states) {
        [states addObject:m.Id];
    }
    
    NSString *stateIds = [states componentsJoinedByString:@","];
    
    return [[ENGINE POSTBool:apiSaveUser parameters:@{
                                                     kToken:[YCUserDefault currentToken],
                                                     @"stateIdArrayStr":stateIds,
                                                     }]doNext:^(id x) {
        SSELF;
        self.privateBookingVM.shouldUpdateState = YES;
    }];
}

@end
