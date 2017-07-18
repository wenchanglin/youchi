//
//  YCAvatarChooseVC.h
//  YouChi
//
//  Created by 李李善 on 15/9/1.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewController.h"
#import "UIButton+MJ.h"
///相册和拍照

@protocol YCAvatarChooseVCDelegate;

@interface YCAvatarChooseVC : YCPopViewController

@property(nonatomic,assign) id<YCAvatarChooseVCDelegate> Delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewHeight;


@end

@protocol YCAvatarChooseVCDelegate <NSObject>
@required //必选
@optional //可选
- (void)avatarChoose:(YCAvatarChooseVC *)avatarChoose clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

