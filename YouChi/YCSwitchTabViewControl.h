//
//  YCSwitchTabViewControl.h
//  YouChi
//
//  Created by 李李善 on 16/1/23.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewController.h"
#import "YCSwitchTabControl.h"
#import "YCMarcros.h"

@interface YCSwitchTabViewControl : YCViewController
@property(nonatomic,strong) UITabBarController *tabVC;
@property (weak, nonatomic) IBOutlet YCSwitchTabControl *tabControl;
///title和网站－－>@[@｛title : url｝,@｛title : url｝];
@property(nonatomic,strong) NSArray *urlAntTitle;
-(void)onCreachTabViewControl;
- (IBAction)onSwitchTabControler:(YCSwitchTabControl *)sender;
@end
