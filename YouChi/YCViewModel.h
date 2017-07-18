//
//  MGMRVMViewModel.h
//  mallgo-merchant
//
//  Created by Mallgo on 14-10-9.
//  Copyright (c) 2014年 mall-go. All rights reserved.
//

#import "RVMViewModel.h"

#import <ReactiveViewModel/ReactiveViewModel.h>

#import "YCCatolog.h"
#import "YCMarcros.h"
#import "YCDefines.h"
#import "YCApis.h"
#import "YCUserDefault.h"
#import "YCPassValueHelper.h"
#import "YCViewModel.h"
#import "YCHttpClient.h"
#import "YCPageInfo.h"
#import "YCModel.h"
#import "YCCellInfo.h"


#define GETTER_LAZY_SUBJECT(_getter_) \
- (RACSubject *)_getter_ { \
if (!_ ## _getter_) { \
_ ## _getter_ = [RACSubject subject];\
}\
return _ ## _getter_;\
}\

#define GETTER_LAZY_REPLAY_SUBJECT(_getter_) \
- (RACReplaySubject *)_getter_ { \
if (!_ ## _getter_) { \
_ ## _getter_ = [RACReplaySubject subject];\
}\
return _ ## _getter_;\
}\

@interface YCViewModel : RVMViewModel <NSCopying,NSCoding>
@property (nonatomic,strong) __kindof YCViewModel *viewModel;
@property (nonatomic,strong) __kindof YCBaseModel *model;
@property (nonatomic,strong) NSNumber *Id;

@property (nonatomic,strong) YCBaseModel *previousModel;

@property (nonatomic,strong) RACSignal *mainSignal;


@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *urlString;

@property (nonatomic,strong) NSDictionary *parameters;


- (instancetype)initWithParameters:(NSDictionary *)aParameters;
- (instancetype)initWithViewModel:(YCViewModel *)aViewModel;
- (instancetype)initWithModel:(id)aModel;
- (instancetype)initWithId:(id)aId;

- (instancetype)initWithURL:(NSString * )url;

+ (instancetype)cacheViewModel;
+ (instancetype)cacheViewModelByKey:(id)key;
- (void )saveCacheViewModelByKey:(id)key;
- (void )saveCacheViewModel;
- (void )deleteCacheViewModelByKey:(id)key;
- (void )deleteCacheViewModel;
@end


@interface YCPageViewModel : YCViewModel

@property (nonatomic,strong) NSMutableArray *modelsProxy;
@property (nonatomic,strong) NSArray *cellIds,*headerFooterIds;

@property (nonatomic,strong) YCPageInfo *pageInfo;

@property (nonatomic,assign) NSInteger insertFrontSection;
@property (nonatomic,assign) NSInteger insertBackSection;

- (id)firstModel;
- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath;
- (id)modelForItemAtIndex:(NSInteger )index;
- (NSInteger )indexOfModel:(id)model;
- (NSIndexPath *)indexPathOfModel:(id)model;

- (void)removeModel:(id)model;
- (void)removeModelAtIndex:(NSInteger)index;
- (void)removeModelAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeAllModels;

- (void)replaceModelAtIndex:(NSInteger )index withObject:(id)object;
- (void)replaceModelAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (void)insertModel:(id)model atIndex:(NSInteger)index;
- (void)addModel:(id)model;

- (void)addModelsInfront:(NSArray *)models;
- (void)addModelsAtBack:(NSArray *)models;

#pragma mark --
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat )heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat )heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat )width;

- (NSString *)headerIDInSection:(NSInteger )section;
- (NSString *)footerIDInSection:(NSInteger )section;

- (CGFloat )heightForHeaderInSection:(NSInteger )section;
- (CGFloat )heightForFooterInSection:(NSInteger )section;

///collectionView;
- (CGSize)fixedSize:(CGSize)fixedSize forItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;

@property (nonatomic,strong) YCNextBlock nextBlock;
- (void)setNextBlock:(YCNextBlock)nextBlock;
- (void)notifyUpdate;
@end

@interface YCAutoPageViewModel : YCPageViewModel
@property (nonatomic,strong) NSMutableArray *cellInfos;

@end

typedef YCCellInfo *(^YCCellInfoBlock)(NSIndexPath *indexPath);
@interface YCDynamicPageViewModel : YCPageViewModel
@property (nonatomic,strong) YCCellInfoBlock infoBlock;
@property (nonatomic,strong) YCCellSectionBlock sectionBlock;
@property (nonatomic,strong) YCCellRowBlock rowBlock;
- (void)setInfoBlock:(YCCellInfoBlock)infoBlock;
- (void)setSectionBlock:(YCCellSectionBlock)sectionBlock;
- (void)setRowBlock:(YCCellRowBlock)rowBlock;
@end