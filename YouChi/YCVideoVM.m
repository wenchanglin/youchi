//
//  YCVideoVM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCVideoVM.h"
#import "YCVideoM.h"
@implementation YCVideoVM
-(void)dealloc{
    //    ok
    
}
//url	__NSCFConstantString *	@"app/find/video/getRecommendVideoList.json"	0x0000000100773090

//url	__NSCFConstantString *	@"app/find/video/getLatestVideoList.json"	0x00000001007730b0
- (instancetype)initWithURL:(NSString * )url
{
    self = [super init];
    if (self) {
        self.urlString = url;
    }
    return self;
}

- (NSInteger)numberOfSections
{
    return self.modelsProxy.count>0?1:0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.modelsProxy.count / 2 +1;
}


- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return self.modelsProxy.firstObject;
    }
    
    else if (indexPath.row > 0) {
        NSUInteger loc = 2*indexPath.row - 1 ;
        NSUInteger end = MIN(self.modelsProxy.count , loc+2);
        return  [self.modelsProxy subarrayWithRange:NSMakeRange(loc, end-loc)];
    }
    return nil;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    if (indexPath.row==0){
        return ((width-8-8-8)/2)*114.f/260.f+21+15;
    }
    return ((width -8-8-8)/2)*120.f/350.f+64;
  
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0){
        return cell1;
    }
    return cell2;
}


- (RACSignal *)mainSignal
{
    WSELF;
    self.pageInfo.pageSize = 100;
    NSDictionary *param = @{kToken:[YCUserDefault currentToken]};
    return [[ENGINE POST_shop_array:self.urlString parameters:param parseClass:[YCVideoM class] parseKey:@"videoList" pageInfo:self.pageInfo] doNext:^(NSArray *x) {
        SSELF;
        
        
        if (self.nextBlock) {
            
            
            self.nextBlock(x);
            YCVideoM *m = self.modelsProxy.firstObject;
            NSString *total = !m.totalFraction?@"0":[NSString stringWithFormat:@"%.1f",m.totalFraction.intValue / 10.0 ];
            m.playPv= [NSString stringWithFormat:@"评分:%@  /  播放次数:%@",total,m.pv];
            m.playTime = [NSString stringWithFormat:@"时间 %@",m.playTime];
            
        }

    }];
    
}

@end
