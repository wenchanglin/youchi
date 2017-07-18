//
//  YCGuanZhuVM.m
//  YouChi
//
//  Created by 李李善 on 15/5/31.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFollowsVM.h"
#import "YCFollowsM.h"
@implementation YCFollowsVM
-(void)dealloc{
    //OK
}

- (instancetype)initWithId:(id)aId
{
    self = [super init];
    if (self) {
        self.Id = aId;
        self.isFans = NO;
    }
    return self;
}


- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return  cell2;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

- (RACSignal *)mainSignal{
return [[ENGINE POST_shop_array:apiGetFollow parameters:@{
                                                        kToken:[YCUserDefault currentToken],
                                                        @"targetUserId":self.Id,
                                                        } parseClass:[YCFollowUserListM class] parseKey:@"followUserList" pageInfo:self.pageInfo]doNext:self.nextBlock];
}


- (NSString *)title{
    return @"关注";
}
@end


        
@implementation YCFansVM
-(void)dealloc{
//    ok
}
- (instancetype)initWithId:(id)aId
{
    self = [super init];
    if (self) {
        self.Id = aId;
        self.isFans = YES;
    }
    return self;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    return  cell1;
}
- (RACSignal *)mainSignal{

        
    return [[ENGINE POST_shop_array:apiGetFans parameters:@{kToken:[YCUserDefault currentToken],
                                                        @"targetUserId":self.Id,
                                                        } parseClass:[YCFansUserListM class] parseKey:@"fansUserList" pageInfo:self.pageInfo ]doNext:self.nextBlock];
}

- (NSString *)title{
    return @"粉丝";
}
@end
