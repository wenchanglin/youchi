//
//  YCMuchFruitVC.m
//  YouChi
//
//  Created by 李李善 on 15/5/22.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMaterialVC.h"

#import "YCMaterialCell.h"
#import "YCMaterialAddVC.h"
#import "YCRecipeStepListVM.h"
#import "YCRecipeStepListVC.h"

#define KSectionFoot 42

@interface YCMaterialVC ()

///材料数量
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (weak, nonatomic) IBOutlet UILabel *difficulty;
@property (weak, nonatomic) IBOutlet UITextField *name;

///描述
@property (weak, nonatomic) IBOutlet IQTextView *describe;



@property (weak, nonatomic) YCMaterialListVC *addMaterialVC;
PROPERTY_STRONG_VM(YCMaterialVM);
@end

@implementation YCMaterialVC
SYNTHESIZE_VM;
#pragma mark - 生命周期
- (void)dealloc{
    //ok
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = self.viewModel.isEditMode?@"编辑秘籍":@"发布秘籍";
 
    self.tableView.sectionFooterHeight = 0.f;
    self.tableView.sectionHeaderHeight = 0.f;
    
    self.describe.placeholder = @"秘籍描述";

    if (self.viewModel.isEditMode) {
        YCChihuoyingM_1_2 *next = self.viewModel.editRecipeDetailVM.model;
        [self _setUpData];
        self.difficulty.text = next.difficulty;
        self.timer.text = [self.viewModel getSpendTimeStringByTime:next.maxSpendTime.intValue];
    } else {
        [self _setUpData];
    }
    
    WSELF;
    [RACObserve(self.viewModel, modelsProxy).deliverOnMainThread subscribeNext:^(id x) {
        SSELF;
        [self.tableView beginUpdates];
        [self.addMaterialVC onReloadItems:0];
        [self.tableView endUpdates];
    }];
    
}

//初始化赋值
- (void)_setUpData
{
    self.name.text = self.viewModel.name;
    @try {
        self.difficulty.text = self.viewModel.difficultys[self.viewModel.difficultyType] ;
        self.timer.text = self.viewModel.spendTimes[self.viewModel.spendTimeType];
        
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
    self.describe.text = self.viewModel.describe;
    
}

#pragma mark - 难度，时间

- (IBAction)onSelectDifficultyOrTime:(UIButton *)sender {
    [self.view endEditing:YES];
    
    UIAlertView *alertView ;
    switch (sender.tag) {
        case 2:
        {
            alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            for (NSString *title in self.viewModel.difficultys) {
                [alertView addButtonWithTitle:title];
            }
            
        }
            break;
        case 3:
        {
            alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            for (NSString *title in self.viewModel.spendTimes) {
                [alertView addButtonWithTitle:title];
            }
        }
            break;
        default:
            break;
    }
    
    @weakify(alertView,self);
    [[alertView.rac_buttonClickedSignal ignore:@(alertView.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
        @strongify(alertView,self);
        NSString *title = [alertView buttonTitleAtIndex:x.intValue];
        
        switch (sender.tag) {
            case 2:
            {
                self.viewModel.difficultyType = [self.viewModel.difficultys indexOfObject:title];
                self.difficulty.text =title;
            }
                break;
            case 3:
            {
                self.timer.text =title;
                self.viewModel.spendTimeType = [self.viewModel.spendTimes indexOfObject:title];            }
                
                break;
            default:
                break;
        }
        
    }];
    [alertView show];
    
}


///第二区的单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return [self.viewModel heightForRowAtIndexPath:indexPath]*[self.viewModel numberOfItemsInSection:1] ;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


///区高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return 0.f;
    }
    return KSectionFoot;
}


// 添加食材
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0||section==1||section==3) {
        NSString *titleText;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSectionFoot)];
        UILabel *title = [[UILabel alloc]initWithFrame:view.frame];
        switch (section) {
            case 0:
            {
                titleText = @"秘籍标题";
            }
                break;
            case 1:
            {
                titleText = @"秘籍材料";
            }
                break;
            case 3:
            {
                titleText = @"秘籍描述";
            }
                break;
                
            default:
                break;
        }
        title.text=titleText;
        title.textColor = [UIColor blackColor];
        title.textAlignment = NSTextAlignmentCenter;
        [view addSubview:title];
        return view;
    }
    return nil;
}




#pragma mark - 下一步按钮
- (IBAction)onNext:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    // 提示信息
    CHECK(self.name.text.length<=0, @"秘籍名称还没填写");
    CHECK(self.name.text.length>=10, @"秘籍名称过长");
    CHECK(self.describe.text.length<=0, @"描述还没填写");
    CHECK(self.viewModel.modelsProxy.count<=0, @"食材还没添加");
    
    self.viewModel.name = self.name.text;
    self.viewModel.describe = self.describe.text;
    
    if (self.viewModel.isEditMode) {
        YCRecipeStepListVM *vm = [YCRecipeStepListVM new];
        vm.materialVM = self.viewModel;
        for (YCStepList *m in self.viewModel.editRecipeDetailVM.model.recipeStepList) {
            YCRecipeStepListM *pfm = [YCRecipeStepListM new];
            pfm.imagePath = IMAGE_LARGE(m.imagePath);
            pfm.desc = m.desc;
            pfm.ID = m.Id;
            [vm.modelsProxy addObject:pfm];
        }
        [self pushTo:[YCRecipeStepListVC class] viewModel:vm];
        
    } else {
        [self.viewModel saveCacheViewModel];
        
        YCRecipeStepListVM *vm = [YCRecipeStepListVM cacheViewModel];
        if (!vm) {
            vm = [YCRecipeStepListVM new];
        }
        vm.materialVM = self.viewModel;
        [self pushTo:[YCRecipeStepListVC class] viewModel:vm];
    }
    
}


//下拉刷新
- (void)onSetupRefreshControl
{
    ;
}
///网络加载
- (void)onSetupActivityIndicatorView
{
    ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setViewModel:self.viewModel];
    if ([segue.destinationViewController isKindOfClass:[YCMaterialListVC class]]) {
        self.addMaterialVC = segue.destinationViewController;
    }
}

@end

@interface YCMaterialListVC ()
@property(nonatomic,strong)YCMaterialVM *viewModel;
@end
@implementation YCMaterialListVC
@synthesize viewModel;

#pragma mark -
- (void)dealloc{
    //ok
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.viewModel.title) {
        [self performSelector:@selector(jump) withObject:nil afterDelay:1];
    }
}

- (void)jump
{
    @try {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
}

- (void)onUpdateCell:(UITableViewCell *)cell model:(YCMaterialList *)model atIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UILabel *tf1 = [cell viewByTag:1];
        tf1.text = model.materialName;
        
        UILabel *tf2 = [cell viewByTag:2];
        tf2.text = model.quantity;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id m = [self.viewModel modelForItemAtIndexPath:indexPath];
    self.viewModel.editModel = m;
    [self.parentViewController performSegueWithIdentifier:@"addMaterial" sender:nil];
}


- (IBAction)onDelete:(UIButton *)sender {
    UITableViewCell *cell = sender.findTableViewCell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UITableViewController *tc = (id)self.parentViewController;
    @try {
        [tc.tableView beginUpdates];
        [self.viewModel removeModelAtIndexPath:indexPath];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tc.tableView endUpdates];
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
    
}

#pragma mark -
- (void)onSetupRefreshControl
{
    
}

- (void)onSetupActivityIndicatorView
{
    
}

@end







