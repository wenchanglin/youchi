//
//  YCPrivateDetailednessVC.m
//  YouChi
//
//  Created by 李李善 on 15/5/18.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPrivateDetailednessVC.h"
#import "YCView.h"
#import <Masonry/Masonry.h>



@interface YCPrivateDetailednessVC ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *stateBtns;
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic,strong) YCPrivateDetailednessVM *viewModel;
@end

@implementation YCPrivateDetailednessVC
@synthesize viewModel;

#pragma mark - 生命周期

- (void)dealloc
{
    //ok
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.carousel.hidden = NO;

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.carousel.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundImage = [UIImage imageNamed:@"状态选择栏-切_02"];

    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCoverFlow;

    for (UIButton *btn in self.stateBtns) {
        UIImageView *delete = [[UIImageView alloc]initWithImage:IMAGE(@"删除完成")];
        [btn addSubview:delete];
        [delete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn).offset(8);
            make.right.equalTo(btn).offset(-8);
        }];
    }
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:^(id next) {
        [self.carousel reloadData];
        [self.carousel setCurrentItemIndex:0];
    } error:self.errorBlock completed:nil executing:self.executingBlock];
    
    [self executeSignal:self.viewModel.userStateSignal next:^(NSArray *next) {
        [self _updateBtns:next];
    } error:self.errorBlock completed:nil executing:self.executingBlock];
}

#pragma mark -
- (void)_updateBtns:(NSArray *)arr
{
    [self.stateBtns enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        if (arr.count>idx) {
            YCPrivateDetailednessM *m = arr[idx];
            NSString *title = m.name;
            btn.hidden = NO;
            [btn setTitle:title forState:UIControlStateNormal];
        } else {
            btn.hidden = YES;
        }
        
        
    }];
}

 
#pragma mark - 躺枪
- (IBAction)onSelect:(UIButton *)sender {

    
    if ([self.viewModel numberOfItemsInSection:0]<=0||!self.viewModel.states||self.viewModel.states.count>=self.stateBtns.count) {
        return;
    }



    YCPrivateDetailednessM *m = self.viewModel.modelsProxy[self.carousel.currentItemIndex];

    BOOL hasMe = NO;
    for (YCBaseImageModel *pm in self.viewModel.states) {
        if ([pm.Id isEqualToNumber:m.Id]) {
            hasMe = YES;
            break;
        }
    }
    if (hasMe) {
        [self showMessage:@"这个选过了，换一个呗"];
        return;
    }
    self.viewModel.hasSelected = YES;
    [self.viewModel.states addObject:m];
    [self _updateBtns:self.viewModel.states];
    
}

#pragma mark --删除
- (IBAction)onDelete:(UIButton *)sender {

    NSInteger idx = [self.stateBtns indexOfObject:sender];
    @try {
        
        [self.viewModel.states removeObjectAtIndex:idx];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        self.viewModel.hasSelected = YES;
        [self _updateBtns:self.viewModel.states];
        
    }
    
}

#pragma mark --返回
- (IBAction)onReturn:(UIButton *)sender
{
    if (!self.viewModel.hasSelected) {
        [self onReturn];
        return;
    }
    [sender executeActivitySignal:self.viewModel.updateStateSignal next:^(id next) {
        [self _updateBtns:self.viewModel.states];
    } error:nil completed:^{
        [self onReturn];
    } executing:nil];

}

#pragma mark -
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.viewModel numberOfItemsInSection:0];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view) {
        
        view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(carousel.bounds)-60, CGRectGetHeight(carousel.bounds))];
        view.cornerRadius = 2;
        view.backgroundColor = [UIColor whiteColor];
        view.clipsToBounds = YES;
        
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        imageview.tag = 100;
        imageview.clipsToBounds = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imageview];
        
        
        UILabel *lable = [UILabel new];
        lable.tag  = 200;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.numberOfLines = 2;
        [view addSubview:lable];
        
        UIEdgeInsets pad = UIEdgeInsetsMake(8, 5, 5, 5);
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(view).insets(pad);
            make.bottom.equalTo(lable.mas_top);
        }];
        
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(view).insets(pad);
            make.height.mas_equalTo(40);
        }];

    }
    YCPrivateDetailednessM *m = self.viewModel.modelsProxy[index];
    UIImageView *imageview =[view viewByTag:100];
    //[imageview sd_setImageWithURL:m.squareImagePath placeholderImage:PLACE_HOLDER];
    [imageview yc_setImageWithURL:m.squareImagePath placeholder:PLACE_HOLDER];
    
    NSLog(@"%@",m.squareImagePath);
    
    UILabel *lable =(UILabel *)[view viewWithTag:200];
    lable.text = [[NSString alloc]initWithFormat:@"%@",m.name];

    
    return view;
}



- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 5;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return CGRectGetWidth(carousel.bounds)-20;;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
