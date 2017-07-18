//
//  YCPayVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPayVC.h"

#import "YCPayVM.h"
#import "YCErweimaVC.h"
@interface YCPayVCP ()
///viewModel
PROPERTY_STRONG_VM(YCPayVM);

@end

@implementation YCPayVCP
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.viewModel.title;
}


-(id)onCreateViewModel{
    return [YCPayVM new];
}

//查看充值卷使用规则细规
- (IBAction)onLookAtPay:(id)sender {
    
}

///充值
- (IBAction)onPay:(id)sender {
    
    [self showMessage:@"充值还没有,请尽情期待Y(^_^)Y"];
//    CHECK(self.viewModel.number.length <=0,@"充值号码不能为空");
//    [sender executeActivitySignal:self.viewModel.onPay next:^(id next) {
//        [self showMessage:@"充值成功"];
//        if (self.updata) {
//            self.updata();
//        }
//        [self onReturn];
//    } error:self.errorBlock completed:nil executing:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    [segue.destinationViewController setViewModel:self.viewModel];
}


@end


@interface YCPayVC ()
///viewModel
@property(nonatomic,strong) YCPayVM *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UITextField *PayNumber;

@end

@implementation YCPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    RAC(self.viewModel,number) = self.PayNumber.rac_textSignal;
}

//-(void)onMainSignalExecute:(UIRefreshControl *)sender
//{
//    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:^{
//        
//    } executing:self.executingBlock];
//}

///扫一扫
- (IBAction)onQRCode:(id)sender {

    [self pushTo:[YCErweimaVC class]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
