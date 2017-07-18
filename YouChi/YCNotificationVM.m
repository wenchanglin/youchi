//
//  YCNotificationVM.m
//  YouChi
//
//  Created by 李李善 on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNotificationVM.h"
#import "YCNotificationM.h"
@implementation YCNotificationVM
-(void)dealloc{
    //    ok
    
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    YCNotificationM *model = self.modelsProxy[indexPath.row];
    
    return model.cellHeight;
}



- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell1;
}

- (RACSignal *)mainSignal
{
    
    WSELF;
    return [[ENGINE POST_shop_array:apiCGetNoticeList parameters:@{
                                                             kToken:[YCUserDefault currentToken],
                                                             } parseClass:[YCNotificationM class] parseKey:@"noticeList" pageInfo:self.pageInfo ]doNext:^(NSArray *x) {
        SSELF;
        
        [x enumerateObjectsUsingBlock:^(YCNotificationM *  model, NSUInteger idx, BOOL * stop) {
            
           [model onSetupHeightWithWidth:kScreenWidth];
            
        }];
        
        
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];
}

@end
