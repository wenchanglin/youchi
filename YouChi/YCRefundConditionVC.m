//
//  YCRefundConditionVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/23.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRefundConditionVC.h"

#import "YCWebVC.h"
#import "YCSwitchTabControl.h"

#import "YCCommodity.h"
#import "YCMyOrderM.h"
#import <ACETelPrompt/ACETelPrompt.h>
@interface YCRefundConditionVCP ()
PROPERTY_STRONG_VM(YCRefundConditionVM);
@property (weak, nonatomic) IBOutlet UILabel *refundStpy;

@property (weak, nonatomic) IBOutlet YCCommodity *commodityView;
///编号
@property (weak, nonatomic) IBOutlet UILabel *lNumber;

@end

@implementation YCRefundConditionVCP
SYNTHESIZE_VM;


- (void)viewDidLoad {
    [super viewDidLoad];

     self.commodityView.backgroundColor =KBGCColor(@"#ffffff");
    
    self.title =self.viewModel.title;
    [[RACObserve(self.viewModel,oldAboutGoodsM)deliverOnMainThread]subscribeNext:^(YCShopOrderProductM * m) {
        //0 友米支付 1现金支付
        NSString *price;
        if ([m.isMoneyPay intValue]==0) {
            YCShopSpecM *shopSpecModel =m.shopSpec;
            _commodityView.ant.hidden = NO;
            _commodityView.Y.hidden = YES;
            price =[NSString stringWithFormat:@"%.2f",shopSpecModel.antPrice.floatValue];
            
        }else{
            _commodityView.ant.hidden = YES;
            _commodityView.Y.hidden = NO;
            price = [NSString stringWithFormat:@"%.2f",m.shopSpec.specMoneyPrice.floatValue];
        }
        
        [_commodityView onUpdataCommodityName:m.shopProduct.productName Much:m.qty.intValue Price:price Weight:m.shopSpec.specName Image:m.shopProduct.imagePath];
    }];
    }
-(void)onCreachTabViewControl{
    self.tabControl.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"退货原因",@"处理结果"];
    NSMutableArray *vcs = [NSMutableArray new];
    [titles enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tabControl insertSegmentWithTitle:dict image:nil];
        self.tabControl.normalColor = KBGCColor(@"#535353");
        YCRefundConditionVC *vc = [self vcClassWithIdentifier:@"YCRefundConditionVC"];
        vc.viewModel = self.viewModel;
        vc.refundType = idx ;
        [vcs addObject:vc];
    }];

    [self.tabVC setViewControllers:vcs animated:YES];
     self.tabVC.hideTabbar = YES;
}


//seqNo编号
//pv 数量
//antPrice价格
//productName 名称
-(void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:self.viewModel.mainSignal next:^(YCMyOrderM * m){
        self.refundStpy.text = [self _returnStatus:[m.refundStatus intValue]];
         self.lNumber.text =[m.refundId stringValue];
    }error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

-(NSString *)_returnStatus:(int)status{
    NSString *str;
    if (onCentralRefundStatus==status) {
        str  = @"审核中";
    }else if(onOKRefundStatus==status){
        str  = @"已处理";
    }else if(onMoneyRefundStatus==status){
        str  = @"已退款";
    }else{
        str  = @"已拒绝";
    }
    return str;
}
#pragma mark --再次申请
- (IBAction)onCouponRule:(UIBarButtonItem *)sender {
    
    YCWebVC *web = [[YCWebVC alloc]initWithUrlString:@"http://api1-2.youchi365.com/shop/youmi/退换货协议.html"];
    [self pushToVC:web];
  
    
}

///撤销申请
- (IBAction)onCancelRefund:(id)sender {
    
    
    
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定撤销申请吗 ？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
        SSELF;
        
        
        [sender executeActivitySignal:[self.viewModel onCancelRefundSignalRefundId:[self.viewModel.aboutGoodsM.refundId intValue]] next:^(id next) {
                    [self showMessage:@"撤销成功!!"];
                    [self onReturn];
        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
        

    }];
    
    [av show];

    
}
///致电了解退货情况
- (IBAction)onCall:(id)sender {
    [ACETelPrompt callPhoneNumber:CustomerService call:^(NSTimeInterval duration) {
        ;
    } cancel:^{
        ;
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@interface YCRefundConditionVC ()

@property (strong, nonatomic)  YCRefundConditionVM *viewModel;

///退款原因
@property (weak, nonatomic) IBOutlet UILabel *lCause;
///退款原因内容
@property (weak, nonatomic) IBOutlet UILabel *lCauseDes;

@end

@implementation YCRefundConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RACObserve(self.viewModel,aboutGoodsM)deliverOnMainThread ]subscribeNext:^(YCMyOrderM * m) {
        if (self.refundType ==onRefundType) {
            self.lCauseDes.text =[NSString stringWithFormat:@"%@",m.refundDesc];

        }else{
            self.lCause.text = @"处理原因:";
            
            if (!m.refundProcessDesc) {
                self.lCauseDes.text = @"暂时没有结果,请等待。";
            }
            else{
                
            self.lCauseDes.text =[NSString stringWithFormat:@"%@",m.refundProcessDesc];
        }
        }
        
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_WIDTH-64-158-35.f;
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
