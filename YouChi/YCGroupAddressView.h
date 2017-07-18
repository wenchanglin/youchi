//
//  YCGroupAddressView.h
//  YouChi
//
//  Created by ant on 16/5/19.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCGroupOrderNumView.h"
#import <UIKit/UIKit.h>
#import "YCRecipientAddressM.h"
#import "YCMyOrderM.h"
@interface YCGroupAddressView : UIView

@property(nonatomic,strong)UIImageView *imgMapIcon;
@property(nonatomic,strong)UILabel *lTitleAddress;
@property(nonatomic,strong)UIImageView *imgAdd;
@property(nonatomic,strong)UILabel *lAddTitleAddress;
@property(nonatomic,strong)UILabel *lName;
@property(nonatomic,strong)UILabel *lPhone;
@property(nonatomic,strong)UILabel *lAddress;
@property(nonatomic,strong)UIImageView *imgArrow;
@property(nonatomic,strong)UIView *line;

- (void)onUpdataName:(NSString *)name phone:(NSString *)phone address:(NSString *)address;

- (void)updateRecipientAddress:(YCRecipientAddressM *)m;
@end
