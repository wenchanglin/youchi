//
//  YCPrivateBookingVC.m
//  YouChi
//
//  Created by sam on 15/5/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPrivateBookingVC.h"
#import "YCPrivateBookingVM.h"

#import "YCView.h"
#import <Masonry/Masonry.h>
#import "YCPrivateDetailednessVC.h"
#import "YCPhotosView.h"
#import "YCRecipeDetailVC.h"

#import "YCCommentControl.h"
#import "YCPrivateBookingCell.h"

#import "YCPrivateImgView.h"
#import "YCErweimaVC.h"
#import "YCChihuoyingM.h"
#import "YCYouChiDetailVC.h"
#import "YCGuodanDetailVC.h"

@interface YCPrivateBookingVCP ()
{
    UIImageView *_avartar;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *humidity; //湿度
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *aqi;
@property (weak, nonatomic) IBOutlet YCPrivateImgView *zhuangtaiImage;
@property (weak, nonatomic) IBOutlet YCPhotosView *tuijianshuiguo;
@property (weak, nonatomic) IBOutlet UILabel *jieqi;

@property (nonatomic,strong) YCPrivateBookingVM *viewModel;
@end

@implementation YCPrivateBookingVCP
@synthesize viewModel;
- (void)dealloc{
    //ok
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _avartar.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _avartar.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.isTabBarHidden) {
        [self hideTabbar];
    }
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollsToTop = NO;

    WSELF;

    CGFloat h = CGRectGetHeight(self.tuijianshuiguo.bounds);
    self.tuijianshuiguo.pagingEnabled = NO;
    self.tuijianshuiguo.updateBlock = ^(UICollectionViewCell *cell,YCBaseImageModel *model) {
        UIImageView *iv = [cell viewByTag:1];
        iv.cornerRadius = h/2;
        iv.clipsToBounds = YES;
        
        [iv yc_setImageWithURL:model.imagePath placeholder:AVATAR_LITTLE];
    };
    self.tuijianshuiguo.sizeBlock = ^(CGSize size) {
        return CGSizeMake(size.height, size.height);
    };


    self.tuijianshuiguo.selectBlock = ^(NSIndexPath *indexPath,YCBaseImageModel *model) {
        SSELF;

        YCGuodanDetailVM *vm = [[YCGuodanDetailVM alloc]initWithId:model.Id];
        
        [self pushTo:[YCGuodanDetailVC class] viewModel:vm];
    };


    self.zhuangtaiImage.count = 0;

    [[self.viewModel getLocationInformationSignal]subscribeNext:^(YCLocationInfo *x) {
        SSELF;
        self.city.text = [[NSString alloc]initWithFormat:@" 城市:%@",[x.lastCity stringByReplacingOccurrencesOfString:@"市" withString:@""]];
    } error:self.errorBlock];


    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRefresh:) name:YCUserDefaultUpdate object:nil];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        SSELF;
        if (status > AFNetworkReachabilityStatusNotReachable) {
            [self onRefresh:nil];
        }
    }];

    [[RACObserve(self.viewModel, shouldUpdateState) ignore:@NO]subscribeNext:^(id x) {
        SSELF;
        [self onRefresh:nil];
    }];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _avartar.center = CGPointMake(self.navigationController.navigationBar.center.x, _avartar.center.y);
}





#pragma mark - 加载
- (id)onCreateViewModel
{
    return [YCPrivateBookingVM new];
}



- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    
    WSELF;
    [self executeSignal:self.viewModel.getPersonalHeaderSignal next:^(YCPrivateBookingM *m) {
        SSELF;

        //[self.backgroundImg sd_setImageWithURL:m.imagePathLarge placeholderImage:nil options:kImageOption];
        [self.backgroundImg yc_setImageWithURL:m.imagePath placeholder:nil];
        
        self.temperature.text = [[NSString alloc]initWithFormat:@"温度:%@℃",m.temperature];
        
        self.humidity.text = [[NSString alloc]initWithFormat:@"湿度:%@%%",m.humidity];
        
        self.aqi.text = [[NSString alloc]initWithFormat:@"AQI: %@",m.aqi];
        
        self.jieqi.text = [[NSString alloc]initWithFormat:@"节气:%@",m.jieqi];


        self.zhuangtaiImage.count = m.userStateList.count;
        [self _updateImgStates:m.userStateList];


        self.tuijianshuiguo.photos = m.materials;
                [self.tuijianshuiguo reloadData];
        
    } error:self.errorBlock completed:nil executing:^(BOOL isExecuting) {
        if (isExecuting) {
            [SVProgressHUD showWithStatus:@"正在为您选取食材" maskType:SVProgressHUDMaskTypeBlack];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)_updateImgStates:(NSArray *)arr
{
    [[self.zhuangtaiImage showImg]  enumerateObjectsUsingBlock:^(UIImageView *imgV, NSUInteger idx, BOOL *stop) {
        if (arr.count>idx) {
            YCPrivateBookinguserStateListM *lm = arr[idx];
            //[imgV sd_setImageWithURL:lm.roundImagePath placeholderImage:AVATAR_LITTLE options:kImageOption];
            [imgV yc_setImageWithURL:lm.roundImagePath placeholder:AVATAR_LITTLE];
        }
    }];
}

#pragma mark -选择状态
- (IBAction)onAdd:(id)sender {
    YCPrivateDetailednessVM *vm = [[YCPrivateDetailednessVM alloc]initWithViewModel:self.viewModel];
    [self pushTo:[YCPrivateDetailednessVC class] viewModel:vm];
}

- (IBAction)onRefresh:(id)sender {
    self.viewModel.pageInfo.status = YCLoadingStatusRefresh;
    [self onMainSignalExecute:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _avartar = ({
        UIImageView *avartar = [[UIImageView alloc]initWithImage:AVATAR_LITTLE];
        avartar.clipsToBounds = YES;
        UINavigationBar *nb = self.navigationController.navigationBar;
        [nb addSubview:avartar];
        
        
        avartar.borderColor = [UIColor whiteColor];
        avartar.borderWidth = [UIScreen mainScreen].scale;

        CGFloat h = CGRectGetHeight(nb.bounds)*1.5;
        CGRect frame = CGRectMake(0, 0, h, h);
        frame.origin.x = nb.center.x - h/2;
        avartar.frame = frame;
        
        avartar.cornerRadius = h/2;
        
        [RACObserve(self.viewModel,user) subscribeNext:^(YCLoginUserM *x) {
            [avartar yc_setImageWithURL:x.imagePath placeholder:AVATAR_LITTLE];
        }];
        avartar;
    });
    
    [segue.destinationViewController  setValue:self forKey:@"privateBookingContainerVC"];
    [segue.destinationViewController  setValue:_avartar forKey:@"avatar"];
    [segue.destinationViewController setValue:self.viewModel forKey:KP(self.viewModel)];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(tableView.bounds);
}

- (void)scrollViewDidScroll:(UITableView *)scrollView
{
    CGPoint center = _avartar.center;

    NSIndexPath *idp = [scrollView indexPathsForVisibleRows].lastObject;
    if (idp.section == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            _avartar.transform = CGAffineTransformMakeScale(0.6, 0.6);
            _avartar.center = CGPointMake(center.x, 20);
        }];
        
    }
    else if (idp.section == 0){
        CGFloat height = CGRectGetHeight(self.navigationController.navigationBar.bounds);
        CGFloat h = height*1.5;
        CGRect frame = CGRectMake(0, 0, h, h);
        frame.origin.x = center.x - h/2;

        [UIView animateWithDuration:0.5 animations:^{
            _avartar.transform = CGAffineTransformMakeScale(1, 1);
            _avartar.center = CGPointMake(center.x, h/2);
        }];
    }

}

@end



@interface YCPrivateBookingVC ()

@end

@implementation YCPrivateBookingVC

- (void)dealloc{
    //ok
}

- (void)showTabbar
{

}

- (void)onSetupCell
{

}

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];

}
- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next :self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

- (void)onSetupRefreshControl
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self onScrollToBottom:scrollView];

}

- (void)onUpdateCell:(YCPrivateBookingCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    [cell update:model atIndexPath:indexPath];
    [cell.avatarControl addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;

    float reloadDistance = -20;
    if(offsetY <= reloadDistance) {

        [self.privateBookingContainerVC.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];

    }

}


#pragma mark --点赞分享

- (IBAction)onLikeOrShare:(YCCommentControl *)sender
{
    [super onLikeOrShare:sender];
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
