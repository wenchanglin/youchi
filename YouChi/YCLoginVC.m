//
//  YCLoginVC.m
//  YouChi
//
//  Created by sam on 15/5/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLoginVC.h"
#import <EDColor/EDColor.h>
#import <Masonry/Masonry.h>
#import "YCLoginVM.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <UIImage-Resize/UIImage+Resize.h>
#import <LTNavigationBar/UINavigationBar+Awesome.h>
#import "YCTextField.h"
@interface YCLoginVC ()
{

}
@property (nonatomic,strong) YCLoginVM *viewModel;
@property (nonatomic,strong) IBOutlet UITextField *account;
@property (nonatomic,strong) IBOutlet UITextField *password;
@property (nonatomic,strong) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *bQQ;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2;
@property (weak, nonatomic) IBOutlet UIView *buttomView;

@end

@implementation YCLoginVC
@synthesize viewModel;

-(void)dealloc
{
    //OK
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UINavigationBar *nb = self.navigationController.navigationBar;
//    [nb lt_setBackgroundColor:[UIColor clearColor]];
//    [nb setShadowImage:[UIImage new]];
//    nb.translucent = YES;
    
    
    self.line1.constant = self.line2.constant = 0.5f;
    self.buttomView.frame = CGRectMake(0, 230, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 20 - 230);          

    
    UIButton *accountClear = [self.account valueForKey:@"_clearButton"];
    [accountClear setImage:[UIImage imageNamed:@"白色删除"] forState:UIControlStateNormal];
    
    UIButton *passwordClear = [self.password valueForKey:@"_clearButton"];
    [passwordClear setImage:[UIImage imageNamed:@"白色删除"] forState:UIControlStateNormal];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    UINavigationBar *nb = self.navigationController.navigationBar;
//    [nb lt_setBackgroundColor:[UIColor orangeColor]];
//    [nb setShadowImage:[UIImage new]];
    
    UIImage *image = [UIImage imageNamed:@"login_bg"];
    
    UIView *v = [[UIView alloc]initWithFrame:self.view.bounds];
    v.backgroundColor = KBGCColor(@"#000000");
    
    CGFloat y = self.logoImageView.frame.origin.y + self.logoImageView.frame.size.height;
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, y - 5, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44 - y + 5)];
    
    imv.image = image;
    
    [v addSubview:imv];
    
    self.tableView.backgroundView = v;
    
    
    RACChannelTo(self.viewModel,loginId) = self.account.rac_newTextChannel;
    RACChannelTo(self.viewModel,password) = self.password.rac_newTextChannel;
    
    self.account.text = self.viewModel.loginId;
    self.password.text = self.viewModel.password;
    
    
    self.bQQ.hidden = ![TencentOAuth iphoneQQInstalled];
    

    self.nextResponders = @[self.account,self.password];
}

- (id)onCreateViewModel
{
    return [YCLoginVM new];
}

- (void)onKeyboardDone:(id)sender
{
    [self onLogin:self.login];
}



#pragma mark-----登陆
- (IBAction)onLogin:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeBlack];
    [sender executeActivitySignal:[self.viewModel loginSignal] next:^(id x) {
        [self showmMidMessage:@"登录成功"];
        [self onReturn];        
    } error:self.errorBlock completed:^{
        [SVProgressHUD dismiss];
    } executing:self.executingBlock];
    
}





- (void)onReturn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark-----使用第三方登陆----
- (IBAction)onWeiBoLogin:(UIButton *)sender {
    WSELF;
    [[self.viewModel otherLoginSignal:self type:UMShareToSina]subscribeNext:^(id x) {
        SSELF;
        [self onReturn];
    } error:self.errorBlock];
}

- (IBAction)onQQLogin:(UIButton *)sender {
    WSELF;
    [[self.viewModel otherLoginSignal:self type:UMShareToQQ]subscribeNext:^(id x) {
        SSELF;
        [self onReturn];
    } error:self.errorBlock];
    
}

- (IBAction)onWeixinLogin:(UIButton *)sender {
    WSELF;
    [[self.viewModel otherLoginSignal:self type:UMShareToWechatSession]subscribeNext:^(id x) {
        SSELF;
        [self onReturn];
    } error:self.errorBlock];
}

- (IBAction)onSwitchAccount:(UITapGestureRecognizer *)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"账号列表" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSString *lid in self.viewModel.loginIds) {
        [as addButtonWithTitle:lid];
    }
    @weakify(as,self);
    [[as.rac_buttonClickedSignal ignore:@(as.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
        @strongify(as,self);
        NSString *lid = [as buttonTitleAtIndex:x.intValue];
        self.viewModel.loginId = lid;
        self.viewModel.password = [self.viewModel loadPasswordForLoginId:lid];
    }];
    [as showInView:self.view];
    
}

- (IBAction)onClearAccount:(UITapGestureRecognizer *)sender {
    NSString *msg = [[NSString alloc]initWithFormat:@"确定要清除在账号列表中的账号%@？",self.viewModel.loginId];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    WSELF;
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
        SSELF;
        [[YCUserDefault standardUserDefaults]savePassword:nil forLoginId:self.viewModel.loginId];
        BOOL b = [[YCUserDefault standardUserDefaults]removeLoginId:self.viewModel.loginId];
        if (b) {
            [self.viewModel.loginIds removeObject:self.viewModel.loginId];
            [self showMessage:@"已删除"];
        }else {
            [self showMessage:@"账号列表中没有这个账号哦"];
        }
    }];
    [av show];
}

- (IBAction)onSwitchParamters:(UITapGestureRecognizer *)sender {
    
    /*
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"切换参数" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [av addButtonWithTitle:@"内网"];
    [av addButtonWithTitle:@"外网"];
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
        
        int idx = x.intValue;
        if (idx == 1) {
            host = @"http://192.168.0.217:8888/youchi/";
            hostImage = @"http://192.168.0.217:8888/youchi/";
            html5 = @"http://192.168.0.55:8080/youchi/shop/youmi/index.html";
            html_share = @"http://192.168.0.55:8080/youchi/shop/youmi/";
        } else {
            host = @"http://api1-2.youchi365.com/";
            hostImage = @"http://img.youchi365.com/";
            html5 = @"http://api1-2.youchi365.com/shop/youmi/index.html";
            html_share = @"http://api1-2.youchi365.com/shop/youmi/";
        }
    }];
    [av show];
     */
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

@end


