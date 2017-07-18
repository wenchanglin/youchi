//
//  YCViewController.h
//  YouChi
//
//  Created by sam on 15/5/18.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCViewModel.h"
#import "YCHttpClient.h"
#import "YCDefines.h"
#import "YCApis.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YCView.h"
#import "UIViewController+Action.h"
#import "YCMarcros.h"
#import <YYKit/YYKit.h>

@interface YCViewController : UIViewController
@property (nonatomic,strong) YCViewModel *viewModel;
@property (nonatomic,strong) YCNextBlock nextBlock;
@property (nonatomic,strong) YCErrorBlock errorBlock;
@property (nonatomic,strong) YCCompleteBlock completeBlock;
@property (nonatomic,strong) YCExecutingBlock executingBlock;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
- (id)onCreateViewModel;
@end


@interface YCPopViewController : YCViewController
- (IBAction)onClose:(UIButton *)sender;
@end


@interface YCKeyboardViewController : YCViewController <UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *bottomLayout;
@property (nonatomic,strong) IBOutlet UIView *inputBar;

- (void)keyboardWillShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification*)aNotification;
- (void)keyboardWillChangeFrame:(NSNotification*)aNotification;
@end




@interface YCViewController_v1 : UIViewController
PROPERTY_STRONG YCView *yc_view;
@end