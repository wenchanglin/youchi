//
//  YCPrivateBookingVC.h 
//  YouChi
//
//  Created by sam on 15/5/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCChihuoyingVC.h"

@class YCPrivateBookingVC;
@interface YCPrivateBookingVCP : YCStaticViewController


@end


@interface YCPrivateBookingVC : YCChihuoyingVC
@property (nonatomic,weak) YCPrivateBookingVCP *privateBookingContainerVC;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) NSString *XIXI;
@end

