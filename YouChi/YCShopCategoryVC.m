//
//  YCShopCategoryVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopCategoryVC.h"
#import "YCShopCategoryVM.h"
#import "YCShopCategoryNameVC.h"

@interface YCShopCategoryVCP ()
///viewModel
PROPERTY_STRONG_VM(YCShopCategoryVM);


///YCShopCategoryVC
@property(nonatomic,strong) YCShopCategoryVC *vc;


@end

@implementation YCShopCategoryVCP
SYNTHESIZE_VM;
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WSELF;
    [self.shopCategoryV onClickButton:^(UIButton *button, NSInteger i) {
        SSELF;
        self.viewModel.selsectBtn  = i-1;
        [self scrollViewMove:button];
        [self.vc.tableView reloadData];
        
        
    }];
    
    NSNotificationCenter * center2 = [NSNotificationCenter defaultCenter];
    [center2 addObserver:self selector:@selector(notific:) name:@"direction" object:nil];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部商品" style:UIBarButtonItemStylePlain target:self action:@selector(allItem)];
    
    if (!self.title) {
        self.title = @"商品分类";
    }
}

- (void)allItem
{
    YCShopCategoryNameVC *vc = [YCShopCategoryNameVC vcClass];
    YCShopCategoryNameVM *vm = [YCShopCategoryNameVM new];
    vm.requsetType = selsectRequsetTypeShop;
    vm.title = @"全部商品";
    vc.viewModel = vm;
    [self pushToVC:vc];
}

-(id)onCreateViewModel
{
    return [YCShopCategoryVM new];
    
}

-  (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:[self.viewModel mainSignal] next:^(id next) {
        self.shopCategoryV.contentSize = CGSizeMake(self.viewModel.titles.count*75,0);
        self.shopCategoryV.titles =self.viewModel.titles;
        
        self.shopCategoryV.selsectBtnInteger = 1;
        [self.vc.tableView reloadData];
    }  error:self.errorBlock completed:nil executing:self.executingBlock];
}

- (void)notific:(NSNotification *)text{
    
    NSNumber * direction = text.userInfo[@"direction"];
    int i = 0;
    if (direction.intValue == 0) {// 左滑
        i = -1;
    }else if (direction.intValue == 1){// 右滑
        i = 1;
    }
    self.shopCategoryV.selsectBtnInteger = (self.shopCategoryV.selsectBtnInteger + 1) - i;
    
    UIButton *btn = self.shopCategoryV.btns[self.shopCategoryV.selsectBtnInteger];
    
    [self scrollViewMove:btn];
    
}


- (void)scrollViewMove:(UIButton *)btn{

    
    CGRect btnFrame = btn.frame;
    
    CGFloat btnX = btnFrame.origin.x;
    
    CGFloat btnCenterX = btn.centerX;
    
    CGFloat width = self.shopCategoryV.frame.size.width;
    
    CGSize contentsize = self.shopCategoryV.contentSize;
    
    if (btnCenterX > width/2) {
        
        CGFloat moveX;
        
        if (contentsize.width - btnX <=width/2) {
            moveX = contentsize.width - width;
        }else{
            
            moveX = btnX - width/2 + btnFrame.size.width / 2;
        }
        
        
        if (moveX + width > contentsize.width) { // 如果滚动超过scrollview的宽度
            moveX = contentsize.width - width;
        }
        
        [self.shopCategoryV setContentOffset:CGPointMake(moveX, 0) animated:YES];
        
    }else{
        
        [self.shopCategoryV setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      self.vc =[segue destinationViewController];
     [self.vc setViewModel:self.viewModel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




@interface YCShopCategoryVC ()

PROPERTY_STRONG_VM(YCShopCategoryVM);
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic,strong) YCShopCategoryVCP *shopCategoryVCP;
@end

@implementation YCShopCategoryVC
SYNTHESIZE_VM;

- (void)dealloc{
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    WSELF;
    [[RACObserve(self.viewModel, shops) ignore:nil].deliverOnMainThread subscribeNext:^(id x) {
        SSELF;

        [self.tableView reloadData];
    }];
    
    
    self.view.backgroundColor = [UIColor whiteColor];

    // 手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
}


#pragma mark -
- (void)onUpdateCell:(UICollectionViewCell *)cell model:(YCShopCategoryM *)model atIndexPath:(NSIndexPath *)indexPath
{
    
    
        UILabel *label = [cell viewByTag:2];;
        label.text = model.categoryName;
        UIImageView *detailImage = [cell viewByTag:1];
        
        [detailImage ycShop_setImageWithURL:model.imagePath placeholder:PLACE_HOLDER];
    
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @try {
        YCShopCategoryNameVM *vm = [YCShopCategoryNameVM new];
        
        NSArray *shop = self.viewModel.shops[self.viewModel.selsectBtn];
        if (indexPath.row == [shop count]) {
            YCShopCategoryM *model =  self.viewModel.modelsProxy[self.viewModel.selsectBtn];
            vm.Id = model.categoryId;
            vm.requsetType = selsectRequsetTypeSup;
            vm.title = model.categoryName;
        }else{
            
            YCShopCategoryM *model = [self.viewModel modelForItemAtIndexPath:indexPath];
            vm.Id = model.categorySubId;
            vm.requsetType = selsectRequsetTypeSub;
            vm.title = model.categoryName;
        }
        YCShopCategoryNameVC *vc = [YCShopCategoryNameVC vcClass:[YCShopCategoryNameVC class]];
        vc.viewModel = vm;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {}
    
}

#pragma mark --左右滑手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    int direction = 0;
    
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        direction = 0;
        
        if (self.viewModel.selsectBtn + 1 == self.viewModel.shops.count) {
            
            return;
        }
        //创建核心动画
        CATransition *ca=[CATransition animation];
        //告诉要;执行什么动画
        //设置过度效果
        ca.type=kCATransitionPush;
        //设置动画的过度方向（向左）
        ca.subtype=kCATransitionFromRight;
        //设置动画的时间
        ca.duration=0.3;
        //添加动画
        [self.view.layer addAnimation:ca forKey:nil];
    
    }
    else
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
     
        direction = 1;
        
        
        if (self.viewModel.selsectBtn == 0) {
            
            return;
        }
        
        //创建核心动画
        CATransition *ca=[CATransition animation];
        //告诉要;执行什么动画
        //设置过度效果
        ca.type=kCATransitionPush;
        //设置动画的过度方向（向右）
        ca.subtype=kCATransitionFromLeft;
        //设置动画的时间
        ca.duration=0.3;
        //添加动画
        [self.view.layer addAnimation:ca forKey:nil];

    }
    
    NSNotification * notice2 = [NSNotification notificationWithName:@"direction" object:nil userInfo:@{@"direction":@(direction)}];
    [[NSNotificationCenter defaultCenter]postNotification:notice2];
}


#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
