//
//  YCVideoBannerVM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/27.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCVideoBannerVM.h"
#import "YCVideoBannerM.h"

@implementation YCVideoBannerVM
- (void)dealloc
{
    //    OK
}


#pragma mark -

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    return cell0;
}

- (NSInteger)numberOfSections{
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    return self.modelsProxy.count;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [super modelForItemAtIndexPath:indexPath];
}


#pragma mark - 网络请求

- (RACSignal *)mainSignal{
    WSELF;
    return [[ENGINE POST_shop_array:apiGetVideoBannerList parameters:nil  parseClass:[YCVideoBannerM class] parseKey:nil pageInfo:nil]doNext:^(id x) {
        SSELF;
        [self.modelsProxy setArray:x];
        
    }];
}

@end
