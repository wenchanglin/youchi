//
//  YCApplyForRefundVC.m
//  YouChi
//
//  Created by 朱国林 on 16/1/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCApplyForRefundVC.h"
#import "YCView.h"
#import "YCCommodity.h"


#import "YCMarcros.h"
@interface YCApplyForRefundVCP ()
///viewModel
PROPERTY_STRONG_VM(YCApplyForRefundVM);


@end

@implementation YCApplyForRefundVCP
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
}


///申请退货
- (IBAction)onApplyForRefund:(UIButton *)sender
{
    WSELF;
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    [self showMessage:@"请稍候"];
    RACSubject *msg = [RACSubject subject];
    [msg subscribeNext:^(id x) {
        SSELF;
        [self showMessage:x];
    }];
    [sender executeActivitySignal:[self.viewModel signalUploadWith:msg] next:^(id next) {
        [self showMessage:@"上传退货申请成功"];
        [self onReturn];
        
    } error:self.errorBlock completed:^{
        [SVProgressHUD dismissWithDelay:0.5];
    } executing:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setViewModel:self.viewModel];
    
}
@end


@interface YCApplyForRefundVC ()
///viewModel
@property(nonatomic,strong) YCApplyForRefundVM  *viewModel;

@property (weak, nonatomic) IBOutlet YCCommodity *commodityView;

@property (weak, nonatomic) IBOutlet IQTextView *lDescText;

@property (weak, nonatomic) IBOutlet UITextField *lPhoneNumberText;

@end

@implementation YCApplyForRefundVC
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    RAC(self.viewModel,phoneNumber) = self.lPhoneNumberText.rac_textSignal;
    RAC(self.viewModel,comment) =self.lDescText.rac_textSignal;
    
    self.commodityView.backgroundColor =KBGCColor(@"#ffffff");
    
    self.lDescText.placeholder = @"请描述清楚你需要退货的商品问题，我们会尽快与你联系";
    self.lPhoneNumberText.text = self.viewModel.phoneNumber = [YCUserDefault currentUser].appUser.phone;
    
    ///从上一个界面传过来的，显示商品的数据
    [[RACObserve(self.viewModel,aboutGoodsM)deliverOnMainThread ]subscribeNext:^(YCShopOrderProductM* m) {
        //0 友米支付 1现金支付
        NSString *price;
        if (!m.isMoneyPay.boolValue) {
            YCShopSpecM *shopSpecModel =m.shopSpec;
            _commodityView.Y.hidden = YES;
            _commodityView.ant.hidden = NO;
            price =[NSString stringWithFormat:@"%.2f",shopSpecModel.antPrice.floatValue];
            
        } else {
            _commodityView.ant.hidden = YES;
            _commodityView.Y.hidden = NO;
            price = [NSString stringWithFormat:@"%.2f",m.shopSpec.specMoneyPrice.floatValue];
        }
        
        [_commodityView onUpdataCommodityName:m.shopProduct.productName Much:m.qty.intValue Price:price Weight:m.shopSpec.specName Image:m.shopProduct.imagePath];
        
    }];
    

    



}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return CGRectGetWidth(tableView.bounds)*2/3 + 10;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return .1f;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        return 20;
    }
    
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WSELF;
    if ([segue.destinationViewController isKindOfClass:[YCRandomPicturesListVC class]]) {
        YCRandomPicturesListVC *vc = segue.destinationViewController;
        [vc setImageModelUpdateBlock:^(NSMutableArray<YCImageModel *> *imageModels) {
            SSELF;
            [self.viewModel.modelsProxy setArray:imageModels];
        }];
    }
    
}
@end




