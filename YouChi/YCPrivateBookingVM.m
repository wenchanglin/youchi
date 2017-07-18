//
//  YCPrivateBookingVM.m
//  YouChi
//
//  Created by sam on 15/5/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPrivateBookingVM.h"
#import "YCChihuoyingM.h"
#import "YCViewModel+Logic.h"

@implementation YCPrivateBookingVM
{
    RACSignal *_mainParamSignal;
}

- (void)dealloc{
    //ok
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _mainParamSignal = [RACSignal combineLatest:@[[self getLocationInformationSignal],[RACObserve(self, stateIds) ignore:nil]] reduce:^id(YCLocationInfo *locationInfo,NSString *stateIds){
            NSMutableDictionary *para = @{
                                          @"city":[locationInfo.lastCity stringByReplacingOccurrencesOfString:@"市" withString:@""],
                                          }.mutableCopy;
            if (stateIds) {
                para[@"stateIds"] = stateIds;
            }
            return para;
        }];
        
        YCLoginM *login = [YCUserDefault currentUser];
        RAC(self,user) = [RACSignal merge:@[RACObserve(login, appUser),[[[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCUserDefaultUpdate object:nil] map:^id(NSNotification  *value) {
            YCLoginM *login = value.object;
            return login.appUser;
        }] takeUntil:self.rac_willDeallocSignal]]];

    }
    return self;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
   
    return cell1;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    YCPrivateBookingM *m = [self modelForItemAtIndexPath:indexPath];
   return m.cellHeight;
    
}


#pragma mark---根据，获取分类果单的列表
- (RACSignal *)mainSignal
{
    WSELF;
    return [_mainParamSignal flattenMap:^RACStream *(id value) {
        SSELF;
        return [[ENGINE POST_shop_array:apiRGetRecommend parameters:value parseClass:[YCChihuoyingM_1_2 class] pageInfo:self.pageInfo]doNext:^(NSArray *x) {
            CGFloat width = SCREEN_WIDTH;
            for (YCChihuoyingM_1_2 *m in x) {
                m.youchiType = @(YCCheatsTypeRecipe);
                m.cellHeight = 8+30+8+width*3/4+37;
            }

            
            if (self.nextBlock) {
                self.nextBlock(x);
            }
        }];
    }];

}

#pragma mark---
- (RACSignal *)getPersonalHeaderSignal
{
    WSELF;
    return [[[self getLocationInformationSignal]flattenMap:^RACStream *(YCLocationInfo *locationInfo) {
        return [ENGINE POST_shop_object:apiRPersonalHeader parameters:@{
                                                     kToken:[YCUserDefault currentToken],
                                                     @"city":[locationInfo.lastCity stringByReplacingOccurrencesOfString:@"市" withString:@""],
                                                     } parseClass:[YCPrivateBookingM class] parseKey:nil];
        
    }]doNext:^(YCPrivateBookingM *x) {
        SSELF;
        NSMutableArray *states = [NSMutableArray array];
        [x.userStateList enumerateObjectsUsingBlock:^(YCBaseModel *m, NSUInteger idx, BOOL *stop) {
            [states addObject:m.Id];
        }];
        NSString *str = [states componentsJoinedByString:@","];
        self.stateIds = str;
    }];
}


@end
