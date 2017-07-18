//
//  YCMyTakePictureOfCVM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfYouChiVM.h"

#import "YCChihuoyingM.h"


@implementation YCCollectOfYouChiVM
-(void)dealloc{
    //    ok
    
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return [super cellIDAtIndexPath:indexPath];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return [super heightForRowAtIndexPath:indexPath];

}

#pragma mark--获取吃货营列表，随手拍则有youchiPhotoList,分享果单和跟做果单则有recipe对象。
- (RACSignal *)mainSignal
{
    WSELF
    return [[ENGINE POST_shop_array:apiGetMyYouchiFavoriteList parameters:@{
                                                                      kToken:[YCUserDefault currentToken]
                                                                      } parseClass:[YCChihuoyingM_1_2 class]  pageInfo:self.pageInfo]doNext:^(id x) {
        SSELF;
        [super onSetupHeights:x width:kScreenWidth];
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];

}

@end
