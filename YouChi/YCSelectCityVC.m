//
//  YCSelectCityVC.m
//  YouChi
//
//  Created by sam on 15/10/20.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSelectCityVC.h"

@interface YCSelectCityVCP()
{
    YCSelectCityVC *vc;
}
PROPERTY_STRONG_VM(YCSelectCityVM);

@end
@implementation YCSelectCityVCP
SYNTHESIZE_VM;

- (void)dealloc
{
    //ok
}
- (void)viewDidLoad
{
    [[self.searchText.rac_textSignal throttle:0.5] subscribeNext:^(NSString *x) {
        
        [self executeSignal:[self.viewModel signalSearchWithCity:x] next:self.nextBlock error:self.errorBlock completed:^{
                [vc.tableView reloadData];
            } executing:self.executingBlock];
        
        
    }];
    
        
    
    
    
}


-(void)onSeacrh:(UIButton *)sender{
    [self.searchText resignFirstResponder];
    CHECK(self.searchText.text.length == 0, @"请输入搜索内容!!!");
    [self executeSignal:[self.viewModel signalSearchWithCity:self.searchText.text] next:self.nextBlock error:self.errorBlock completed:^{
        [vc.tableView reloadData];
    } executing:self.executingBlock];
    
}

- (void)onKeyboardDone:(id)sender
{
    ;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeySearch) {
        
        [self onSeacrh:nil];
    }
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     vc =segue.destinationViewController;
     
     [vc setValue:self.viewModel forKey:KP(self.viewModel)];
 
 }


@end


@interface YCSelectCityVC ()<UITextFieldDelegate>
@property (nonatomic,strong) YCSelectCityVM *viewModel;
@end
@implementation YCSelectCityVC
@synthesize viewModel;
- (void)dealloc
{
    //ok
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

-(void)onUpdateCell:(UITableViewCell *)cell model:(YCChihuoyingM_1_2 *)model atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text =  model.name;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCChihuoyingM_1_2 *model =  [self.viewModel modelForItemAtIndexPath:indexPath];
    [self.viewModel.selectCity sendNext:model.name];
    [self.viewModel.selectCity sendCompleted];
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [self searchView];
    
    return view;

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
}

//下拉刷新
- (void)onSetupRefreshControl
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(UIView *)searchView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, 45)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *lView = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, KSize.width-17, 45)];
    [lView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    lView.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [lView addGestureRecognizer:labelTapGestureRecognizer];
    
    lView.text = self.viewModel.selCity;
    [view addSubview:lView];
    return view;
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
