//
//  YCMyNewsOfCVM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfNewsVM.h"
#import "YCNewsM.h"

#import "YCNewsM.h"
#import "YCNewsCell.h"
#import "YCWebVC.h"


@implementation YCCollectOfNewsVM
- (void)dealloc{
    //    OK
}
- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return [super cellIDAtIndexPath:indexPath];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    width = SCREEN_WIDTH;
    return width*129.f/160.f+55;
}

- (RACSignal *)mainSignal
{
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken]
                            } ;

    WSELF;
    return [[ENGINE POST_shop_array:apiGetMyNewsFavoriteList parameters:param parseClass:[YCNewsList class] parseKey:@"newsList" pageInfo:self.pageInfo]doNext:^(NSArray * x){
        SSELF;
        
        
        
        if (self.nextBlock) {
            for (YCNewsList *m in x) {
                [m onSetupData];
            }
            self.nextBlock(x);
        }
    }];
}

@end
