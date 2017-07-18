//
//  YCFarmingParameterVM.m
//  YouChi
//
//  Created by 李李善 on 16/1/22.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFarmingParameterVM.h"

@implementation YCFarmingParameterVM
-(instancetype)initWithModel:(id)aModel{
    
 if (self==[super initWithModel:aModel]) {
     self.itemDetailM =aModel;
    self.title = @"农业参数";
    }
      return self;
}
-(NSInteger)numberOfItemsInSection:(NSInteger)section{
    return self.itemDetailM.shopProductParameters.count;
}
-(NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    return cell0;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return  self.itemDetailM.shopProductParameters[indexPath.row];
}


@end
