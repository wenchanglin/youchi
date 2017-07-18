//
//  YCGroupPurchaseVCP.m
//  YouChi
//
//  Created by 朱国林 on 16/5/12.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCErweimaVC.h"
#import "YCGroupPurchaseVCP.h"
#import "YCMyInitiateGroupPurchaseVC.h"
#import "YCMyParticipationGroupPurchaseVC.h"
#import "YCPurchaseQrCodeVC.h"

@interface YCGroupPurchaseVCP ()

@end

@implementation YCGroupPurchaseVCP
- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.title = @"附近团拼";
}

-(void)onCreachTabViewControl{

    NSMutableArray *vcs =[NSMutableArray new];
    
    
    
    YCNewstGroupPurchaseVC *vc0 = [YCNewstGroupPurchaseVC new];
    vc0.viewModel = [YCNewstGroupPurchaseVM new];
    
    
    YCMyInitiateGroupPurchaseVC*vc1 = [YCMyInitiateGroupPurchaseVC new];
    vc1.viewModel = [YCMyInitiateGroupPurchaseVM new];
    
    YCMyParticipationGroupPurchaseVC*vc2 = [YCMyParticipationGroupPurchaseVC new];
    vc2.viewModel = [YCMyParticipationGroupPurchaseVM new];
                    
    [self.tabControl insertSegmentWithTitle:@"最新团拼" image:nil];
    [self.tabControl insertSegmentWithTitle:@"我发起的团拼" image:nil];
    [self.tabControl insertSegmentWithTitle:@"我参与的团拼" image:nil];
    
    self.tabControl.hasBottomLine = YES;
    self.tabControl.normalColor = KBGCColor(@"#535353");
    self.tabControl.backgroundColor = KBGCColor(@"ebebeb");
                
    [vcs addObject:vc0];
    [vcs addObject:vc1];
    [vcs addObject:vc2];
                                    
    [self.tabVC setViewControllers:vcs animated:YES];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YCPayGroupPurchaseVCNotification object:nil]subscribeNext:^(id x) {
        [vcs enumerateObjectsUsingBlock:^(YCBTableViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
            [vc onReload:nil];
        }];
    }];
}


- (IBAction)onSwitchTabControler:(YCSwitchTabControl *)sender {
    
    
    if (sender.selectedSegmentIndex > 0) {
        
        if ([self pushToLoginVCIfNotLogin]) {
            sender.loginsSegmentIndex = sender.selectedSegmentIndex;
            return;
        }
    }
    
    self.tabVC.selectedIndex = sender.selectedSegmentIndex;
    [sender segmentLineScrollToIndex:sender.selectedSegmentIndex animate:YES];
}


#pragma mark --扫一扫
- (IBAction)onQrCode:(UIBarButtonItem *)sender {
    
    YCErweimaVC *vc = [YCErweimaVC vcClass];
    [self pushToVC:vc];
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
