//
//  YCAboutYouChiVC.m
//  YouChi
//
//  Created by 朱国林 on 16/5/9.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <ACETelPrompt/ACETelPrompt.h>
#import "YCAboutYouChiVC.h"

@interface YCAboutYouChiVCP ()

@end

@implementation YCAboutYouChiVCP

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
}

- (IBAction)onCalledUs:(UIButton *)sender {
    
    
    [ACETelPrompt callPhoneNumber:CustomerService call:^(NSTimeInterval duration) {
        
    } cancel:^{
        ;
    }];
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

@interface YCAboutYouChiVC ()

@end

@implementation YCAboutYouChiVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
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
