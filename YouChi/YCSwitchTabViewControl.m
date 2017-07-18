//
//  YCSwitchTabViewControl.m
//  YouChi
//
//  Created by 李李善 on 16/1/23.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSwitchTabViewControl.h"

@interface YCSwitchTabViewControl ()

@end

@implementation YCSwitchTabViewControl

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self onCreachTabViewControl];
    
    
}

-(void)onCreachTabViewControl{
//    [self.tabControl onCreachSpecialWithSelColor:nil  normalColor:nil font:17];
//    
//    NSArray *titles = urlAntTitle;
//    NSMutableArray *vcs = [NSMutableArray new];
//    [titles enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.tabControl insertSegmentWithTitle:dict.allKeys.firstObject image:nil];
//        
//        YCMyCouponVC *vc = [YCMyCouponVC new];
//        vc.viewModel  = [[YCMyCouponVM alloc]initWithURL:dict.allValues.firstObject];
//        vc.chooseType = idx;
//        if (idx==1) {
//            self.vc =vc;
//        }
//        [vcs addObject:vc];
//    }];
//    
//    [self.tabVC setViewControllers:vcs animated:YES];
}

- (IBAction)onSwitchTabControler:(YCSwitchTabControl *)sender {
    
    self.tabVC.selectedIndex = sender.selectedSegmentIndex;
    [sender segmentLineScrollToIndex:sender.selectedSegmentIndex animate:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.tabVC =segue.destinationViewController;
    [self.tabVC setViewModel:self.viewModel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
