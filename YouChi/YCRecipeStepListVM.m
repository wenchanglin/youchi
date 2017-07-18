//
//  YCNewSkillYM.m
//  YouChi
//
//  Created by 李李善 on 15/5/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRecipeStepListVM.h"
#import "YCRecipeStepListM.h"
@implementation YCRecipeStepListVM
{
    NSMutableArray *_modelsProxy;
}
- (void)dealloc{
    //ok
}

-(instancetype)initWithViewModel:(id)aViewModel
{
    if (self==[super initWithViewModel:aViewModel]) {
        self.materialVM = (id)aViewModel;
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

#pragma mark -
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.modelsProxy forKey:KP(self.modelsProxy)];
    [aCoder encodeObject:self.coverImage forKey:KP(self.coverImage)];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.modelsProxy = [aDecoder decodeObjectForKey:KP(self.modelsProxy)];
        self.coverImage = [aDecoder decodeObjectForKey:KP(self.coverImage)];

    }
    return self;
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    return self.modelsProxy.count;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell0;
}


- (CGSize)fixedSize:(CGSize)fixedSize forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hw = (fixedSize.width-10)/2;
    return CGSizeMake(hw, hw+30);
}

- (void)addModel:(id)model
{
    [self willChangeValueForKey:KP(self.modelsProxy)];
    [super addModel:model];
    [self didChangeValueForKey:KP(self.modelsProxy)];
}

- (void)insertModel:(id)model atIndex:(NSInteger)index
{
    [self willChangeValueForKey:KP(self.modelsProxy)];
    [super insertModel:model atIndex:index];
    [self didChangeValueForKey:KP(self.modelsProxy)];
}

- (void)removeModelAtIndexPath:(NSIndexPath *)indexPath
{
    [self willChangeValueForKey:KP(self.modelsProxy)];
    [super removeModelAtIndexPath:indexPath];
    [self didChangeValueForKey:KP(self.modelsProxy)];
}


- (RACSignal *)uploadSignal
{
    
    WSELF;
    RACSignal *paramSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        SSELF;
        
        [self saveCacheViewModel];
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        param[kToken] = [YCUserDefault currentToken];
        
        //普通参数
        param[@"name"] = [self.materialVM.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    
        [param addEntriesFromDictionary:[self.materialVM getSpendTimeByIndex:self.materialVM.spendTimeType]];
        param[@"difficulty"] = [[self.materialVM getDifficultyByType:self.materialVM.difficultyType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        param[@"description"] = [self.materialVM.describe stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        param[@"youchiId"] = self.materialVM.Id;
        

        //封面
        NSMutableDictionary *imageParam = [NSMutableDictionary new];
        if (self.coverImage) {
            NSData *data = UIImageJPEGRepresentation(self.coverImage, QUALITY);
            imageParam[@"recipeFile"] = data;
        }

        //步骤
        [self.modelsProxy enumerateObjectsUsingBlock:^(YCRecipeStepListM *buzhou, NSUInteger idx, BOOL *stop) {
            idx = idx+1;
            NSString *recipeStep = [[NSString alloc]initWithFormat:@"recipeStep[%d].",(int)idx];
            NSString *rmid = [recipeStep stringByAppendingString:@"seqNo"];
            NSString *rmName = [recipeStep stringByAppendingString:@"description"];
            
            param[rmid] = @(idx);
            param[rmName] = [buzhou.desc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *rmFile = [recipeStep stringByAppendingString:@"file"];
            UIImage *rmImage = buzhou.image;
            NSData *data = UIImageJPEGRepresentation(rmImage, QUALITY);
            imageParam[rmFile] = data;

            
        }];


        //材料
        [self.materialVM.modelsProxy enumerateObjectsUsingBlock:^(YCMaterialList *material, NSUInteger idx, BOOL *stop) {
            idx = idx+1;
            NSString *recipeMaterial = [[NSString alloc]initWithFormat:@"recipeMaterial[%d].",(int)idx];
            NSString *rmid = [recipeMaterial stringByAppendingString:@"materialId"];
            NSString *rmName = [recipeMaterial stringByAppendingString:@"materialName"];
            NSString *rmQuantity = [recipeMaterial stringByAppendingString:@"quantity"];
            
            
            param[rmid] = @(idx);
            param[rmName] = [material.materialName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            param[rmQuantity] = [material.quantity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        }];
        
        NSLog(@"uploadparam = %@\n",param);
        
        RACTuple *tuple = RACTuplePack(param,imageParam);
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        
        return nil;
    }]deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
    
    return [[paramSignal flattenMap:^RACStream *(RACTuple *value) {
        RACTupleUnpack(NSDictionary *param,NSDictionary *imageParam) = value;
        
      return [ENGINE POSTImages:apiRNewRecipe parameters:param dataOrUrlDict:imageParam parseClass:nil parseKey:nil];
    }] doNext:^(id x) {
        SSELF;
        [self.materialVM deleteCacheViewModel];
        [self deleteCacheViewModel];
    }].deliverOnMainThread;
    

}

- (RACSignal *)editSignal
{
    WSELF;
    RACSignal *paramSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        SSELF;
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        param[kToken] = [YCUserDefault currentToken];
        
        //普通参数
//        YCMaterialVM *materialVM = self.materialVM;
//        YCChihuoyingM_1_2 *materialModel = materialVM.model;
        
        
        param[@"name"] = [self.materialVM.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        [param addEntriesFromDictionary:[self.materialVM getSpendTimeByIndex:self.materialVM.spendTimeType]];
        
        param[@"description"] = [self.materialVM.describe stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        param[@"difficulty"] = [[self.materialVM getDifficultyByType:self.materialVM.difficultyType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        param[@"recipeId"] = self.materialVM.Id;
        
        
        //封面
        NSMutableDictionary *imageParam = [NSMutableDictionary new];
        if (self.isCoverImageChanged) {
            NSData *data = UIImageJPEGRepresentation(self.coverImage, QUALITY);
            imageParam[@"recipeFile"] = data;
        }
        
        //步骤
        [self.modelsProxy enumerateObjectsUsingBlock:^(YCRecipeStepListM *step, NSUInteger idx, BOOL *stop) {
            idx = idx+1;
            NSString *recipeStep = [[NSString alloc]initWithFormat:@"recipeStep[%d].",(int)idx];
            NSString *rsid = [recipeStep stringByAppendingString:@"seqNo"];
            NSString *rsName = [recipeStep stringByAppendingString:@"description"];
            
            
            param[rsid] = @(idx);
            param[rsName] = [step.desc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            if (step.ID) {
                NSString *recipeStepId = [recipeStep stringByAppendingString:@"id"];
                param[recipeStepId] = step.ID;
            }

            //新增
            if (step.image) {
                NSString *rsFile = [recipeStep stringByAppendingString:@"file"];
                UIImage *rsImage = step.image;
                NSData *data = UIImageJPEGRepresentation(rsImage, QUALITY);
                imageParam[rsFile] = data;
            }
        }];
        
        //食材
        [self.materialVM.modelsProxy enumerateObjectsUsingBlock:^(YCMaterialList *material, NSUInteger idx, BOOL *stop) {
            
            idx = idx+1;
            NSString *recipeMaterial = [[NSString alloc]initWithFormat:@"recipeMaterial[%d].",(int)idx];
            
            NSString *rmName = [recipeMaterial stringByAppendingString:@"materialName"];
            NSString *rmQuantity = [recipeMaterial stringByAppendingString:@"quantity"];
            
            param[rmName] = [material.materialName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            param[rmQuantity] = [material.quantity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


        }];
        
        NSLog(@"editparam = %@\n",param);
        
        RACTuple *tuple = RACTuplePack(param,imageParam);
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        
        return nil;
    }]deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
    
    return [paramSignal flattenMap:^RACStream *(RACTuple *value) {
        RACTupleUnpack(NSDictionary *param,NSDictionary *imageParam) = value;
        
        return [ENGINE POSTImages:apiREditRecipe parameters:param dataOrUrlDict:imageParam parseClass:nil parseKey:nil];
    }];
    
    
}




@end
