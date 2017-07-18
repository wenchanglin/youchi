//
//  YCSmallHelperTwoDetailedVM.m
//  YouChi
//
//  Created by 李李善 on 15/5/26.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGuodanDetailVM.h"
#import "YCCatolog.h"
@implementation YCGuodanDetailVM
@synthesize model;
- (void)dealloc{
    //ok
}
- (NSInteger)numberOfSections
{
    return self.model?4:0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    if (section < 3 ) {
        return 1;
    }
    
    else if (section == 3)
    {
        return 4;
    }
    
    else
    {
        return 10;
        
    }
    
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.model;
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellIds[indexPath.section];
}


- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    if (indexPath.section == 0) {
        return DAMAI_RATIO_2(SCREEN_WIDTH, 452,339);
    }
    else if (indexPath.section == 1) {
        return 30;
    }
    if (indexPath.section == 2) {
        return [self.model.desc heightForFontSize:14 andWidth:SCREEN_WIDTH-8*2]+8+8;
        
    }
    else if (indexPath.section==3)
    {
        NSString *str = nil;
        switch (indexPath.row) {
            case 0:
            {
                str = self.model.effect;
            }
                break;
            case 1:
            {
                str = self.model.suitableFor;
            }
                break;
            case 2:
            {
                str = self.model.nutrition;
            }
                break;
            case 3:
            {
                str = self.model.taboo;
            }
                break;
                
            default:
                break;
        }
        return [str heightForFontSize:14 andWidth:SCREEN_WIDTH-60-8]+10;
    }

    return 0;
}

- (RACSignal *)mainSignal
{
 
    
    WSELF;
    return [[ENGINE POST_shop_array:apiRPGetMaterial  parameters:@{@"materialId":self.Id} parseClass:[YCGuopinDetailM class] pageInfo:nil]doNext:^(id x) {
        SSELF;
        self.model = x;

    }];
}

@end
