//
//  YCSmallHelperTwoDetailedVC.m
//  YouChi
//
//  Created by 李李善 on 15/6/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGuodanDetailVC.h"

#define KSize [[UIScreen mainScreen]bounds].size
#import "YCGuodanDetailVC.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface YCGuodanDetailVC ()<MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *tupian;
@property (weak, nonatomic) IBOutlet UILabel *biaoti;
@property (weak, nonatomic) IBOutlet UILabel *shijian;
@property (strong, nonatomic) YCGuodanDetailVM *viewModel;
@end

@implementation YCGuodanDetailVC
@synthesize viewModel;

- (void)dealloc{
    //ok
}
#pragma mark -
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
   [super viewDidLoad];

}

- (void)onSetupCell
{
    
}

#pragma mark --刷新
- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupFooter
{
    
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:^(YCGuopinDetailM *next) {
        [self onReloadItems:0];
        self.title = next.name;
        
    } error:self.errorBlock completed:nil executing:self.executingBlock];
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
        SSELF;
        id m = [self.viewModel modelForItemAtIndexPath:indexPath];
        if (![cell checkIsHasSetData:m]) {
            [self onUpdateCell:cell model:m atIndexPath:indexPath];
        }
    }];
}

- (void)onUpdateCell:(UITableViewCell *)cell model:(YCGuopinDetailM *)model atIndexPath:(NSIndexPath *)indexPath
{
    YCGuopinDetailM *m = model;
    switch (indexPath.section) {
        case 0:
        {
            [cell.contentView yc_setImageWithURL:model.imagePath placeholder:PLACE_HOLDER];
        }break;
        case 1:{
            UILabel *title = [cell.contentView viewByTag:1];
            UILabel *time = [cell.contentView viewByTag:2];
            title.text = [[NSString alloc]initWithFormat:@"   %@",model.name];
            time.text = model.createdDate;
        }break;
            
        case 2:{
            UILabel *miaoshu = [cell.contentView viewByTag:1];
            miaoshu.text = model.desc;
        }break;
    
        case 3:
        {
            UILabel *mingcheng = [cell.contentView viewByTag:1];
            UILabel *miaoshu = [cell.contentView viewByTag:2];
            switch (indexPath.row) {
                case 0:
                    mingcheng.text = @"功效：";
                    miaoshu.text = m.effect;
                    break;
                case 1:
                    mingcheng.text = @"人群：";
                    miaoshu.text = m.suitableFor;
                    break;
                case 2:
                    mingcheng.text = @"营养：";
                    miaoshu.text = m.nutrition;
                    break;
                case 3:
                    mingcheng.text = @"搭配：";
                    miaoshu.text = m.taboo;
                    break;
                    
                default:
                    break;
            }
        }break;

        default:
            break;
    }
}


#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self showPhoto:0];
    }
}


- (void)showPhoto:(NSInteger)index
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [[MWPhoto alloc]initWithURL:NSURL_URLWithString(self.viewModel.model.imagePath)];
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
