//
//  YCShopCategoryVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopCategoryVM.h"
@implementation YCShopCategoryVM

-(instancetype)init
{
    if (self==[super init]) {
        self.title  =@"品类";
        self.selsectBtn = 0;
        self.shops=  [NSMutableArray arrayWithCapacity:0];
        self.titles = [NSMutableArray arrayWithCapacity:0];
       
        
    }
    return self;
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    if (self.shops.count != 0) {
        @try {
            return [self.shops[self.selsectBtn] count]+1;
        }
        @catch (NSException *exception) {
            
        }
        @finally {}
    }
    return 0;
    
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if (indexPath.row == [self.shops[self.selsectBtn] count] ) {
            
            return cell2;
        }else
            
        return cell1;
    }
    @catch (NSException *exception) {
    }
    @finally {}
    
    return [super cellIDAtIndexPath:indexPath];

}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < [self.shops[self.selsectBtn] count]) {
        YCShopCategorySubsM *m = self.shops[self.selsectBtn][indexPath.row];
        
        // 如果给有宽高，直接取
        if (m.height && m.width) {
            
            return DAMAI_RATIO_2(SCREEN_WIDTH, m.width, m.height)+2;
        }
        
        // 如果没，在图片里取
        else {
            
            NSString *strUrl = [NSString stringWithFormat:@"%@",m.imagePath];
            
            // 如果图片取得到，直接用
            if ([strUrl rangeOfString:@"$"].location !=NSNotFound) {
            
                NSString *width = nil;
                NSString *height = nil;
                
                NSArray *arr = [strUrl componentsSeparatedByString:@"$"];
                
                width = arr[1];
                height = arr[2];
                
                return DAMAI_RATIO_2(SCREEN_WIDTH, width.floatValue, height.floatValue)+2;
            }
        }
        // 图片取不到，用默认值
        return DAMAI_RATIO_2(SCREEN_WIDTH, 750, 340)+2;
    }

    if (indexPath.row == [self.shops[self.selsectBtn] count] ) {
        return 60;
    }
    
    else {
        
        return 140.f;
    }
}



- (RACSignal *)mainSignal{
    
    WSELF;
       return [[ENGINE POST_shop_array:@"category/getCategoryPar.json" parameters:nil parseClass:[YCShopCategoryM class] pageInfo:self.pageInfo]doNext:^(NSArray  *x) {
          SSELF;
           
           
           if (self.nextBlock) {
               for (YCShopCategoryM *  m in x) {
                   [self.titles addObject:m.categoryName];
                   [self.shops addObject:m.shopCategorySubs];
               }
               self.nextBlock(x);
           }
    }];
    
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if (indexPath.row == [self.shops[self.selsectBtn] count]) {
            return nil;
        }
         return self.shops[self.selsectBtn][indexPath.row];
    }
    @catch (NSException *exception) {
        
    }
    @finally {}
    return nil;
}

@end
