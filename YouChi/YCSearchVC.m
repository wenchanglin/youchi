//
//  YCSearchVC.m
//  YouChi
//
//  Created by 李李善 on 15/5/24.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchVC.h"
#import "YCSearchVM.h"
#import "YCSearchDetailVC.h"
#import "YCShopSearchVC.h"
@interface YCSearchVC () <UITextFieldDelegate>
PROPERTY_STRONG_VM(YCSearchVM);

@property(nonatomic,weak) IBOutlet  UITextField *textfieldSearch;
@property(nonatomic,strong) UILabel *lSearch;
@end

@implementation YCSearchVC
SYNTHESIZE_VM;
#pragma mark - 生命周期

- (void)dealloc
{
    //ok
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.isTabBarHidden) {
        [self hideTabbar];
    }
}

static NSString  *const HeaderView = @"HeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textfieldSearch becomeFirstResponder];
    self.tableView.sectionFooterHeight = 0.f;
    self.textfieldSearch.delegate = self;
}

-(id)onCreateViewModel
{
    return [YCSearchVM new];
}

-(void)onSetupHeaderFooter{
    [self onRegisterNibName:@"YCHistoryHeader" HeaderFooterViewIdentifier:HeaderView];
}


#pragma mark---- 去头(有关系)
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 41.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UITableViewHeaderFooterView
    *view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderView];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:HeaderView];
    }
    view.backgroundView = [UIView viewByWhiteBackgroundColor];
    view.backgroundView.backgroundColor = [UIColor clearColor];
    
    if (self.viewModel.historyArrs.count!= 0) {
        view.hidden = NO;
    }
    UILabel *label = (id)[view viewWithTag:1];
    label.text = @"历史搜索";
    return view;
}

#pragma mark---- 更新方法
-(void)onUpdateCell:(UITableViewCell *)cell model:(NSString *)model atIndexPath:(NSIndexPath *)indexPath{
    
    [cell update:model atIndexPath:indexPath];
}

#pragma mark---- 搜索方法
/**
 将搜索的词 传入两个位置 （第一界面的 ViewModel  和  二级界面 的ViewModel）
 */
- (IBAction)onSearch:(id)sender {
    [self.parentViewController.view endEditing:YES];
    
    //    不需要，直接点击搜索，后台默认推荐的信息
    if (self.searchType ==isSearchTypeShop) {
        CHECK(self.textfieldSearch.text.length==0, @"请输入搜索内容!!!");
    }
    [self onSearchVC];
    
    [self.viewModel onSearch:self.textfieldSearch.text];
    @try {
        NSIndexSet *IndexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:IndexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    @catch (NSException *exception) {return;}
    @finally {}
}

#pragma mark---- 删除历史
- (IBAction)onDelete:(UIButton *)sender {
    UITableViewCell *cell = sender.findTableViewCell;
    NSIndexPath *IndexPath = [self.tableView indexPathForCell:cell];
    @try {
        [self.viewModel.historyArrs removeObjectAtIndex:IndexPath.row];
        NSIndexSet *IndexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:IndexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        ;
    }
    if (self.viewModel.historyArrs.count == 0) {
        [self.tableView reloadData];
    }
    
}
#pragma mark---- 单元格选中方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.textfieldSearch.text = self.viewModel.historyArrs[indexPath.row];
    [self onSearchVC];
}
-(void)onSearchVC
{
    UIViewController *puVC;
    if (self.searchType ==isSearchTypeOther) {
        YCSearchDetailVCP *searchDetailVCP = [self vcClassWithIdentifier:@"YCSearchDetailVCP"];
        YCSearchDetailVM *vm = [YCSearchDetailVM new];
        vm.isSearch =YES;
        vm.searchText = self.textfieldSearch.text;
        searchDetailVCP.viewModel = vm;
        puVC = searchDetailVCP;
    }else
    {
        YCShopSearchVC  *shopSearchVC = [YCShopSearchVC vcClass];
        YCShopSearchVM *vm = [YCShopSearchVM new];
        vm.searchText = self.textfieldSearch.text;
        shopSearchVC.viewModel = vm;
        puVC = shopSearchVC;
    }
    [self.navigationController pushViewController:puVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeySearch) {
        [self onSearch:nil];
    }
    [textField resignFirstResponder];
    return YES;
}



#pragma mark-------下拉刷新,上啦加载
- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupActivityIndicatorView
{
    ;
}
- (void)onSetupFooter
{
    [super onSetupFooter];
}
- (void)onSetupEmptyView
{
    ;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self.view endEditing:YES];
    return self.textfieldSearch.text.length>0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
