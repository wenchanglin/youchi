//
//  YCOthersInfoVM.h
//  YouChi
//
//  Created by 李李善 on 15/8/21.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPersonalProfileVM.h"
#import "YCChihuoyingVM.h"



@interface YCOthersInfoVM : YCChihuoyingVM
@property (nonatomic,strong) YCLoginUserM *appUser; ///用户信息
@property (nonatomic,strong)NSString *cellId;
@property (nonatomic,strong)NSString *parseKey;
@property (nonatomic,strong)YCChihuoyingM_1_2 *model;
-(void)onSelectWithInteger:(NSInteger )integer;

@end
