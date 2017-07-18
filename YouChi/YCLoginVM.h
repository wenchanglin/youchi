//
//  YCLoginVM.h
//  YouChi
//
//  Created by 李李善 on 15/5/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCLoginM.h"

typedef NS_ENUM(NSInteger, YCPlatform) {
    YCPlatformQQ,
    YCPlatformWeibo,
    YCPlatformWeixin,
};

@interface YCLoginVM : YCPageViewModel
@property (nonatomic,strong) NSString *loginId;
@property (nonatomic,strong) NSString *password;

@property (nonatomic,strong) NSMutableArray *loginIds;

- (RACSignal *)loginSignal;
- (RACSignal *)otherLoginSignal:(UIViewController *)vc type:(NSString *)platform;

- (NSString *)loadPasswordForLoginId:(NSString *)loginId;
@end
