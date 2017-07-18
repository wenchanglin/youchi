//
//  YCGenZuoVC.m
//  YouChi
//
//  Created by 李李善 on 15/6/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCAccusationVC.h"

#import "AppDelegate.h"

#import "YCChihuoyingM.h"

#import <NSAttributedString-DDHTML/NSAttributedString+DDHTML.h>

@interface YCAccusationVC ()<UIAlertViewDelegate>

PROPERTY_STRONG_VM(YCAccusationVM);
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *info;

@end

@implementation YCAccusationVC
SYNTHESIZE_VM;
#pragma mark -
- (void)dealloc{
    //ok
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionFooterHeight = 0.f;
    self.tableView.sectionHeaderHeight = 0.f;
    

        
    self.name.attributedText = self.viewModel.name;

    self.info.attributedText = self.viewModel.info;
    
}

#pragma mark -
- (id)onCreateViewModel
{
    return [YCAccusationVM new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1||indexPath.section==2) {
        return [self.viewModel heightForRowAtIndexPath:indexPath width:CGRectGetWidth(tableView.frame)];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 0.f;
    }
    return 10.f;
}




-(IBAction)onReport:(UIButton *)sender
{
    CHECK(self.viewModel.reports.count<=0,@"请选择你要举报的内容!!!!!");
    [sender executeActivitySignal:[self.viewModel onJuBaoSignal:self.viewModel.reports] next:^(id next) {
        [self showMessage:@"举报成功!!!"];
        [self.navigationController popViewControllerAnimated:YES];
    }  error:self.errorBlock completed:self.completeBlock executing:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [segue.destinationViewController setValue:self.viewModel forKey:KP(self.viewModel)];
}


@end


@interface YCSelectAccusationVC ()

@property(nonatomic,strong)YCAccusationVM *viewModel;
@end
@implementation YCSelectAccusationVC
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (void)onUpdateCell:(UITableViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = model;
    for (int i =0; i<array.count; i++) {
        UIButton *button = [cell viewByTag:1+i];
        button.hidden = YES;
    }
    for (int i = 0; i<array.count; i++)
    {
        NSString *str  = array[i];
        UIButton *button = [cell viewByTag:1+i];
        [button setTitle:str forState:UIControlStateNormal];
        button.hidden = NO;
    }
}



///选择举报
-(IBAction)onSelectReport:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    UITableViewCell *cell =sender.findTableViewCell;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSInteger integer = (sender.tag == 1 ? 2*indexPath.row - 1 : 2*indexPath.row)+1;
    NSString *str =self.viewModel.modelsProxy[integer];
    
    if (sender.isSelected==YES) {
        [self.viewModel.reports addObject:str];
    }else
    {
        [self.viewModel.reports removeObject:str];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
