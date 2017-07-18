//
//  MGMRVMViewModel.m
//  mallgo-merchant
//
//  Created by Mallgo on 14-10-9.
//  Copyright (c) 2014年 mall-go. All rights reserved.
//

#import "YCViewModel.h"


@interface YCViewModel  ()
@end
@implementation YCViewModel

- (instancetype)initWithParameters:(NSDictionary *)aParameters
{
    self = [self init];
    if (self) {
        self.parameters = aParameters;
    }
    return self;
}

- (instancetype)initWithViewModel:(id)aViewModel
{
    self = [self init];
    if (self) {
        self.viewModel = aViewModel;
    }
    return self;
}

- (instancetype)initWithModel:(id)aModel
{
    self = [self init];
    if (self) {
        self.model = aModel;
    }
    return self;
}

- (instancetype)initWithId:(id)aId
{
    self = [self init];
    if (self) {
        self.Id = aId;
    }
    return self;
}

- (instancetype)initWithURL:(NSString * )url
{
    self = [self init];
    if (self) {
        self.urlString = url;
    }
    return self;
}

+ (instancetype)cacheViewModelByKey:(id)key
{
    YCCache *cache = [YCCache sharedCache];
    key = key?:NSStringFromClass([self class]);
    YCViewModel *vm = [cache.dataBase objectForKey:key];
    return vm;
}

+ (instancetype)cacheViewModel
{
    return [self cacheViewModelByKey:nil];
}

- (void)saveCacheViewModelByKey:(id)key
{
    YCCache *cache = [YCCache sharedCache];
    key = key?:NSStringFromClass([self class]);
    [cache.dataBase setValue:self forKey:key];
}

- (void)saveCacheViewModel
{
    
    [self saveCacheViewModelByKey:nil];
}

- (void)deleteCacheViewModelByKey:(id)key
{
    YCCache *cache = [YCCache sharedCache];
    key = key?:NSStringFromClass([self class]);
    [cache.dataBase removeObjectForKey:key];
}

- (void)deleteCacheViewModel
{
    [self deleteCacheViewModelByKey:nil];
}

- (id)Id
{
    if (!_Id) {
        return @0;
    }
    return _Id;
}

#pragma mark -
- (id)copyWithZone:(NSZone *)zone
{
    return [[self class]allocWithZone:zone];
}

#pragma mark -
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:self.Id forKey:KP(self.Id)];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.Id = [aDecoder decodeObjectForKey:KP(self.Id)];
    }
    return self;
}

#pragma mark -
- (void)dealloc
{
    
}


@end


@interface YCPageViewModel ()

@end

@implementation YCPageViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellIds = @[cell0,cell1,cell2,cell3,cell3_0,cell4,cell5,cell6,cell7,cell8,cell9,cell10,cell11,cell12,cell12_0,cell13,cell14,cell15,cell16,cell17,cell18];
        
        _modelsProxy = [NSMutableArray new];
    }
    return self;
}
- (YCPageInfo *)pageInfo
{
    if (!_pageInfo) {
        _pageInfo = [YCPageInfo new];
    }
    return _pageInfo;
}

#pragma mark - query
- (NSInteger)numberOfSections
{
    return 1;
}


- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.modelsProxy.count;
}


- (id)firstModel
{
    return [self.modelsProxy firstObject];
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.modelsProxy objectAtIndex:indexPath.row];
}

- (id)modelForItemAtIndex:(NSInteger)index
{
    return [self.modelsProxy objectAtIndex:index];
}

- (NSInteger)indexOfModel:(id)model
{
    return [self.modelsProxy indexOfObject:model];
}

- (NSIndexPath *)indexPathOfModel:(id)model
{
    return [NSIndexPath indexPathForItem:[self indexOfModel:model] inSection:0];
}

#pragma mark - actions
- (void)removeModel:(id)model
{
    [self.modelsProxy removeObject:model];

}

- (void)removeModelAtIndex:(NSInteger)index
{
    [self.modelsProxy removeObjectAtIndex:index];
}

- (void)removeModelAtIndexPath:(NSIndexPath *)indexPath
{
    [self.modelsProxy removeObjectAtIndex:indexPath.row];
}

- (void)removeAllModels
{
    [self.modelsProxy removeAllObjects];
}

- (void)replaceModelAtIndex:(NSInteger)index withObject:(id)object
{
    [self.modelsProxy replaceObjectAtIndex:index withObject:object];
}

- (void)replaceModelAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    [self.modelsProxy replaceObjectAtIndex:indexPath.row withObject:object];
}


- (void)insertModel:(id)model atIndex:(NSInteger)index
{
    [self.modelsProxy insertObject:model atIndex:index];
}

- (void)addModel:(id)model
{
    [self.modelsProxy addObject:model];
}

- (void)addModelsInfront:(NSArray *)models
{
    [self.modelsProxy insertObjects:models atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, models.count)]];
}

- (void)addModelsAtBack:(NSArray *)models
{
    [self.modelsProxy addObjectsFromArray:models];
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)fixedSize:(CGSize)fixedSize forItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(fixedSize.width, 44);
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    return [self heightForRowAtIndexPath:indexPath];

}

- (NSString *)headerIDInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)footerIDInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (YCNextBlock)nextBlock
{
    if (!_nextBlock) {
        WSELF;
        _nextBlock = ^(NSArray *x) {
//#ifdef DEBUG
            if (![x isKindOfClass:[NSArray class]]) {
                NSLog(@"不是 nsarray");
            }
//#endif

            SSELF;
            YCPageInfo *pageInfo = self.pageInfo;
            if (pageInfo.status == YCLoadingStatusRefresh) {

                [self.modelsProxy setArray:x];
                if ([x.firstObject respondsToSelector:@selector(Id)]) {
                    pageInfo.refreshId = pageInfo.loadmoreId = [x.firstObject Id];
                    pageInfo.pageNo = 1;
                }
                

            }

            else if (pageInfo.status == YCLoadingStatusLoadMore){
                [self.modelsProxy addObjectsFromArray:x];
            }
            
            else {
                [self.modelsProxy setArray:x];
                if ([x.firstObject respondsToSelector:@selector(Id)]) {
                    pageInfo.refreshId = pageInfo.loadmoreId = [x.firstObject Id];
                    pageInfo.pageNo = 1;
                }
            }

            
        };
    }

    return _nextBlock;
}
#pragma mark - property

- (void)notifyUpdate
{
    [self willChangeValueForKey:KP(self.modelsProxy)];
    [self didChangeValueForKey:KP(self.modelsProxy)];
}

- (void)dealloc
{
    //ok
   
}


@end

@implementation YCAutoPageViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellInfos = [NSMutableArray new];
    }
    return self;
}


- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    YCCellInfo *info = self.cellInfos[indexPath.section];
    return info.Id;
}

- (NSInteger)numberOfSections
{
    return self.cellInfos.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    YCCellInfo *info = self.cellInfos[section];
    return info.numberBlock(section);
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCCellInfo *info = self.cellInfos[indexPath.section];
    return info.heightBlock(indexPath);
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCCellInfo *info = self.cellInfos[indexPath.section];
    return info.modelBlock(indexPath);
}
@end

@implementation YCDynamicPageViewModel
{
    NSMutableDictionary *_cellIdMap;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellIdMap = [NSMutableDictionary new];
        
        [self setInfoBlock:^YCCellInfo *(NSIndexPath *indexPath) {
            return nil;
        }];
        [self setSectionBlock:^NSInteger{
            return 0;
        }];
        [self setRowBlock:^NSInteger(NSInteger section) {
            return 0;
        }];
    }
    return self;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    YCCellInfo *info = self.infoBlock(indexPath);
    return info.Id;
}

- (NSInteger)numberOfSections
{
    return self.sectionBlock();
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.rowBlock(section);
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCCellInfo *info = self.infoBlock(indexPath);
    return info?info.heightBlock(indexPath):0;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCCellInfo *info = self.infoBlock(indexPath);
    return info?info.modelBlock(indexPath):nil;
}
@end