//
//  YCCollectOfGoodsVC.m
//  YouChi
//
//  Created by 朱国林 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCollectOfGoodsVC.h"
#import "YCCollectOfGoodsCell.h"
#import "YCAboutGoodsM.h"
#import "YCItemDetailVC.h"

@interface YCCollectOfGoodsVC ()

@end

@implementation YCCollectOfGoodsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)onSetupCell
{
    UINib *nb = [UINib nibWithNibName:@"YCCollectOfGoodsCell" bundle:nil];
    [self.tableView registerNib:nb forCellReuseIdentifier:cell0];
}

- (id)onCreateViewModel{

    return [YCCollectOfGoodsVM new];
}


- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    WSELF;
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:^{
        SSELF;
        [self onSetupEmptyView];
    } executing:self.executingBlock];
    
}

- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        [self.emptyView updateConstraintsImage:@"当前没有商品" title:@"当前没有收藏商品"];
        self.tableView.backgroundView = self.emptyView;
    }
}

#pragma mark --数据
- (void)onUpdateCell:(YCCollectOfGoodsCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    [cell.bCollection addTarget:self action:@selector(onCollection:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bAddToCart addTarget:self action:@selector(AddToCart:) forControlEvents:UIControlEventTouchUpInside];
    [cell update:model atIndexPath:indexPath];
}



#pragma mark --取消收藏
- (void)onCollection:(UIButton *)sender{

    YCCollectOfGoodsCell *cell = sender.findTableViewCell;
    
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    
    WSELF;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定不再收藏这个商品吗 ？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
        
        SSELF;
        [sender executeActivitySignal:[self.viewModel goodsFavoriteById:m.shopProduct.productId isFavorite:NO type:YCCheatsTypeGoods] next:^(id next) {
            SSELF;
            @try {
                [self.viewModel.modelsProxy removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            }
            @catch (NSException *exception) {
                return ;
            }
            @finally {
                ;
            }
            [self showMessage:@"已经取消收藏了"];
            [self onSetupEmptyView];
        } error:self.errorBlock completed:nil executing:nil];
    }];
    
    [av show];
    
}


#pragma mark --加入购物车
- (void)AddToCart:(UIButton *)sender{

    YCCollectOfGoodsCell *cell = sender.findTableViewCell;
    
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:indexPath];

    CHECK(m.shopProduct.isQtyExist.intValue == 1, @"该商品已下架");
    
    [sender executeActivitySignal:[self.viewModel addToCart:m.shopProduct.productId productSpecId:@(0) count:@(1)] next:^(id next) {

        [self showMessage:@"已经添加到了购物车"];
        
    } error:self.errorBlock completed:nil executing:nil];
    
 
}

#pragma mark --选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCAboutGoodsM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    YCItemDetailVM *vm = [[YCItemDetailVM alloc] initWithId:m.shopProduct.productId];
    
    [self pushTo:[YCItemDetailVC class] viewModel:vm];
    
}
#pragma mark-------- 下拉刷新
- (void)onSetupRefreshControl
{
    ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
