//
//  YCEditAddressVC.h
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCEditAddressVM.h"

@interface YCEditAddressVCP : YCViewController

@end


@interface YCEditAddressVC : YCStaticViewController

@property (nonatomic,assign)BOOL isLocation;


///名字
@property(nonatomic,strong)IBOutlet UITextField *name;
///电话号码
@property(nonatomic,strong)IBOutlet UITextField *phone;
///邮编号码
@property(nonatomic,strong)IBOutlet UITextField *postcode;
///详细地址
@property(nonatomic,strong)IBOutlet UITextField *detailAddress;
@end
