//
//  YCSearchDetailVC.h
//  YouChi
//
//  Created by 李李善 on 15/8/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCSearchDetailVM.h"
#import "YCWorksOfyouChiVC.h"

@interface YCSearchDetailVCP : YCViewController<UITextFieldDelegate>

///第二界面的搜索
@property (weak, nonatomic) IBOutlet UITextField *searchText;

- (IBAction)onSeacrh:(id)sender;
@end


@interface YCSearchDetailVC : YCTableViewController
@end

@interface YCSearchYouchiVC : YCChihuoyingVC

@end