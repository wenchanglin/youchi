//
//  YCPayVC.h
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewController.h"
#import "YCTableViewController.h"

typedef void(^isUpdata)();
@interface YCPayVCP : YCViewController

@property(nonatomic,strong) isUpdata updata;


@end



@interface YCPayVC : YCStaticViewController

@end
