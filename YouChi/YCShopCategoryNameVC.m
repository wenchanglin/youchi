//
//  YCShopCategoryNameVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopCategoryNameVC.h"


@interface YCShopCategoryNameVCP ()


@property(nonatomic,strong) YCShopCategoryNameVM *viewModel;

@end

@implementation YCShopCategoryNameVCP
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabbar];
    
}

///VCP 和VC 不是同一个ViewModel
-(void)onCreachTabViewControl{
    
    NSArray *titles = @[@"销量",@"价格",@"最新上架"];
    NSMutableArray<YCTableViewController *> *vcs =[NSMutableArray new];
    [titles enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tabControl insertSegmentWithTitle:obj image:nil];
        self.tabControl.normalColor = KBGCColor(@"#535353");
        self.tabControl.segmentFont = KFontBold(13);
        
        YCShopCategoryNameVC *vc = [YCShopCategoryNameVC new];
        YCShopCategoryNameVM *vm = [YCShopCategoryNameVM new];
        vm.orderType = idx;
        vm.Id = self.viewModel.Id;
        vm.requsetType = self.viewModel.requsetType;
        vc.viewModel =vm;
        [vcs addObject:vc];
    }];
    
    [self.tabVC setViewControllers:vcs animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --我的购物车
- (IBAction)pushToMyCart:(UIBarButtonItem *)sender {
    
    [self pushTo:[YCMyCartVC class]];
}

@end


@interface YCShopCategoryNameVC ()
@property(nonatomic,strong) YCShopCategoryNameVM *viewModel;
@end

@implementation YCShopCategoryNameVC
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)onSetupCell{
    [super onSetupCell];
}

-(void)onMainSignalExecute:(UIRefreshControl *)sender{

    [self executeSignal:[self.viewModel onSearchSignal:self.viewModel.orderType] next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

-(void)onUpdateCell:(YCShopSearchCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    cell.isShopSearch = YES;
    [cell.btnShop addTarget:self action:@selector(onAddToCart:) forControlEvents:UIControlEventTouchUpInside];
    [super onUpdateCell:cell model:model atIndexPath:indexPath];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        YCShopCategoryM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        YCItemDetailVC *vc = [YCItemDetailVC vcClass:[YCItemDetailVC class]];
        YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:m.productId];
        vc.viewModel = vm;
        [self pushToVC:vc];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark-------- 下拉刷新
- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupEmptyView
{
    
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        self.tableView.tableFooterView = nil;
        self.tableView.backgroundView = self.emptyView;
         self.emptyView.emptyLabel.text = @"暂时没有相关的商品";
    }
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
