//
//  YCSheZhiVM.m
//  YouChi
//
//  Created by 李李善 on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSettingVM.h"

@implementation YCSettingVM
@synthesize viewModel;
- (void)dealloc
{
//   ok
}

- (instancetype)init{

    self = [super init];
    if (self) {
        
    }
    
    
    return self;
}

#pragma mark - 注销请求
- (RACSignal *)logoutSignal{
    YCUserDefault *ud = [YCUserDefault standardUserDefaults];
    if (![ud isCurrentUserValid]) {
        [ud removeCurrentUser];
        [ENGINE changeLoginId:nil andAppLoginId:nil];
        return [RACSignal return:nil];
    }
    return [[[ENGINE POSTBool:apiLoginOut parameters:@{kToken:[YCUserDefault currentToken]}] doNext:^(id x) {
        [ud removeCurrentUser];
        [ENGINE changeLoginId:nil andAppLoginId:nil];
    }] doError:^(NSError *error) {
        [ud removeCurrentUser];
        [ENGINE changeLoginId:nil andAppLoginId:nil];
    }];
}

@end

