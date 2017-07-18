//
//  YCMeMessageVC.h
//  YouChi
//
//  Created by 李李善 on 15/5/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"

#import <IQKeyboardManager/IQTextView.h>
@interface YCMeMessageVC : YCStaticViewController
///头像
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
///名字
@property (weak, nonatomic) IBOutlet UILabel *lName;
///出生
@property (weak, nonatomic) IBOutlet UILabel *lBirthday;
///签名
@property (weak, nonatomic) IBOutlet UILabel *lSignture;
///电话号码
@property (weak, nonatomic) IBOutlet UILabel *lPhoneNum;
///性别
@property (weak, nonatomic) IBOutlet UILabel *lSex;

@property (weak, nonatomic) IBOutlet UIImageView *imagvSex;

@end



///昵称
@interface YCMeMessageOneVC : YCStaticViewController
@property (weak, nonatomic) IBOutlet UITextField *inputNick;

@end



///性别
@interface YCMeMessageThreeVC : YCStaticViewController

@property(nonatomic,assign) BOOL sex;
@property (weak, nonatomic) IBOutlet UIImageView *SexOne;///男
@property (weak,nonatomic)  IBOutlet UIImageView *SexTwo;///女

@end


///手机号验证
@interface YCMeMessageFourVC : YCStaticViewController

@property(weak,nonatomic) IBOutlet UIButton *getSecurityCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCode;
;

@end




///出生日期
@interface YCMeMessageFiveVC : YCViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *Date;
@end





