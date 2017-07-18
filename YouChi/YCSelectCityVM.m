//
//  YCSelectCityVM.m
//  YouChi
//
//  Created by sam on 15/10/20.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSelectCityVM.h"
#import <DOSChineseStringCompare/NSString+DOSChineseString.h>
@implementation YCSelectCityVM
{
    
}
@synthesize viewModel;


- (void)dealloc
{
    
    
    //ok
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [super numberOfItemsInSection:section];
}


- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell0;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.modelsProxy.count>0) {
        
        return [super modelForItemAtIndexPath:indexPath];
    }
    return nil;
}

- (RACSignal *)mainSignal
{
    return [self signalSearchWithCity:nil];
}

-(RACSignal *)signalSearchWithCity:(NSString *)city
{
    //城市定位
    city = [city stringByTrim];
    NSString *parseKey = @"cityList";
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    self.pageInfo.pageSize = 1000;
    self.pageInfo.status = YCLoadingStatusDefault;
   
    if (city.length>0) {
        [para addEntriesFromDictionary:@{@"searchName":city}];
        
        
    }
    
    
    WSELF;
    
    return [[ENGINE POST_shop_array:apiGetCityList  parameters:para parseClass:[YCChihuoyingM_1_2 class] parseKey:parseKey pageInfo:self.pageInfo]doNext:^(NSArray *x) {
        SSELF;
        
        if (self.nextBlock) {
            if (x.count > 0) {
                @try {
                    x = [x sortedArrayUsingComparator:^NSComparisonResult(YCChihuoyingM_1_2*   obj1, YCChihuoyingM_1_2*   obj2) {
                        NSString *fl1 = [obj1.name substringToIndex:1];
                        NSString *fl2 = [obj2.name substringToIndex:1];
                        return [fl1 DOSCompareString:fl2 compareType:DOSChineseStringCompareTypePinyin isAscending:YES];
                    }];
                }
                @catch (NSException *exception) {
                    ;
                }
                @finally {
                    ;
                }
               
            }
            
            self.nextBlock(x);
        }
    }];
    
}


@end

