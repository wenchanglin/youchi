//
//  YCSearchVM.m
//  YouChi
//
//  Created by 李李善 on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchVM.h"
@implementation YCSearchVM
{
    NSArray *history;
}
- (void)dealloc
{
    //    OK
}

-(instancetype)init
{
    if(self == [super init])
    {
        self.historyArrs = [[YCCache sharedCache].dataBase objectForKey:KP(self.historyArrs)];
        
        if (!self.historyArrs) {
            self.historyArrs = [[NSMutableArray alloc]initWithCapacity:0];
        }

        history = self.historyArrs.copy;
        
        WSELF;
        [self.didBecomeInactiveSignal subscribeNext:^(id x) {
            SSELF;
            [self saveSearchHistory];
        }];
        
   
    }
    return self;
}

- (void)saveSearchHistory
{
    if (![self.historyArrs isEqualToArray:history]) {
        history = self.historyArrs.copy;
        [[YCCache sharedCache].dataBase setObject:self.historyArrs forKey:KP(self.historyArrs)];
    }
}

//- (NSInteger)numberOfSections
//{
//    return 2;
//}

-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    
    return self.historyArrs.count;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0) return cell0;
//    else{
        if (self.historyArrs.count==1)  return cell1_3;
        else
        {
            if (indexPath.row==0) return cell1_0;
            
            else if (indexPath.row==self.historyArrs.count-1) return cell1_2;
            
            return cell1_1;
        }
        
//    }
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section==0)  return 45.f;
//    else{
        if (indexPath.row==0) return 45.f;
        return 35.f;
//    }
}

- (void)onSearch:(NSString *)search
{
    if (search != nil && ![search isEqualToString:@""]) {
        if ([self.historyArrs containsObject:search]) {
            [self.historyArrs removeObject:search];
        }
        [self.historyArrs insertObject:search atIndex:0];
        
    }
}

-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section !=0) {
        return [self.historyArrs objectAtIndex:indexPath.row];
//    }
//    return nil;
}


@end
