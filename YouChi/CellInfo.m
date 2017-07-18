//
//  CellData.m
//  funvive
//
//  Created by DengZhiMin on 16/3/4.
//  Copyright © 2016年 jiquke. All rights reserved.
//

#import "CellInfo.h"
NS_ASSUME_NONNULL_BEGIN
@interface CellInfo ()

@property (nonatomic,strong,readwrite) NSString *Id;
@property (nonatomic,assign,readwrite) UITableViewCellStyle style;
@property (nonatomic,strong,readwrite) CellHeightBlock heightBlock;
@property (nonatomic,strong,readwrite) CellNumberBlock numberBlock;
@property (nonatomic,strong,readwrite) CellModelBlock modelBlock;
@property (nonatomic,strong,readwrite) CellSizeBlock sizeBlock;
@property (nonatomic,strong,readwrite) CellEdgeBlock edgeBlock;
@property (nonatomic,strong,readwrite) CellInfo *headInfo;
@property (nonatomic,strong,readwrite) CellInfo *footInfo;

@end

@implementation CellInfo
- (void)setHeadInfo:(CellInfo *)headInfo
{
    _headInfo = headInfo;
    _headInfo.Id = _Id;
}

- (void)setFootInfo:(CellInfo *)footInfo{
    _footInfo = footInfo;
    _footInfo.Id = _Id;
}

+ (instancetype)cellInfoWithId:(NSString *)Id height:(nonnull CellHeightBlock)heightBlock number:(CellNumberBlock _Nullable)numberBlock model:(CellModelBlock _Nullable)modelBlock edge:(CellEdgeBlock _Nullable)edgeBlock headInfo:(CellInfo * _Nullable)headInfo footInfo:(CellInfo * _Nullable)footInfo style:(UITableViewCellStyle)style
{
    NSParameterAssert(Id);
    CellInfo *info = [self new];
    info.Id = Id;
    info.heightBlock = heightBlock?:[self height:^CGFloat(NSIndexPath *indexPath) {
        return 0;
    }];
    info.numberBlock = numberBlock?:[self number:^NSInteger(NSInteger section) {
        return 0;
    }];
    info.modelBlock = modelBlock?:[self model:^id(NSIndexPath *indexPath) {
        return nil;
    }];
    info.edgeBlock = edgeBlock?:[self edge:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
        return UIEdgeInsetsZero;
    }];
    info.headInfo = headInfo;
    info.footInfo = footInfo;
    info.style = style;
    return info;
}

+ (instancetype)cellInfoWithId:(NSString *)Id height:(nonnull CellHeightBlock)heightBlock number:(CellNumberBlock _Nullable)numberBlock model:(CellModelBlock _Nullable)modelBlock edge:(CellEdgeBlock _Nullable)edgeBlock headInfo:(CellInfo * _Nullable)headInfo footInfo:(CellInfo * _Nullable)footInfo
{
    return [self cellInfoWithId:Id height:heightBlock number:numberBlock model:modelBlock edge:edgeBlock headInfo:headInfo footInfo:footInfo style:UITableViewCellStyleDefault];
}


+ (instancetype)cellInfoWithId:(NSString *)Id height:(CellHeightBlock)heightBlock number:(CellNumberBlock)numberBlock model:(CellModelBlock _Nullable)modelBlock headInfo:(CellInfo * _Nullable)headInfo footInfo:(CellInfo * _Nullable)footInfo
{
    return [self cellInfoWithId:Id height:heightBlock number:numberBlock model:modelBlock edge:nil headInfo:headInfo footInfo:footInfo];
}

+ (instancetype)cellInfoWithId:(NSString *)Id height:(nonnull CellHeightBlock)heightBlock number:(CellNumberBlock _Nullable)numberBlock model:(CellModelBlock _Nullable)modelBlock edge:(CellEdgeBlock _Nullable)edgeBlock
{
    return [self cellInfoWithId:Id height:heightBlock number:numberBlock model:modelBlock edge:edgeBlock headInfo:nil footInfo:nil];
}

+ (instancetype)cellInfoWithId:(NSString *)Id height:(CellHeightBlock)heightBlock number:(CellNumberBlock)numberBlock model:(CellModelBlock _Nullable)modelBlock
{
    return [self cellInfoWithId:Id height:heightBlock number:numberBlock model:modelBlock headInfo:nil footInfo:nil];
}

+ (instancetype)cellInfoWithId:(NSString *)Id height:(CellHeightBlock)heightBlock number:(CellNumberBlock)numberBlock
{
    return [self cellInfoWithId:Id height:heightBlock number:numberBlock model:nil];
}

+ (instancetype)cellInfoWithId:(NSString *)Id  number:(CellNumberBlock _Nullable)numberBlock model:(CellModelBlock _Nullable)modelBlock edge:(CellEdgeBlock _Nullable)edgeBlock size:(CellSizeBlock _Nullable)sizeBlock headInfo:(CellInfo * _Nullable)headInfo footInfo:(CellInfo * _Nullable)footInfo
{
    NSParameterAssert(Id);
    
    CellInfo *info = [self new];
    info.Id = Id;
    
    info.numberBlock = numberBlock?:[self number:^NSInteger(NSInteger section) {
        return 0;
    }];
    info.modelBlock = modelBlock?:[self model:^id(NSIndexPath *indexPath) {
        return nil;
    }];
    info.sizeBlock = sizeBlock?:[self size:^CGSize(NSIndexPath * _Nonnull indexPath) {
        return CGSizeZero;
    }];
    info.edgeBlock = edgeBlock?:[self edge:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
        return UIEdgeInsetsZero;
    }];
    
    info.headInfo = headInfo;
    info.footInfo = footInfo;
    return info;
}

+ (instancetype)subInfoWithHeight:(CellHeightBlock)heightBlock model:(_Nullable CellModelBlock)modelBlock{
    CellInfo *info = [self new];
    info.heightBlock = heightBlock?:[self height:^CGFloat(NSIndexPath *indexPath) {
        return 0;
    }];
    
    info.modelBlock = modelBlock?:[self model:^id(NSIndexPath *indexPath) {
        return nil;
    }];
    return info;
}

+ (CellHeightBlock)height:(CellHeightBlock)heightBlock
{
    return heightBlock;
}

+ (CellNumberBlock)number:(CellNumberBlock)numberBlock
{
    return numberBlock;
}

+ (CellModelBlock)model:(CellModelBlock)modelBlock
{
    return modelBlock;
}

+ (CellSizeBlock)size:(CellSizeBlock)sizeBlock
{
    return sizeBlock;
}

+ (CellEdgeBlock)edge:(CellEdgeBlock)edgeBlock
{
    return edgeBlock;
}
@end

@implementation NSMutableArray (CellInfo)

- (void)setArray:(NSArray *)otherArray count:(NSUInteger)count
{
    //count = MAX(1, count);
    for (int n = 0; n<count; n++) {
        [self addObjectsFromArray:otherArray];
    }
}

@end
NS_ASSUME_NONNULL_END