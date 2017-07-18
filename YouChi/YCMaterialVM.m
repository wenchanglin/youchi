//
//  YCMuchFruitVM.m
//  YouChi
//
//  Created by 李李善 on 15/5/22.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMaterialVM.h"
#import "YCChihuoyingM.h"


@implementation YCMaterialVM
{
    NSMutableArray *_modelsProxy;
}
#pragma mark -
- (void)dealloc{
    //ok
}

- (instancetype)initWithModel:(id)aModel
{
    if (self =[super init]) {
        self.difficultyType = self.spendTimeType = 0;
        YCMaterialAddM *m = [YCMaterialAddM new];
        m.materialName = aModel;
        m.quantity = nil;
        [self.modelsProxy addObject:m];
        
        self.title = aModel;
    }
    return self;
}


- (NSMutableArray *)modelsProxy
{
    if (!_modelsProxy) {
        _modelsProxy = [NSMutableArray new];
    }
    return _modelsProxy;
}

- (void)setModelsProxy:(NSMutableArray *)modelsProxy
{
    _modelsProxy = modelsProxy;
}

- (NSArray *)difficultys{
    if (!_difficultys) {
        _difficultys = @[@"初级",@"中级",@"高级",];
    }
    return _difficultys;
}

- (NSArray *)spendTimes{
    if (!_spendTimes) {
        _spendTimes = @[@"10分钟以下",@"10-30分钟",@"30-60分钟",@"一小时以上",];
    }
    return _spendTimes;
}


- (NSDictionary *)getSpendTimeByIndex:(NSInteger)index
{
    int minSpendTime,maxSpendTime;
    switch (index) {
        case 0:
            minSpendTime = 0;
            maxSpendTime = 10;
            break;
        case 1:
            minSpendTime = 10;
            maxSpendTime = 30;
            break;
        case 2:
            minSpendTime = 30;
            maxSpendTime = 60;
            break;
        case 3:
            minSpendTime = 60;
            maxSpendTime = -1;
            break;
        default:
            NSAssert(0, @"木有这个类型");
            break;
    }
    return @{@"minSpendTime":@(minSpendTime),@"maxSpendTime":@(maxSpendTime),};
}

- (NSString *)getSpendTimeStringByTime:(int)maxSpendTime
{
    if (maxSpendTime == 10) {
        self.spendTimeType = 0;
    }
    
    else if (maxSpendTime == 30 ) {
        self.spendTimeType = 1;
    }
    
    else if (maxSpendTime == 60 ) {
        self.spendTimeType = 2;
    }
    
    else {
        self.spendTimeType = 3;
    }
    return self.spendTimes[self.spendTimeType];
}

- (NSString *)getDifficultyByType:(NSInteger)index
{
    self.difficultyType = index;
    return  self.difficultys[index];
}

#pragma mark -
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
 
    [aCoder encodeObject:self.name forKey:KP(self.name)];
    
    
    [aCoder encodeInteger:self.difficultyType forKey:KP(self.difficultyType)];
    [aCoder encodeInteger:self.spendTimeType forKey:KP(self.spendTimeType)];
    
    
    [aCoder encodeObject:self.describe forKey:KP(self.describe)];
    [aCoder encodeObject:self.modelsProxy forKey:KP(self.modelsProxy)];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder])
    {
        self.name = [aDecoder decodeObjectForKey:KP(self.name)];
        
        self.difficultyType = [aDecoder decodeIntForKey:KP(self.difficultyType)];
        self.spendTimeType = [aDecoder decodeIntForKey:KP(self.spendTimeType)];
        self.describe = [aDecoder decodeObjectForKey:KP(self.describe)];
        
        self.modelsProxy = [aDecoder decodeObjectForKey:KP(self.modelsProxy)];
        
    }
    return self;
}



#pragma mark -
-(NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [super numberOfItemsInSection:section];
    
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell1;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [super modelForItemAtIndexPath:indexPath];
    }
    return nil;
}

- (void )addModel:(id)model
{
    [self willChangeValueForKey:KP(self.modelsProxy)];
    [super addModel:model];
    [self didChangeValueForKey:KP(self.modelsProxy)];
}

- (void )updateMyData:(YCChihuoyingM_1_2 *)x
{
        self.name = x.name;
        self.describe = x.desc;
        
        [self.modelsProxy addObjectsFromArray:x.recipeMaterialList];
        [self notifyUpdate];

}


//- (RACSignal *)uploadSignal
//- (RACSignal *)editSignal
@end
