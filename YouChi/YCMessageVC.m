//
//  YCMessageVC.m
//  YouChi
//
//  Created by sam on 15/5/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMessageVC.h"
#import <YQBadgeCategory/UIView+WZLBadge.h>
#import "YCView.h"

@interface YCMessageVC ()
{
    UITabBarController *_tbc;
}
@property (weak, nonatomic) IBOutlet YCSwitchTabControl *tabControl;
@end

@implementation YCMessageVC
- (void)dealloc{
    //ok
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RDVTabBarController *tbc = self.rdv_tabBarController;
    if (!tbc.isTabBarHidden) {
        [self hideTabbar];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  onXuanXiang];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITabBarController *tbc = segue.destinationViewController;
    tbc.tabBar.hidden = YES;
    _tbc = tbc;
}


-(void)selector:(YCSwitchTabControl *)sender
{
    [sender segmentLineScrollToIndex:sender.selectedSegmentIndex animate:YES];
    
    _tbc.selectedIndex =sender.selectedSegmentIndex;
    
}

-(void)onXuanXiang
{   [self.tabControl insertSegmentWithTitle:@"通知" image:nil];
    [self.tabControl insertSegmentWithTitle:@"评论" image:nil];
     self.tabControl.backgroundColor =KBGCColor(@"f7f7f7");
    [self.tabControl onCreachSpecialWithSelColor:nil normalColor:nil font:0];
    self.tabControl.hasBottomLine = YES;
    [self.tabControl addTarget:self action:@selector(selector:) forControlEvents:UIControlEventValueChanged];
    
    
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






