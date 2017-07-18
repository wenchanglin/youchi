//
//  YCModifyPasswordVM.h
//  YouChi
//
//  Created by 李李善 on 15/10/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"

@interface YCModifyPasswordVM : YCPageViewModel
@property(nonatomic,strong) NSString  *passwordNew;
@property(nonatomic,strong) NSString  *password;
@property(nonatomic,strong) NSString  *passwordOld;
@end
