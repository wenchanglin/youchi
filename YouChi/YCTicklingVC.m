//
//  YCTicklingVC.m
//  YouChi
//
//  Created by 朱国林 on 15/7/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTicklingVC.h"
#import "YCSettingVC.h"
#import "YCMeMessageVC.h"
#import "YCTicklingVM.h"
#import "AppDelegate.h"
#import <GBDeviceInfo/GBDeviceInfo.h>

@interface YCTicklingVC ()

@property (weak, nonatomic) IBOutlet IQTextView *textViewAdvice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UILabel *lDevice;


@end

@implementation YCTicklingVC
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.isTabBarHidden) {
        [self hideTabbar];
    }
}
- (void)dealloc
{
    //  OK
}
- (id)onCreateViewModel
{
    return [YCTicklingVM new];
}
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    //[self.jianyi becomeFirstResponder];
    self.textViewAdvice.textColor = [UIColor blackColor];
    self.textViewAdvice.placeholder = @"请提出您的宝贵意见,如果被采纳的话,可以获得大量的友米!";
    self.textFieldPhone.text = [YCUserDefault currentUser].appUser.phone;
    
    GBDeviceInfo *info = [GBDeviceInfo deviceInfo];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    self.lDevice.text = [[NSString alloc]initWithFormat:@"系统版本：iOS%d.%d\n软件版本：%@.%@\n手机型号：%@\n",(int)info.osVersion.major,(int)info.osVersion.minor,app_Version,app_build,info.modelString];
}

- (IBAction)onSend:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    CHECK(self.textViewAdvice.text.length<=0, @"请输入您的反馈");
    
    CHECK(self.textFieldPhone.text.length<=0, @"请输入您的联系电话");
    
    YCTicklingVM *vm = (id)self.viewModel;
    
    NSString *title = [[NSString alloc]initWithFormat:@"手机号码：%@\n%@",self.textFieldPhone.text,self.lDevice.text];
    
    [sender executeSignal:[vm sendSignal:title advice:self.textViewAdvice.text] next:^(id next) {
        [self showMessage:@"发送成功！"];
        [self onReturn];
    } error:self.errorBlock completed:nil executing:self.executingBlock];
}


- (IBAction)onGoBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
