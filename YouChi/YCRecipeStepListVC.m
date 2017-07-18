//
//  YCNewSkillYC.m
//  YouChi
//
//  Created by 李李善 on 15/5/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRecipeStepListVC.h"
#import "YCRecipeStepListVM.h"
#import "YCRecipeStepListCell.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"
#import <IQTextView.h>
#import <GKImagePicker@robseward/GKImagePicker.h>
#import "YCDetailControlVCP.h"
#import "YCEditPhotoVC.h"
//#import "YCMySecretBookVC.h"
//完成发秘籍后跳转我的作品
//#import "YCMyshareVC.h"
#import <UIImage-Resize/UIImage+Resize.h>
#import "YCRecipeAddStepVC.h"
#pragma mark------2------主控住器
@interface YCRecipeStepListVCP ()
@property (nonatomic,strong) YCRecipeStepListVM *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@end

@implementation YCRecipeStepListVCP
@synthesize viewModel;
- (void)dealloc{
    //ok
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
         self.addBtn.enabled = NO;
        @try {
            
            [self performSelector:@selector(jump) withObject:nil afterDelay:1];
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            
            
        }
        self.addBtn.enabled = YES;
    }
}

- (void)jump
{
    [self onAddStep:nil];
   
}

- (IBAction)onAddStep:(id)sender {
    UIViewController *vc = [self vcClassWithIdentifier:@"YCRecipeAddStepVC"];
    vc.viewModel = self.viewModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onNextStepAddCover:(UIBarButtonItem *)sender {
    if ([self.viewModel numberOfItemsInSection:0] == 0) {
        [self showMessage:@"请添加至少一个步骤"];
        return ;
    }
    UIViewController *vc = [self vcClassWithIdentifier:@"YCRecipeAddCoverVC"];
    
    vc.viewModel = self.viewModel;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setViewModel:self.viewModel];
}


@end




#pragma mark------3------步骤列表控制器
@interface YCRecipeStepListVC ()
@property(nonatomic,strong)YCRecipeStepListVM *viewModel;
@end

@implementation YCRecipeStepListVC
@synthesize viewModel;
- (void)dealloc{
    //ok
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.editModel = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CHTCollectionViewWaterfallLayout *layout = (id)self.collectionViewLayout;
    layout.minimumInteritemSpacing = 10;
    
    layout.sectionInset = UIEdgeInsetsMake(16, 10, 10, 10);
    
    self.collectionView.contentInset =UIEdgeInsetsMake(0, 0, 100, 0);
    
    WSELF;
    [RACObserve(self.viewModel, modelsProxy) subscribeNext:^(id x) {
        SSELF;
        [self onReloadItems:nil];
    }];
    
}



-(void)onUpdateCell:(YCRecipeStepListCell *)cell model:(YCRecipeStepListM *)model atIndexPath:(NSIndexPath *)indexPath
{
    
    cell.identifier.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
    
    if (model.image) {
        cell.bjImage.image = model.image;
    } else {
        [cell.bjImage ycNotShop_setImageWithURL:model.imagePath placeholder:PLACE_HOLDER];
    }
    
    cell.title.text = model.desc;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"菜单" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改",@"删除", nil];
    WSELF;
    [[as.rac_buttonClickedSignal ignore:@(as.cancelButtonIndex)] subscribeNext:^(NSNumber *x) {
        SSELF;
        int index = x.intValue;
        if (index == 0) {
            YCRecipeStepListVM *vm = self.viewModel;
            vm.title = @"编辑步骤";
            vm.editModel = [vm modelForItemAtIndexPath:indexPath];
            UIViewController *vc = [self vcClassWithIdentifier:@"YCRecipeAddStepVC"];
            vc.viewModel = vm;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        else if (index == 1) {
            @try {
                [self.viewModel removeModelAtIndexPath:indexPath];
            }
            @catch (NSException *exception) {
                ;
            }
            @finally {
                ;
            }
        }
        
    }];
    [as showInView:collectionView];
 
}


- (void)onSetupRefreshControl
{
    
}

- (void)onSetupActivityIndicatorView
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setViewModel:self.viewModel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

