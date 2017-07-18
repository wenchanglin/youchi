//
//  YCWebVM.h
//  YouChi
//
//  Created by sam on 15/6/17.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"

@interface YCWebVM : YCViewModel
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *shareText;
@property (nonatomic,strong) NSString *shareUrl;
@property (nonatomic,strong) NSString *shareImageUrl;
- (instancetype)initWithUrl:(NSString *)url;
@end
