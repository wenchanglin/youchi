//
//  YCGoodsCommentVC.m
//  YouChi
//
//  Created by 朱国林 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGoodsCommentVC.h"
#import "YCMyCartVC.h"
#import "YCGoodsCommentCell.h"
#import "YCGoodsCommentCell2.h"
#import "YCPhotoBrowser.h"
@interface YCGoodsCommentVC ()
PROPERTY_STRONG_VM(YCGoodsCommentVM);
@end

@implementation YCGoodsCommentVC
@synthesize viewModel;

-(void)onSetupCell
{
    [super onSetupCell];
    UINib *nb = [UINib nibWithNibName:@"YCGoodsCommentCell" bundle:nil];
    [self.tableView registerNib:nb forCellReuseIdentifier:cell0];
    
    UINib *nb1 = [UINib nibWithNibName:@"YCGoodsCommentCell2" bundle:nil];
    [self.tableView registerNib:nb1 forCellReuseIdentifier:cell1];
}


- (id)onCreateViewModel{
    
    return [YCGoodsCommentVM new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品评论";
    // Do any additional setup after loading the view.
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

#pragma mark --数据


- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    
    #pragma mark - 要评论的商品
    if (reuseIdentifier == cell0) {
        YCGoodsCommentCell *c = (id)cell;
        [c.bAddToCart addTarget:self action:@selector(onAddToCart:) forControlEvents:UIControlEventTouchUpInside];
        [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
            SSELF;
            YCItemDetailM *m = self.viewModel.model;
            if (![cell checkIsHasSetData:m]) {
                YCGoodsCommentCell *c = (id)cell;
                //TODO:注视商品
                [c.imgGoodsPictrure ycShop_setImageWithURL:m.imagePath placeholder:PLACE_HOLDER];
                
                
                c.lGoodsName.text = m.brief;
                c.lGoodsDesc.text = m.desc;
            }
            
        }];
        return;
    }
    
    #pragma mark - 评论
    if (reuseIdentifier == cell1) {
        [cell setInitBlock:^(__kindof YCGoodsCommentCell2 *cell, UIView *view, NSString *reuseIdentifier) {
            cell.lCommentDesc.textVerticalAlignment = YYTextVerticalAlignmentTop;
            cell.lCommentDesc.numberOfLines = 0;
            [cell.bSupport setTitle:@"支持顶一个" forState:UIControlStateNormal];
            cell.imageControl.imageCount = 4;
            cell.imageControl.edge = UIEdgeInsetsMake(1, 8, 8, 8);
            cell.imageControl.gap = 8;
            
            [cell.bSupport addTarget:self action:@selector(onSupportGoods:) forControlEvents:UIControlEventTouchUpInside];
             [cell.imageControl addTarget:self action:@selector(onViewPhoto:) forControlEvents:UIControlEventValueChanged];
             
            view.hasTopLine = YES;
            view.hasBottomLine = YES;
            [cell setBackgroundClearColor];
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCGoodsCommentM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                    
                }
                [cell update:m atIndexPath:indexPath];
            }];
            
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                view.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, 0, YCGoodsCommentInset, 0));
            }];
        }];
        return;
    }
}

#pragma mark --支持一个
- (void)onSupportGoods:(UIButton *)sender{
    YCGoodsCommentCell2 *cell = sender.findTableViewCell;
    YCGoodsCommentM *model = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:cell]];
    BOOL isClickLike = !model.isClickLike.boolValue;
    [sender executeActivitySignal:[self.viewModel clickLikeForProductShowoffByProductShowoffId:model.productShowoffId actionType:isClickLike] next:^(id next) {
        model.isClickLike = @(isClickLike);
        [cell updateLikeButton:isClickLike];
    } error:self.errorBlock completed:nil executing:nil];
}

#pragma mark --加入购物车
- (void)onAddToCart:(UIButton *)sender
{
    YCItemDetailVM *vm = (id)self.viewModel.viewModel;
    [sender executeActivitySignal:[vm addToCart:vm.Id productSpecId:vm.specId count:@(1)] next:^(id next) {
        [self showMessage:@"已经添加到了购物车"];
    } error:self.errorBlock completed:nil executing:nil];
}

#pragma mark --转跳我的购物车
- (IBAction)myCart:(UIBarButtonItem *)sender {
    
    
    YCMyCartVM *vm = [YCMyCartVM new];
    [self pushTo:[YCMyCartVC class] viewModel:vm];
}

- (void)onViewPhoto:(YCImageSelectControl *)sender
{
    YCGoodsCommentM *m = [self.viewModel modelForItemAtIndexPath:[self indexPathForCell:sender.findTableViewCell]];
    YCPhotoBrowser *pb =[[YCPhotoBrowser alloc]initWithPageModels:m.shopProductShowoffImages selectedIndex:sender.selectedIndex];
    [pb setUrlBlock:^NSURL *(YCBaseImageModel *model) {
        NSURL *url =  NSURL_URLWithString(IMAGE_HOST_SHOP(model.imagePath));
        return url;
    }];
    [self pushToVC:pb];
}

#pragma mark --头部view
- (void)onConfigureHeader:(YCTableViewHeaderFooterView *)header reuseIdentifier:(NSString *)reuseIdentifier
{
    if (reuseIdentifier == headerC) {
        YCView *backgroundView = [YCView new];
        
        backgroundView.backgroundColor = KBGCColor(@"#f2f2f2");
        backgroundView.hasBottomLine = backgroundView.hasTopLine = YES;
        
        UILabel *l = [UILabel newInSuperView:backgroundView];
        l.textAlignment = NSTextAlignmentCenter;
        
        UIView *line1 = [UIView newInSuperView:backgroundView];
        UIView *line2 = [UIView newInSuperView:backgroundView];
        line1.backgroundColor = line2.backgroundColor = color_Line;
        
        l.text = @"买家点评";
        [backgroundView addSubview:l];
        l.font = [UIFont systemFontOfSize:15];
        [l sizeToFit];
        l.width = 80;
        
        [backgroundView setLayoutBlock:^(YCView *view, CGRect frame) {
            
            l.center = CGRectGetCenter(frame);
            line1.height = line2.height = 0.5;
            
            line1.width = line2.width = l.left - view.left;
            line1.centerY = line2.centerY = l.centerY;
            line1.left = view.left;
            line2.left = l.right;
            
        }];
        
        header.backgroundView = backgroundView;
    }
}


#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
}

- (void)onSetupActivityIndicatorView{
    
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
