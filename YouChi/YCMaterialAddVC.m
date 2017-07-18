//
//  YCAddFruiVC.m
//  YouChi
//
//  Created by sam on 15/6/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMaterialAddVC.h"
#import "YCMaterialVM.h"
//#import <i.h>
@interface YCMaterialAddVC ()
@property (nonatomic,strong) YCMaterialVM *viewModel;
@end

@implementation YCMaterialAddVC
@synthesize viewModel;

- (void)dealloc{
    //ok
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)onSetupRefreshControl
{
    
}

- (void)onSetupActivityIndicatorView
{
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end


@interface YCMaterialAddVCP () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mingcheng;
@property (weak, nonatomic) IBOutlet UITextField *zhongliang;
@property (nonatomic,strong) YCMaterialVM *viewModel;
@end

@implementation YCMaterialAddVCP
@synthesize viewModel;

- (void)dealloc{
    //ok
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mingcheng becomeFirstResponder];
    
    if (self.viewModel.editModel) {
        self.mingcheng.text = self.viewModel.editModel.materialName;
        self.zhongliang.text = self.viewModel.editModel.quantity;
    }

    self.mingcheng.delegate = self.zhongliang.delegate = self;
}

#pragma mark - 完成添加
- (IBAction)onComplete:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    if (self.mingcheng.text.length<=0 || self.zhongliang.text.length<=0 ) {
        [self showMessage:@"请输入完整"];
        return;
    }
    
    
    if (!self.viewModel.editModel) {
        YCMaterialList *editModel = [YCMaterialList new];
        editModel.materialName = self.mingcheng.text;
        editModel.quantity = self.zhongliang.text;
        [self.viewModel addModel:editModel];
    } else {
        self.viewModel.editModel.materialName = self.mingcheng.text;
        self.viewModel.editModel.quantity = self.zhongliang.text;
        [self.viewModel notifyUpdate];
    }
    
    
    [self onReturn];
    
}

- (void)onReturn
{
    self.viewModel.editModel = nil;
    [super onReturn];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        
        UIButton *btn = [self.view viewByTag:textField.tag+1];
        [btn becomeFirstResponder];
        return NO;
    }
    
    else if (textField.returnKeyType == UIReturnKeyDone) {
        [self onComplete:nil];
    }
    return YES;
}
@end