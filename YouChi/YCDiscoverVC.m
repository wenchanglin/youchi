//
//  YCDiscoverVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCDiscoverVC.h"
#import "YCVideoVC.h"
#import "YCNewsVC.h"
#import "YCPushManager.h"
#import "UIView+WZLBadge.h"
#import "YCMessageVC.h"
@interface YCDiscoverVC ()
{  ///控制咨询和视频的tac
    UITabBarController *_tbc;
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnMessage;

@end

@implementation YCDiscoverVC
SYNTHESIZE_VM;
- (void)dealloc{
    //    OK
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.discTab insertSegmentWithTitle:@"资讯" image:@"资讯图标" selectedImage:@"资讯图标2"];
    [self.discTab insertSegmentWithTitle:@"视频" image:@"视频图标2" selectedImage:@"视频图标"];
    
    self.discTab.normalColor = KBGCColor(@"#d09356");
    self.discTab.selectedColor = KBGCColor(@"#000000");
    
    [self.discTab setNormalBGColor:KBGCColor(@"#000000") selectedBGColor:KBGCColor(@"#d09356")];
    
    self.discTab.isSegmentLineHidden = YES;
    
    self.discTab.borderColor = color_yellow;
    self.discTab.borderWidth = 1;

    self.discTab.cornerRadius = 2;
    [self.discTab buttonCornerRadius:2];
    
    self.discTab.backgroundColor = color_yellow;
    
    [self.discTab addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
    
    [RACObserve(PUSH_MANAGER, hasNewMessage) subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [self.btnMessage showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeShake];
        } else {
            [self.btnMessage clearBadge];
        }
    }];
}


- (void)onChange:(YCSwitchTabControl *)sender{

    _tbc.selectedIndex = sender.selectedSegmentIndex;
}

- (IBAction)onPuMessage:(id)sender {
    if ([self pushToLoginVCIfNotLogin]) {
        return;
    }
    [YCPushManager sharedPushManager].hasNewMessage = NO;
    [self.btnMessage clearBadge];
    
    [self pushTo:[YCMessageVC class]];
}


- (IBAction)segmentChang:(UISegmentedControl *)sender {
    [self.view endEditing:YES];
    _tbc.selectedIndex =sender.selectedSegmentIndex;
 
  
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITabBarController *tbc = segue.destinationViewController;
    _tbc = tbc;
}


@end
