//
//  YCShopSearchVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopSearchVC.h"


#import "YCSearchDetailVC.h"
#import "YCItemDetailVC.h"

@interface YCShopSearchVCP ()<UITextFieldDelegate>{
    
    NSInteger _integer;
}
///viewModel
PROPERTY_STRONG_VM(YCShopSearchVM);
@property (weak, nonatomic) IBOutlet UITextField *searchText;



@end

@implementation YCShopSearchVCP
SYNTHESIZE_VM;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.viewModel.title;
    RACChannelTo(self.viewModel,searchText) = self.searchText.rac_newTextChannel;
    self.searchText.text = self.viewModel.searchText;
    _integer = 0.f;
}


-(void)onCreachTabViewControl{
    
    NSArray *titles = @[@"销量",@"价格",@"最新上架"];
    NSMutableArray *vcs =[NSMutableArray new];
        [titles enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tabControl insertSegmentWithTitle:obj image:nil];
            self.tabControl.normalColor = [UIColor blackColor];
            YCShopSearchVC *vc = [YCShopSearchVC new];
            vc.viewModel = self.viewModel;
            vc.orderType = idx;
            [vcs addObject:vc];
        }];
    
        [self.tabVC setViewControllers:vcs animated:YES];
}


- (IBAction)onSwitchTabControler:(YCSwitchTabControl *)sender{
    [super onSwitchTabControler:sender];
    _integer = sender.selectedSegmentIndex;
    [self.view endEditing:YES];

 }

- (void)onKeyboardDone:(id)sender{
    [self onSeacrh:sender];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType == UIReturnKeySearch) {
        [self onSeacrh:nil];
    }
    [textField resignFirstResponder];
    return YES;
}





- (IBAction)onSeacrh:(id)sender {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"onSearch" object:self userInfo:@{@"selsect":@(_integer)}];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



@interface YCShopSearchVC ()
///viewModel
@property(nonatomic,strong) YCShopSearchVM *viewModel;
@end

@implementation YCShopSearchVC
@synthesize viewModel;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSeacrhText:) name:@"onSearch" object:nil];

}

-(void)onSeacrhText:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    NSInteger  select = [dic[@"selsect"]integerValue];
    if (self.orderType ==select) {
        [self onMainSignalExecute:nil];
    }
    
}
-(void)onSetupCell
{
    [self onRegisterNibName:@"YCShopSearchCell" Identifier:cell0];
    
}


-(void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:[self.viewModel onSearchSignal:self.orderType] next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}


-(void)onUpdateCell:(YCShopSearchCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    [cell.btnShop addTarget:self action:@selector(onAddToCart:) forControlEvents:UIControlEventTouchUpInside];
    [cell update:model atIndexPath:indexPath];
    
}


#pragma mark --加入购物车
- (void)onAddToCart:(UIButton *)sender{
    
    YCShopSearchCell *cell = sender.findTableViewCell;
    
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    YCShopCategoryM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    
    [sender executeActivitySignal:[self.viewModel addToCart:m.productId productSpecId:@(0) count:@(1)] next:^(id next) {
        
        [self showMessage:@"已经添加到了购物车"];
        
    } error:self.errorBlock completed:nil executing:nil];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCShopCategoryM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    YCItemDetailVC *vc = [YCItemDetailVC vcClass:[YCItemDetailVC class]];
    YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:m.productId];
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
- (void)onSetupEmptyView
{
    
    if ([self.viewModel numberOfItemsInSection:0]==0) {
        self.tableView.backgroundView = self.emptyView;
        self.emptyView.emptyLabel.text = @"搜不到您想要的东西";
    } else {
        self.tableView.backgroundView = nil;
    }
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

