//
//  YCFindPassWordVC.m
//  YouChi
//
//  Created by 李李善 on 15/6/1.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFindPassWordVC.h"
#import "YCFindPassWordVM.h"
#import <LTNavigationBar/UINavigationBar+Awesome.h>
@interface YCFindPassWordVC ()
{
    int miao;
    __weak IBOutlet UIButton *_getSecurityCode;
}

//定时器
@property (weak, nonatomic) NSTimer *timer;


//手机号和邮箱
@property (weak, nonatomic) IBOutlet UITextField *phoneEmal;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordOne;

//确认密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTwo;
PROPERTY_STRONG_VM(YCFindPassWordVM);


@end

@implementation YCFindPassWordVC
SYNTHESIZE_VM;

-(void)dealloc{
    //    ok
    
}


#warning mark----继承 YCTextFilid  这个列 ，就崩溃  注册 和找回密码）

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden= NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    miao= 60;
    RAC(self.viewModel,loginIdm) = self.phoneEmal.rac_textSignal;
    RAC(self.viewModel,smsCodem) = self.securityCode.rac_textSignal;
    RAC(self.viewModel,Onepasswordm) = self.passwordOne.rac_textSignal;
    RAC(self.viewModel,TWopasswordm) = self.passwordTwo.rac_textSignal;
    
    self.securityCode.text = self.viewModel.smsCodem;

    self.nextResponders = @[self.phoneEmal,self.securityCode,self.passwordOne,self.passwordTwo];
}


-(id)onCreateViewModel
{
    return [YCFindPassWordVM new];
}


// 获取验证码
- (IBAction)onGetSmsCode:(UIButton *)sender {
    
    [self.view endEditing:YES];
    CHECK(self.phoneEmal.text.length==0,@"请输入手机号码/邮箱");
    [sender executeActivitySignal:self.viewModel.getSmsCodeSignal next:^(id next) {
        [self showMessage:@"验证码已发送"];
        sender.enabled = NO;
        sender.highlighted = NO;
        sender.userInteractionEnabled = NO;
        //定时器
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:sender repeats:YES];
        
    } error:^(NSError *error) {
        [self showmMidMessage:error.localizedDescription];
    } completed:nil executing:nil];
    
}


-(void)timerStart
{
    miao -=1;
    NSString *sting = [[NSString alloc]initWithFormat:@"%d秒",miao];
    [_getSecurityCode setTitle:sting forState:UIControlStateNormal];
    _getSecurityCode.backgroundColor = [UIColor grayColor];
    if (miao==0)
    {   _getSecurityCode.enabled = YES;
        _getSecurityCode.userInteractionEnabled = YES;
        [_timer invalidate];
        _timer=nil;
        [_getSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getSecurityCode.backgroundColor = [UIColor colorWithRed:250.f/255.f green:190.f/255.f blue:30.f/255.f alpha:1];
        miao=60;
    }
    
}




- (IBAction)onSend:(UIButton *)sender {
    [sender executeActivitySignal:self.viewModel.FindPassWordSignal next:^(id next) {
        [self showMessage:@"成功找回密码"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } error:self.errorBlock completed:nil executing:self.executingBlock];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
