//
//  YCLogisticsDetailsVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/19.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCLogisticsDetailsVC.h"
#import "YCItemDetailVC.h"
#import "YCOrderCell.h"


@interface YCLogisticsDetailsVCP ()
///viewModel
PROPERTY_STRONG_VM(YCLogisticsDetailsVM);

@end

@implementation YCLogisticsDetailsVCP
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    
    
}

-(id)onCreateViewModel{
    return [YCLogisticsDetailsVM new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCallCustomerService:(id)sender {
    
    [ACETelPrompt callPhoneNumber:CustomerService call:^(NSTimeInterval duration) {
        ;
    } cancel:^{
        ;
    }];
    
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     [[segue destinationViewController] setViewModel:self.viewModel];
 }
 

@end
@interface YCLogisticsDetailsVC ()
///viewModel
@property(nonatomic,strong) YCLogisticsDetailsVM *viewModel;
@end

@implementation YCLogisticsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
}

-(void)onSetupCell{
    ///商品
    [self onRegisterNibName:@"YCOrderCell" Identifier:cell6];
    
}

-(void)onSetupHeaderFooter
{
    [self onRegisterNibName:@"YCLogisticsDetailsHead" HeaderFooterViewIdentifier:headerC2];
    [self onRegisterNibName:@"YCLogisticsDetailsTakeHead" HeaderFooterViewIdentifier:headerC3];
}


-(void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:[self.viewModel mainSignal] next:^(id x){
    
        [self onReloadItems:0];
    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1||section==2) {
        return 35.f;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UITableViewHeaderFooterView
        *view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerC2];
        
        if (!view) {
            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerC2];
           
        }
         view.hasBottomLine = YES;
        view.backgroundView = [UIView viewByWhiteBackgroundColor];
        return view;
    }else if(section==2){
        UITableViewHeaderFooterView *view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerC3];
        if (!view) {
            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerC3];
         
        }
        view.hasBottomLine = YES;
        view.backgroundView = [UIView viewByWhiteBackgroundColor];
        return view;
    }
    
    return nil;
}

-(void)onUpdateCell:(UITableViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section==0) {
        [cell update:model atIndexPath:indexPath];
    }
    else if (indexPath.section==1) {
        if (indexPath.row != self.viewModel.Model.shopOrderProducts.count) {
            YCOrderCell*cell1 = (id)cell;
            YCShopOrderProductM *Model =model;
            YCShopProductM *shopProductM = Model.shopProduct;
            YCShopSpecM *shopSpecM =Model.shopSpec;
            
            ///name:商品名字 much:商品数量 price:商品单价 weight:规格 1g/份 image:商品图片
            [cell1.commodityView onUpdataCommodityName:shopProductM.productName Much:Model.qty.intValue Price:[NSString stringWithFormat:@"%.2f",[shopSpecM.specMoneyPrice floatValue]] Weight:shopSpecM.specName Image:shopProductM.imagePath];

        }
    }
    
   else if (indexPath.section==2) {
        [cell update:model atIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    YCShopOrderProductM *m =self.viewModel.Model.shopOrderProducts[indexPath.row];
    
    YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:m.shopProduct.productId];
    if ([m.isMoneyPay intValue]==0) {
        vm.youMiModel = m;
    }
    YCItemDetailVC *vc = [YCItemDetailVC vcClass:[YCItemDetailVC class]];
    vc.viewModel = vm;
    [self pushToVC:vc];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    //    [super onSetupRefreshControl];
}
- (void)onSetupActivityIndicatorView
{
    //    [super onSetupActivityIndicatorView];
}

- (void)onSetupFooter
{
    //    [super onSetupFooter];
}

- (void)onSetupEmptyView
{
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
