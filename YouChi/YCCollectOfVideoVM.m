//
//  YCMyVideoOfCVM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfVideoVM.h"
#import "YCVideoM.h"

@implementation YCCollectOfVideoVM
- (void)dealloc{
    //    OK
}
- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell0;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    return 120.0f;
}


- (RACSignal *)mainSignal
{
    
    WSELF;
    NSDictionary *param = @{kToken:[YCUserDefault currentToken]} ;
    return [[ENGINE POST_shop_array:apiGetMyVideoFavoriteList parameters:param parseClass:[YCVideoM class] parseKey:@"videoList" pageInfo:self.pageInfo  ]doNext:^(id x){
        SSELF;
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];
}
@end
