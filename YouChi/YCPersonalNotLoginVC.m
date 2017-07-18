//
//  YCPersonalNotLoginVC.m
//  YouChi
//
//  Created by 李李善 on 15/9/29.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPersonalNotLoginVC.h"
#import "YCPersonalNotLoginVM.h"
#import "YCLoginVC.h"
#import "YCRegisterVC.h"

#import "YCSettingVC.h"


@interface YCPersonalNotLoginVC ()
@property (strong, nonatomic)YCPersonalNotLoginVM *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateTopHeight;


@end

@implementation YCPersonalNotLoginVC
@synthesize viewModel;
- (void)dealloc{

    //Ok
}
-(void)awakeFromNib
{
    //    ok
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}


- (void)viewDidLoad {
    

    ///登录刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDismiss) name:YCUserDefaultUpdate object:nil];
    
    [super viewDidLoad];
    if (KSize.height<=568) {
        self.updateTopHeight.constant = 65;
    }
  
}





//-(id)onCreateViewModel
//{
//    return [YCPersonalNotLoginVM new];
//}

/**
 1:登陆
 2:注册
 
 */

- (IBAction)onSelectButton:(UIButton *)sender {
    switch (sender.tag) {
            
        case 1:
        {
            UIViewController *vc = [UIViewController vcClass:[YCLoginVC class] vcId:NSStringFromClass([YCLoginVC class])];
            vc.navigationItem.leftBarButtonItem.action = @selector(onDismissReturn);
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 2:
        {
            
            YCRegisterVC *vc = [YCRegisterVC vcClass:[YCLoginVC class] vcId:NSStringFromClass([YCRegisterVC class])];
            vc.navigationItem.leftBarButtonItem.action = @selector(onDismissReturn);
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}


/**

 跳转到设置界面
 
 */


-(void)onDismiss{
   
//    [self onReturn];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onSettingVC:(UIButton *)sender {
  
    if ([self pushToLoginVCIfNotLogin]) {
        return ;
    }
    YCSettingVM *vm = [[YCSettingVM alloc]initWithViewModel:self.viewModel];
    [self pushTo:[YCSettingVC class] viewModel:vm hideTabBar:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
