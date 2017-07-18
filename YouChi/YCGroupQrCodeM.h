//
//  YCGroupQrCodeM.h
//  YouChi
//
//  Created by ant on 16/5/26.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.  qrcodePath
//
#import "YCRecipientAddressM.h"
#import "YCMyInitiateGroupM.h"

@interface YCGroupQrCodeM : YCItemDetailM
//@property(nonatomic,strong) YCRecipientAddressM *shopUserAddress;
@property(nonatomic,strong) NSString *addStr;
@property(nonatomic,strong) NSURL *qrcodePath;
@end
