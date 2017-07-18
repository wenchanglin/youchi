//
//  YCOrderJudgeVC.m
//  YouChi
//
//  Created by 朱国林 on 15/12/28.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCOrderJudgeVC.h"
#import "YCCommodity.h"


@interface YCOrderJudgeVC ()
PROPERTY_STRONG_VM(YCOrderJudgeVM);
@property (weak, nonatomic) IBOutlet IQTextView *lJude;
@property (weak, nonatomic) IBOutlet YCCommodity *commodity;
///viewModel

@end

@implementation YCOrderJudgeVC
SYNTHESIZE_VM;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    self.lJude.placeholder = @"请描述您对商品的评价，分享你的收获";
    
    self.commodity.backgroundColor =KBGCColor(@"#ffffff");
    WSELF;
    [[RACObserve(self.viewModel,smallModel) deliverOnMainThread ]subscribeNext:^(YCShopOrderProductM* m) {
        SSELF;

        //0 友米支付 1现金支付
        NSString *price;
        if ([m.isMoneyPay intValue]==0) {
            YCShopSpecM *shopSpecModel =m.shopSpec;
            self.commodity.Y.hidden = YES;
            self.commodity.ant.hidden = NO;
            price =[NSString stringWithFormat:@"%.2f",shopSpecModel.antPrice.floatValue];
            
        }else{
            self.commodity.ant.hidden = YES;
            self.commodity.Y.hidden = NO;
            price = [NSString stringWithFormat:@"%.2f",m.shopSpec.specMoneyPrice.floatValue];
        }
        
        [self.commodity onUpdataCommodityName:m.shopProduct.productName Much:m.qty.intValue Price:price Weight:m.shopSpec.specName Image:m.shopProduct.imagePath];
    }];
    
    RAC(self.viewModel,comment) = self.lJude.rac_textSignal; ;
    
}


-(void)onSetupHeaderFooter
{
    [self onRegisterNibName:@"YCOrderShowHead" HeaderFooterViewIdentifier:headerC2];
    [self onRegisterNibName:@"YCOrderShowHead" HeaderFooterViewIdentifier:headerC3];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 35.f;
    }
    else if (section==2) {
        return 20.f;
    }
    return 0.1f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
         return 5.f;
    }
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return CGRectGetWidth(tableView.bounds)*2/3 + 10;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UITableViewHeaderFooterView
        *view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerC2];
        if (!view) {
            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerC2];
        }
        view.backgroundView = [UIView viewByWhiteBackgroundColor];
        UILabel *label = [view viewByTag:1];
        label.text =@"商品评价";
        return view;
    }else if(section==2){
        UITableViewHeaderFooterView *view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerC3];
        if (!view) {
            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerC3];
        }
        view.backgroundView = [UIView viewByWhiteBackgroundColor];
        UILabel *label = [view viewByTag:1];
        label.text =@"晒单照片";
        return view;
    }
    
    return nil;
}


#pragma mark --发送晒单
- (IBAction)send:(UIBarButtonItem *)sender
{
    WSELF;
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    [self showMessage:@"正在上传，请稍候"];
    RACSubject *msg = [RACSubject subject];
    [msg subscribeNext:^(id x) {
        SSELF;
        [self showMessage:x];
    }];
    [sender executeSignal:[self.viewModel signalUploadWith:msg] next:^(id next) {
        [self showMessage:@"上传晒单成功"];
        
        [self onReturn];
    } error:self.errorBlock completed:^{
        [SVProgressHUD dismissWithDelay:0.5];
    } executing:nil];
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



@interface YCOrderJudgeListVC ()

@end



@implementation YCOrderJudgeListVC
- (void)dealloc
{
    //ok
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
