//
//  YCYouMiExchangeVC.m
//  YouChi
//
//  Created by 李李善 on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyMoneyVM.h"
#import "YCMyMoneyVC.h"
#import "YCMyMoneyCell.h"
#import "YCPayVC.h"
#import "YCAvatarView.h"
#import "UIButton+MJ.h"
#import <Masonry/Masonry.h>
@interface YCMyMoneyVC ()
PROPERTY_STRONG_VM(YCMyMoneyVM);
@property (weak, nonatomic) IBOutlet YCAvatarView *myAvatar;

@property (weak, nonatomic) IBOutlet UILabel *myMoney;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@end

@implementation YCMyMoneyVC
@dynamic viewModel;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.isTabBarHidden) {
        [self hideTabbar];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WSELF;
    [RACObserve(self.viewModel,appUser).deliverOnMainThread subscribeNext:^(YCLoginUserM *user) {
        SSELF;
        int userMoney = [user.balance intValue]?:0;
        id userAvatar = user.imagePath?:nil;
        NSString *userName = user.nickName?:@"未登录";
        NSString *userYouMI = user.nickName?[NSString stringWithFormat:@"我拥有%d个友米",user.antCoin.intValue]:@"登陆后才知道拥有多少友米";
        self.myMoney.text = [NSString stringWithFormat:@"%d",userMoney];
        [self.myAvatar updateAvatar:userAvatar Name:userName hasYouMi:userYouMI];
    }];
  }

-(id)onCreateViewModel{
    return [YCMyMoneyVM new];
}

-(void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}


-(void)onUpdateCell:(UITableViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    [cell update:model atIndexPath:indexPath];
}

- (IBAction)onPuPayVC:(id)sender {
    YCPayVCP *vc = [YCPayVCP vcClass:[YCPayVC class]];
//    vc.updata =^(){
//        [self executeSignal:self.viewModel.onGetMyMoney next:^(YCLoginUserM * m) {
//            self.myMoney.text = [NSString stringWithFormat:@"%d",[m.balance intValue]];
//        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
//    };
    [self pushToVC:vc];
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
