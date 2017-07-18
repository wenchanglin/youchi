//
//  YCRecommendMsgVM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNewsVM.h"
#import "YCNewsM.h"

@implementation YCNewsVM



- (void)dealloc{
    //ok
}


- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    return width*129.f/210.f+50;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell0;
}

- (RACSignal *)mainSignal
{
    WSELF;
    NSDictionary *param = @{kToken:[YCUserDefault currentToken]} ;
    return [[ENGINE POST_shop_array:self.urlString parameters:param parseClass:[YCNewsList class] parseKey:@"newsList" pageInfo:self.pageInfo]doNext:^(NSArray * x) {
        SSELF;
        ;
        for (YCNewsList *m in x) {
            [m onSetupData];
        }
        
        if (self.nextBlock) {
            self.nextBlock(x);
        }
        
    }];
}


@end
