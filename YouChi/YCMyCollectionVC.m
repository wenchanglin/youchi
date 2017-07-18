//
//  YCMyCollectionVC.m
//  YouChi
//
//  Created by 朱国林 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyCollectionVC.h"

@interface YCMyCollectionVC ()
{
    int _selecotIndx;
    UITabBarController *_tbc;
    UIView * _View;
    CGSize _size;
}
@end

@implementation YCMyCollectionVC

-(void)dealloc{
    //    ok
    
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
    self.title = @"我的收藏";

    [self _initOpints];
    
}

-(void)_initOpints
{
    
    [self.options insertSegmentWithTitle:@"随手拍" image:nil];
    [self.options insertSegmentWithTitle:@"秘籍" image:nil];
    [self.options insertSegmentWithTitle:@"资讯" image:nil];
    [self.options insertSegmentWithTitle:@"视频" image:nil];
    [self.options insertSegmentWithTitle:@"商品" image:nil];
    self.options.backgroundColor = KBGCColor(@"#ebebeb");
    self.options.normalColor = KBGCColor(@"#535353");
//    [self.options onCreachSpecialWithSelColor:nil normalColor:nil font:0];
    [self.options addTarget:self action:@selector(selector:) forControlEvents:UIControlEventValueChanged];
    
   

}


-(void)selector:(YCSwitchTabControl *)sender
{
    [self.view endEditing:YES];
    [sender segmentLineScrollToIndex:sender.selectedSegmentIndex animate:YES];
    _tbc.selectedIndex =sender.selectedSegmentIndex;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITabBarController *tbc = segue.destinationViewController;
    tbc.tabBar.hidden = YES;
    _tbc = tbc;
    
    
}

@end
