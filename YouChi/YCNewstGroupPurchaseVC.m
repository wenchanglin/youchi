//
//  YCNewstGroupPurchaseVC.m
//  YouChi
//
//  Created by 朱国林 on 16/5/12.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCGroupPurchaseMainVM.h"
#import "YCNewstGroupPurchaseView.h"
#import "YCNewstGroupPurchaseVC.h"
#import <YYKit/YYKit.h>
#import "YCView.h"
#import "YCCreateGroupPurchaseVC.h"
#import "YCSupportGroupPurchaseVC.h"
@interface YCNewstGroupPurchaseVC ()

@end

@implementation YCNewstGroupPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
}



- (id)onCreateViewModel{

    return [YCNewstGroupPurchaseVM new];
}


- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:nil executing:self.executingBlock];
}

#pragma mark - 最新团拼列表cell
- (void)onConfigureCell:(__kindof YCTableVIewCell *__weak)cell reuseIdentifier:(NSString *)reuseIdentifier
{

    WSELF;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    
    
    
    [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
        
        YCNewstGroupPurchaseView *v = [YCNewstGroupPurchaseView newInSuperView:view];
        
        [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
            [v yc_initView];
            
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view).insets(UIEdgeInsetsMake(8,8,0,8));
            }];

        }];
        
        [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCNewstGroupM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            [v updateWithLastestGroupon:m];
            
        }];
        

        #pragma mark - 开团
        [v.bOpenGroup addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *x) {
            
            SSELF;
            NSIndexPath *indexPath = [self indexPathForCell:cell];
            YCNewstGroupM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            if (!m.productId) {
                return ;
            }
            YCCreateGroupPurchaseVM *vm = [[YCCreateGroupPurchaseVM alloc] initWithProductId:m.productId];
            
            [self pushToVC:[YCCreateGroupPurchaseVC vcClass] viewModel:vm];
            
        }];
        
        
        [cell setSelectBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
        
            
            YCNewstGroupM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            if (!m.productId) {
                return ;
            }
            YCSupportGroupPurchaseVM *vm = [[YCSupportGroupPurchaseVM alloc]initWithParameters:@{ @"productId":m.productId}];
            [self pushTo:[YCSupportGroupPurchaseVC class]viewModel:vm];
        }];

    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    WSELF;
//    return [tableView fd_heightForCellWithIdentifier:[self.viewModel cellIDAtIndexPath:indexPath] configuration:^(YCTableVIewCell *cell) {
//        SSELF;
//        [cell updateAtIndexPath:indexPath];
//    }];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
}


- (void)onSetupRefreshControl
{
    [super onSetupRefreshControl];
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
