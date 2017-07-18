//
//  YCCellInfo.m
//  YouChi
//
//  Created by sam on 16/1/23.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCellInfo.h"

@interface YCCellInfo ()
@property (nonatomic,strong,readwrite) NSString *Id;
@property (nonatomic,strong,readwrite) YCCellHeightBlock heightBlock;
@property (nonatomic,strong,readwrite) YCCellNumberBlock numberBlock;
@property (nonatomic,strong,readwrite) YCCellModelBlock modelBlock;
@end

@implementation YCCellInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightBlock = nil;
    }
    return self;
}
+ (instancetype)cellInfoWithId:(NSString *)Id height:(YCCellHeightBlock)heightBlock number:(YCCellNumberBlock)numberBlock model:(YCCellModelBlock)modelBlock
{
    NSParameterAssert(Id);
    YCCellInfo *info = [self new];
    info.Id = Id;
    info.heightBlock = heightBlock?:[self height:^CGFloat(NSIndexPath *indexPath) {
        return 0.f;
    }];
    info.numberBlock = numberBlock?:[self number:^NSInteger(NSInteger section) {
        return 0;
    }];
    info.modelBlock = modelBlock?:[self model:^id(NSIndexPath *indexPath) {
        return nil;
    }];
    return info;
}

+ (instancetype)cellInfoWithId:(NSString *)Id height:(YCCellHeightBlock)heightBlock number:(YCCellNumberBlock)numberBlock
{
    return [self cellInfoWithId:Id height:heightBlock number:numberBlock model:nil];
}

+ (YCCellHeightBlock)height:(YCCellHeightBlock)heightBlock
{
    return heightBlock;
}

+ (YCCellNumberBlock)number:(YCCellNumberBlock)numberBlock
{
    return numberBlock;
}

+ (YCCellModelBlock)model:(YCCellModelBlock)modelBlock
{
    return modelBlock;
}
@end
