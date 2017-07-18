//
//  YCPlayerVC.m
//  YouChi
//
//  Created by sam on 15/9/17.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCPlayerVC.h"
#import "YCDefines.h"
#import <Masonry/Masonry.h>
#import "YCMarcros.h"
@implementation YCPlayerVC
{
    
}
SYNTHESIZE_VM;

-(void)dealloc{
    //    ok
    
}


- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{

    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)loadView
{
    [TCCloudPlayerView setEnableCache:YES];
    self.view = self.player = [[TCCloudPlayerView alloc]initWithNotFullFrame:[UIScreen mainScreen].applicationFrame];
    self.player.isEnableRorateFullScreen = YES;
    self.player.isCyclePlay = NO;
    [self.player changeBottomFullImage:IMAGE(@"放大") notFullImage:IMAGE(@"缩小")];
    
    WSELF;
    // 退出或进入全屏播放
    self.player.enterExitFullScreenBlock = ^(BOOL isFullScreen) {  // 横竖屏幕时
        //SSELF;
        //[self.navigationController setNavigationBarHidden:isFullScreen animated:YES];
    };
    
    // 点击视频时回调
    self.player.clickPlaybackViewblock = ^(BOOL isFullScreen){     // 点击视频时
        //SSELF;
        
    };
    
    // 点击显示隐藏bottomView回调
    self.player.singleClickblock = ^(BOOL isBottomHide){     // 点击视频时
        SSELF;
        [self.navigationController setNavigationBarHidden:isBottomHide animated:YES];
    };
    
    // 开始播放（暂停后恢复也会回调）
    self.player.playbackBeginBlock = ^ {
        
    };
    
    // 每次播放完成后都会回调
    self.player.playbackEndBlock = ^ {
        
    };
    
    // 播放失败后都会回调
    self.player.playbackFailedBlock = ^(NSError* error) {
        SSELF;
        [self showMessage:error.localizedDescription];
    };
    
    // 暂停回调
    self.player.playbackPauseBlock = ^(UIImage* curVideoImg, TCCloudPlayerPauseReason reason) {
        
    };
    
    // 准备播放回调
    self.player.playbackReadyBlock = ^ {
        
    };
}

- (instancetype)initWithFullUrlString:(NSString *)url
{
    _fullUrlString = url;
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    
    NSMutableArray* urls = [[NSMutableArray alloc]initWithCapacity:1];
    
    if (!_fullUrlString) {
        _fullUrlString = self.viewModel.model.filePath;
        self.title = self.viewModel.model.title;
    }
    TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info.videoUrlTypeName = nil;
    info.videoUrl = [NSURL URLWithString:_fullUrlString];
    [urls addObject:info];
    
    
    if (![self.player isPlaying]) {
        [self.player setUrls:urls defaultPlayIndex:0 startTime:0];
    }

}

- (void)_initBackButton{

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(onDismissReturn) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    self.backButton = backButton;
}
@end
