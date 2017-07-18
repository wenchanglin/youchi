//
//  YCModifyPassword.m
//  YouChi
//
//  Created by 李李善 on 15/10/27.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCModifyPasswordVC.h"
#import "YCModifyPasswordVM.h"
#import "YCTextField.h"
@interface YCModifyPasswordVC ()
@property(nonatomic,strong) YCModifyPasswordVM *viewModel;

@property (weak, nonatomic) IBOutlet YCTextField *textFieldLodPassword;
@property (weak, nonatomic) IBOutlet YCTextField *textFieldNewPassword;
@property (weak, nonatomic) IBOutlet YCTextField *textFieldPassword;

@end

@implementation YCModifyPasswordVC
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.viewModel,password) = self.textFieldPassword.rac_textSignal ;
    RAC(self.viewModel,passwordNew) = self.textFieldNewPassword.rac_textSignal;
    RAC(self.viewModel,passwordOld) =  self.textFieldLodPassword.rac_textSignal ;

    self.nextResponders = @[self.textFieldPassword,self.textFieldNewPassword,self.textFieldLodPassword];
    
}

-(id)onCreateViewModel
{
    return [ YCModifyPasswordVM new];
  
}


- (IBAction)onModifyPassword:(UIButton *)sender {
    
    [self executeSignal:self.viewModel.mainSignal next:^(id next) {
         [self showMessage:@"修改密码成功"];
        [self onReturn];
    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
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
