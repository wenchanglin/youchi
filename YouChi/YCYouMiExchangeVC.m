//
//  YCYouMiExchangeVC.m
//  YouChi
//
//  Created by 李李善 on 15/12/31.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCYouMiExchangeVC.h"
#import "YCYouMiExchangeVM.h"
#import "YCMyCouponCell.h"
#import "YCAvatarView.h"
#import "YCWebVC.h"
#import "YCAvatarControl.h"

#import "YCYouMiExchangePayVC.h"


#import "YCItemDetailVC.h"
@interface YCYouMiExchangeVC ()

@property (weak, nonatomic) IBOutlet YCAvatarView *avatar;
PROPERTY_STRONG_VM(YCYouMiExchangeVM);
@end

@implementation YCYouMiExchangeVC
@dynamic viewModel;
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabbar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = self.viewModel.title;
    
    
    WSELF;
    [RACObserve(self.viewModel,appUser).deliverOnMainThread subscribeNext:^(YCLoginUserM *user) {
        SSELF;
        
        NSString *userName = user.nickName?:@"未登录";
        NSString *userYouMI = user.nickName?[NSString stringWithFormat:@"我拥有%d个友米",user.antCoin.intValue]:@"登陆后才知道拥有多少友米";
       [self.avatar updateAvatar:IMAGE_HOST_NOT_SHOP(user.imagePath) Name:userName hasYouMi:userYouMI];
    }];

}

-(id)onCreateViewModel{
    return [YCYouMiExchangeVM new];
}

-(void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}


-(void)onUpdateCell:(YCMyCouponCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    
    cell.btnType = buttonTypeExchangeYouMi;
    [cell update:model atIndexPath:indexPath];
    [cell.btnChoose addTarget:self action:@selector(onUse:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark-------点就单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        YCItemDetailVC *vc = [YCItemDetailVC vcClass:[YCItemDetailVC class]];
        YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:m.productId];
        if ([m.isMoneyPay intValue]==0) {
            vm.youMiModel = [YCShopOrderProductM new];
            vm.youMiModel.isMoneyPay = m.isMoneyPay;
            
        }
        vc.viewModel = vm;
        [self pushToVC:vc];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}



///立即使用
-(void)onUse:(UIButton *)btn{
    UITableViewCell *cell = btn.findTableViewCell;
    NSIndexPath *indx = [self.tableView indexPathForCell:cell];
    YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:indx];
    YCShopSpecM *model = m.shopSpecs.firstObject;
    
    CHECK([self.viewModel.appUser.antCoin intValue]<[model.antPrice intValue], @"友米不足,购买失败!!");
    [self executeSignal:[self.viewModel onPromptlyPayId:m.productId specId:model.specId] next:^(YCAboutGoodsM * next) {
        YCYouMiExchangePayVC *vc = [YCYouMiExchangePayVC vcClass];
        YCYouMiExchangePayVM *vm = [[YCYouMiExchangePayVM alloc]initWithModel:next];
        model.productImagePath = next.productImagePath;
        model.productName = next.productName;
        vm.shopSpecsModel = model;
        [self pushToVC:vc viewModel:vm];
    } error:^(NSError *error) {
        
        [self showMessage:@"兑换失败,请重新兑换-_-!!"];
    } completed:self.completeBlock executing:self.executingBlock];
    
}

- (IBAction)onGetMeYouMi:(id)sender {

    
    YCWebVC *web = [[YCWebVC alloc]initWithUrlString:@"http://api1-2.youchi365.com/shop/youmi/rule.html"];
    [self pushToVC:web];


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
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
