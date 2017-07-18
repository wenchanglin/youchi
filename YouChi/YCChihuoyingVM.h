//
//  YCChihuoyingVM.h
//  YouChi
//
//  Created by sam on 15/5/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCChihuoyingM.h"


#import "YCMeM.h"
@interface YCChihuoyingVM : YCPageViewModel

@property (strong,nonatomic) NSArray *cellFrames;


- (void)onSetupHeights:(NSArray *)models width:(CGFloat)width;

- (RACSignal *)onChangeGuysSignal:(NSIndexPath *)index;
- (RACSignal *)likeByByModel:(YCChihuoyingM_1_2 *)m;
- (RACSignal *)favoriteByModel:(YCChihuoyingM_1_2 *)m;
@end

@interface YCChihuoyingOtherVM : YCChihuoyingVM
@end