//
//  YCWebVC.h
//  YouChi
//
//  Created by sam on 15/6/17.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewController.h"
#import "YCWebVM.h"

@interface YCWebVC : YCViewController <UIWebViewDelegate>
@property (nonatomic,strong,readonly) NSString *urlString;
- (instancetype)initWithUrlString:(NSString *)urlString;
@end


@interface YCShareM : NSObject
@property (nonatomic,strong) NSString *shareTitle,*shareContent,*shareImageUrl,*targetURL,*entityId;
@end