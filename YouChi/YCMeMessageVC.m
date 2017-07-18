//
//  YCMeMessageVC.m
//  YouChi
//
//  Created by 李李善 on 15/5/30.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMeMessageVC.h"
#import "NSString+MJ.h"
#import "YCMeMessageVM.h"
#import "YCInputVC.h"
#import "YCPersonalProfileVC.h"
#import "YCViewController.h"
#import <PhotoEditFramework/PhotoEditFramework.h>
#import "YCEditPhotoVC.h"
#import "YCAvatarChooseVC.h"
@interface YCMeMessageVC ()<YCAvatarChooseVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UIImagePickerController *picker;
@property (strong, nonatomic) YCAvatarChooseVC *actionSheet;

@end



@implementation YCMeMessageVC
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.isTabBarHidden) {
        [self hideTabbar];
    }
}
- (void)dealloc{
    //ok
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    WSELF;
    YCMeMessageVM *vm = (id)self.viewModel;
    [RACObserve(vm, avatar) subscribeNext:^(NSString *x) {
        SSELF;
        [self.avatar ycNotShop_setImageWithURL:x placeholder:AVATAR];
    }];
    RAC(self.lName,text) = RACObserve(vm, name);
    RAC(self.lPhoneNum,text) = RACObserve(vm, phoneNum);
    RAC(self.lSignture,text) = RACObserve(vm, signture);
    RAC(self.lBirthday,text) = [RACObserve(vm, birthDay) map:^id(NSDate *value) {
        return [[[YCDateFormatter shareDateFormatter].formatter stringFromDate:value] substringToIndex:10];
    }];
    
    [RACObserve(vm, sex) subscribeNext:^(NSNumber *value) {
        SSELF;
        self.lSex.text = SEX(value.boolValue);
        self.imagvSex.image = SEX_IMAGE(value.boolValue);
    }];
    
    
    
}

- (id)onCreateViewModel{
    return [YCMeMessageVM new];
}

- (YCAvatarChooseVC *)actionSheet
{
    if (!_actionSheet) {
        
        YCAvatarChooseVC *vc =(id)[UIViewController vcClass:[YCAvatarChooseVC class]];
        vc.Delegate = self;
        
        _actionSheet = vc;
    }
    return _actionSheet;
    
}


#pragma mark - 选中行 ----签名
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0){
        if (indexPath.row==0){
            [self.actionSheet showSlideMenuFrom:UIPopoverArrowDirectionDown];
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        YCInputVM *vm = [[YCInputVM alloc]initWithViewModel:self.viewModel];
        vm.title = @"签名";
        [self pushTo:[YCInputVC class] viewModel:vm];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.5;
}

- (UIImagePickerController *)picker{
    if (!_picker) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        _picker = picker;
    }
    return _picker;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//        return section ==0 ? 1:0;
//
//}

#pragma mark---按钮的实现方法
- (void)avatarChoose:(YCAvatarChooseVC *)avatarChoose clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //    照相机
    if (buttonIndex==0)
    {// 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            self.picker.sourceType  =UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:nil];
        }
        else
        {
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示!!!" message:@"当前设备不支持照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    else if (buttonIndex==1)
    {
        self.picker.sourceType  = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
        
    }
    
    
}


#pragma mark--- 拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self showMessage:@"正在上传头像"];
    [picker dismissViewControllerAnimated:YES completion:^{
        //得到图片
        
        UIImage * image =[info objectForKey:UIImagePickerControllerEditedImage];
        
        
        YCMeMessageVM *vm = (id)self.viewModel;
        
        [self executeSignal:[vm uploadAvatarSignal:image] next:^(YCMeM *next) {
            
            [self showMessage:@"保存成功"];
            
        } error:self.errorBlock completed:^{
            [SVProgressHUD dismiss];
        } executing:self.executingBlock];
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [segue.destinationViewController setViewModel:self.viewModel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

















#pragma mark   昵称
@implementation YCMeMessageOneVC



-(void)dealloc
{
    //OK
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YCMeMessageVM *vm = (id)self.viewModel;
    self.inputNick.text = vm.name;
    [self.inputNick becomeFirstResponder];
}

- (IBAction)onSend:(UIBarButtonItem *)sender {
    
    [self.view endEditing:YES];
    
    CHECK(self.inputNick.text.length<=0, @"请输入昵称");
    CHECK(self.inputNick.text.length >= 14, @"你起的名字太长啦");
    YCMeMessageVM *vm = (id)self.viewModel;
    
    [sender executeSignal:[vm saveSignal:@"nickName" value:self.inputNick.text ] next:^(id next) {
        
        [self showMessage:@"保存成功"];
        [self onReturn];
    } error:self.errorBlock completed:nil executing:self.executingBlock];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

















#pragma mark   性别
@implementation YCMeMessageThreeVC


-(void)dealloc
{
    //OK
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YCMeMessageVM *vm = (id)self.viewModel;
    self.sex = vm.sex;
    if (self.sex)
    {
        self.SexOne.hidden = NO;
    }else
    {
        self.SexTwo.hidden = NO;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0)
    {
        self.SexOne.hidden = NO;
        self.SexTwo.hidden = YES;
    }else
    {   self.SexOne.hidden = YES;
        self.SexTwo.hidden = NO;
    }
    self.sex = indexPath.row==0 ? 1:0;
    
    
}

- (IBAction)onSend:(UIBarButtonItem *)sender {
    YCMeMessageVM *vm = (id)self.viewModel;
    [sender executeSignal:[vm saveSignal:@"sex" value:@(self.sex)] next:^(id next) {
        [self showMessage:@"保存成功"];
        [self onReturn];
    } error:self.errorBlock completed:nil executing:self.executingBlock];
    
}

// 头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end

















#pragma mark  手机号验证
@interface YCMeMessageFourVC()
{
    int second;
    
}
//定时器
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation YCMeMessageFourVC


-(void)dealloc
{
    //OK
}
- (void)viewDidLoad {
    [super viewDidLoad];
    second=60;
}


- (IBAction)onSend:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    
    
    YCMeMessageVM *vm = (id)self.viewModel;
    
    CHECK(self.phoneNumber.text.length<=0, @"请填写手机号");
    CHECK(self.phoneNumber.text.length<=0, @"请输入验证码");
    
    [sender executeSignal:[vm validatePhoneSignal:self.phoneNumber.text smsCode:self.identifyingCode.text] next:^(id next) {
        [self showMessage:@"手机验证成功"];
        [self onReturn];
    } error:self.errorBlock completed:nil executing:self.executingBlock];
}


-(void)timerStart
{
    second -=1;
    NSString *sting = [NSString stringWithFormat:@"%d秒",second];
    [_getSecurityCode setTitle:sting forState:UIControlStateNormal];
    _getSecurityCode.backgroundColor = [UIColor grayColor];
    if (second<=0)
    {
        _getSecurityCode.enabled = YES;
        _getSecurityCode.userInteractionEnabled = YES;
        [_timer invalidate];
        _timer=nil;
        [_getSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getSecurityCode.backgroundColor = [UIColor orangeColor];
        second=60;
    }
    
}

- (IBAction)onGetSmsCode:(UIButton *)sender {
    [self.view endEditing:YES];
    CHECK(self.phoneNumber.text.length<=0, @"请输入手机号码");
    YCMeMessageVM *vm = (id)self.viewModel;
    
    [sender executeActivitySignal:[vm getSmsCodeSignal:self.phoneNumber.text] next:^(id next) {
        sender.enabled = NO;
        sender.userInteractionEnabled = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:sender repeats:YES];
    } error:self.errorBlock completed:nil executing:self.executingBlock];
}

// 头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end



















#pragma mark   出生
@interface YCMeMessageFiveVC()

@end
@implementation YCMeMessageFiveVC

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self hideTabbar];
}



-(void)dealloc
{
    //OK
}
- (void)viewDidLoad {
    [super viewDidLoad];
    YCMeMessageVM *vm = (id)self.viewModel;
    NSDate *date = vm.birthDay;
    if (date && [date isKindOfClass:[NSDate class]]) {
        self.Date.date = date;
    }
    
    
}


- (IBAction)onSendDate:(UIBarButtonItem *)sender {
    YCMeMessageVM *vm = (id)self.viewModel;
    NSDate *date = self.Date.date;
    NSDate *origin = vm.birthDay;
    
    NSString *dateString = [NSString onChangeDate:date dateStyle:@"yyyy-MM-dd"];
    
    vm.birthDay = date;
    [sender executeSignal:[vm saveSignal:@"birthDay" value:dateString] next:^(id next) {
        [self showMessage:@"保存成功"];
        [self onReturn];
    } error:^(NSError *error) {
        self.errorBlock(error);
        
        vm.birthDay = origin;
    } completed:nil executing:self.executingBlock];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end








