//
//  YCVideoBannerVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/27.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCVideoBannerVC.h"
#import "YCVideoBannerVM.h"
#import <Masonry/Masonry.h>
#import "YCCollectionPhotoCell.h"
#import "YCWebVC.h"
#import "YCVideoBannerM.h"
#import <ImagePlayerView/ImagePlayerView.h>
@interface YCVideoBannerVC () <ImagePlayerViewDelegate>
@property (nonatomic,strong) UIPageControl *pageControl;
PROPERTY_STRONG_VM(YCVideoBannerVM);
@property (nonatomic,readonly) ImagePlayerView *imagePlayerView;
@end

@implementation YCVideoBannerVC
SYNTHESIZE_VM;
-(void)dealloc{
    //    ok
}

- (ImagePlayerView *)imagePlayerView
{
    return (ImagePlayerView *)self.view;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imagePlayerView.imagePlayerViewDelegate = self;
    
    self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
 
}
#pragma mark - 加载

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    [self executeSignal:self.viewModel.mainSignal next:^(NSArray *next) {
        BOOL b = next.count > 1;
        self.imagePlayerView.endlessScroll = self.imagePlayerView.autoScroll = b;
        self.imagePlayerView.hidePageControl = !b;
        [self.imagePlayerView reloadData];
    } error:self.errorBlock completed:nil executing:nil];
}

- (id)onCreateViewModel
{
    return [YCVideoBannerVM new];
}

- (NSInteger)numberOfItems
{
    return self.viewModel.modelsProxy.count;
}


- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    YCVideoBannerM *m = [self.viewModel modelForItemAtIndex:index];
    
    [imageView ycNotShop_setImageWithURL:m.imagePath placeholder:PLACE_HOLDER];
}


- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    YCVideoBannerM *m = [self.viewModel modelForItemAtIndex:index];
    YCWebVM *vm = [[YCWebVM alloc]initWithModel:m];
    vm.url = m.originalAction;
    
    vm.shareImageUrl = IMAGE_HOST_NOT_SHOP(m.imagePath);
    vm.shareUrl = [m.originalAction stringByAppendingString:@"&share=1"];
    vm.title = m.title;
    [self pushTo:[YCWebVC class] viewModel:vm];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
