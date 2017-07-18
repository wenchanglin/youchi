//
//  YCRegisterVC.m
//  YouChi
//
//  Created by sam on 15/5/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCTextField.h"
#import "YCRegisterVC.h"
#import <EDColor/EDColor.h>
#import "YCRegisterVM.h"
#import "YCWebVC.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <LTNavigationBar/UINavigationBar+Awesome.h>
@interface YCRegisterVC ()<TTTAttributedLabelDelegate>


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
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *registerAndLogin;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *userProtocol;
PROPERTY_STRONG_VM(YCRegisterVM);
@end


@implementation YCRegisterVC
SYNTHESIZE_VM;

- (void)dealloc{
    //ok
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer=nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //60秒钟
    
    UIButton *accountClear = [self.securityCode valueForKey:@"_clearButton"];
    [accountClear setImage:[UIImage imageNamed:@"白色删除"] forState:UIControlStateNormal];
    
    UIButton *passwordClear = [self.password valueForKey:@"_clearButton"];
    [passwordClear setImage:[UIImage imageNamed:@"白色删除"] forState:UIControlStateNormal];
    
    UIButton *phoneEmal = [self.phoneEmal valueForKey:@"_clearButton"];
    [phoneEmal setImage:[UIImage imageNamed:@"白色删除"] forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:@"login_bg"];
    
    UIView *v = [[UIView alloc]initWithFrame:self.view.bounds];
    v.backgroundColor = KBGCColor(@"#000000");
    
    CGFloat y = self.logoImageView.frame.origin.y + self.logoImageView.frame.size.height;
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, y - 5, SCREEN_WIDTH, SCREEN_HEIGHT - y - 20 - 44 + 5)];
    
    imv.image = image;
    
    [v addSubview:imv];
    
    self.tableView.backgroundView = v;
    
    
    miao=60;
    _userProtocol.text = @"注册即表示同意《友吃服务使用协议》、《隐私条款》";
    _userProtocol.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    _userProtocol.linkAttributes = @{
                                             (NSString *)kCTForegroundColorAttributeName:(id)[color_title CGColor],
                                             NSFontAttributeName: [UIFont systemFontOfSize:11],
                                             };
    _userProtocol.delegate = self;
    [_userProtocol addLinkToURL:[NSURL URLWithString:apiRuleRegister] withRange:[_userProtocol.text rangeOfString:@"《友吃服务使用协议》"]];
    [_userProtocol addLinkToURL:[NSURL URLWithString:apiConcealRegister] withRange:[_userProtocol.text rangeOfString:@"《隐私条款》"]];
    

    RAC(self.viewModel,loginId) = self.phoneEmal.rac_textSignal;
    RAC(self.viewModel,smsCode) = self.securityCode.rac_textSignal;
    RAC(self.viewModel,password) = self.password.rac_textSignal;
    
    self.nextResponders = @[self.phoneEmal,self.securityCode,self.password];
    
    
}

- (id)onCreateViewModel
{
    return [YCRegisterVM new];
}


- (IBAction)onGetSmsCode:(UIButton *)sender {
    [self.view endEditing:YES];
    [sender executeActivitySignal:self.viewModel.getSmsCodeSignal next:^(id next) {
        [self showMessage:@"验证码已发送！"];
        //定时器
        sender.enabled = NO;
        sender.highlighted = NO;
        sender.userInteractionEnabled = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:sender repeats:YES];
    } error:self.errorBlock completed:nil executing:nil];
}

-(void)timerStart
{
    miao -=1;
    NSString *sting = [NSString stringWithFormat:@"%d秒",miao];
    [_getSecurityCode setTitle:sting forState:UIControlStateNormal];
    _getSecurityCode.backgroundColor = [UIColor grayColor];
    if (miao<=0)
    {
         _getSecurityCode.enabled = YES;
        _getSecurityCode.userInteractionEnabled = YES;
        [_timer invalidate];
        _timer=nil;
        [_getSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getSecurityCode.backgroundColor = [UIColor blackColor];
        miao=60;
    }
  
}

- (void)onKeyboardDone:(id)sender{
    
    [self onLoginAndRegiste:self.registerAndLogin];
    
}


- (IBAction)onLoginAndRegiste:(UIButton *)sender {
    
    [self.view endEditing:YES];
    WSELF;
    [sender executeActivitySignal:self.viewModel.registerAndLoginSignal next:^(id next) {
        SSELF;
        [self showMessage:@"注册成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        RDVTabBarController *tbc = self.navigationController.rdv_tabBarController;
        tbc.selectedIndex = 0;
    } error:self.errorBlock completed:nil executing:self.executingBlock];
    
}


- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    YCWebVM *vm = [YCWebVM new];
    vm.url = url.absoluteString;
    [self pushTo:[YCWebVC class] viewModel:vm];
}

- (void)textFieldDidBeginEditing:(YCTextField *)textField{
    
    [textField lineColorSelected:color_title];
    [textField setValue:color_title forKeyPath:@"_placeholderLabel.textColor"];
    
}

- (void)textFieldDidEndEditing:(YCTextField *)textField{
    
    [textField lineColorNormal:KBGCColor(@"#88888c")];
    [textField setValue:KBGCColor(@"#ececec") forKeyPath:@"_placeholderLabel.textColor"];
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
