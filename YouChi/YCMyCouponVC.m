//
//  YCMyCouponVC.m
//  YouChi
//
//  Created by 朱国林 on 15/12/25.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyCouponVC.h"
#import "YCMyCouponVM.h"
#import "YCWebVC.h"
#import "YCMyCouponCell.h"

#define YCMyCouponNotification @"YCMyCouponNotification"
@interface YCMyCouponVCP ()
{
    
}
///viewModel
PROPERTY_STRONG_VM(YCMyCouponVM);

@end

@implementation YCMyCouponVCP
SYNTHESIZE_VM;
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabbar];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem.action = @selector(onCouponRule:);
    self.navigationItem.rightBarButtonItem.target = self;
    
    /// 标记已经进这个界面了，用于红点是否显示
    
    YCCache *cache =  [YCCache sharedCache];
    [cache.dataBase setObject:@(0) forKey:YCCouponStatueSave];
    
    if (!self.title) {
        self.title = @"优惠券";
    }
}




-(void)onCreachTabViewControl{
    NSArray *titles = @[@{@"最新优惠劵":@"coupon/getCouponList.json"},@{@"已领取":@"coupon/getUserCouponList.json"}];
    NSMutableArray *vcs = [NSMutableArray new];
    
    [titles enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tabControl insertSegmentWithTitle:dict.allKeys.firstObject image:nil];
        
        
        self.tabControl.normalColor = KBGCColor(@"#535353");
        YCMyCouponVC *vc = [YCMyCouponVC new];
        vc.viewModel  = [[YCMyCouponVM alloc]initWithURL:dict.allValues.firstObject];
        vc.chooseType = idx;
        [vcs addObject:vc];
    }];
    self.tabControl.hasBottomLine = YES;
    [self.tabVC setViewControllers:vcs animated:YES];
}


#pragma mark --使用规则
- (void)onCouponRule:(UIBarButtonItem *)sender {
    
    YCWebVC *web = [[YCWebVC alloc]initWithUrlString:@"http://api1-2.youchi365.com/shop/youmi/couponRule.html"];
    [self pushToVC:web];
    
}

@end


@interface YCMyCouponVC ()

///viewModel
@property(nonatomic,strong) YCMyCouponVM *viewModel;
@end

@implementation YCMyCouponVC
@synthesize viewModel;
-(void)onSetupCell
{
    [self onRegisterNibName:@"YCMyCouponCell" Identifier:cell0];
}


-(void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:^{
    
        [self onSetupEmptyView];
        
    } executing:self.executingBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    WSELF;
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCMyCouponNotification object:nil]subscribeNext:^(id x) {
        SSELF;
        [self onMainSignalExecute:nil];
    }];

}

-(void)onUpdateCell:(YCMyCouponCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    cell.btnType = (int)self.chooseType;
    cell.isCoupon = YES;
    [cell update:model atIndexPath:indexPath];
    [cell.btnChoose addTarget:self action:@selector(onUseAndDeldete:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onUseAndDeldete:(UIButton *)button{
    
        YCMyCouponCell *cell =button.findTableViewCell;
        NSIndexPath *index = [self indexPathForCell:cell];
        if (cell.btnType==buttonTypeCouponNewCoupon) {
            YCShopCategoryM *model = [self.viewModel modelForItemAtIndexPath:index];
            [button executeActivitySignal:[self.viewModel onReceiveCouPon:model.couponId] next:^(id next) {
                model.isReceived = @1;
                cell.blackView.hidden = NO;
      
           [button setBackgroundColor:[UIColor grayColor]];
              
                [self showMessage:@"领取成功"];
                
                [button setTitle:@"已获优惠卷" forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter]postNotificationName:YCMyCouponNotification object:nil];
            } error:self.errorBlock completed:nil executing:nil];
            
        }
        
        
    }

#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
}

- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        [self.emptyView updateConstraintsImage:@"暂无最新优惠券" title:nil];
        self.tableView.backgroundView = self.emptyView;
    }
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
