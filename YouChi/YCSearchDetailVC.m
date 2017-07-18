//
//  YCSearchDetailVC.m
//  YouChi
//
//  Created by 李李善 on 15/8/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchDetailVC.h"
#import "YCMeM.h"
///他人界面
#import "YCOthersInfoVC.h"
///视频
#import "YCVideosDetailVC.h"
///随手拍
#import "YCYouChiDetailVC.h"
///资讯
#import "YCWebVC.h"
#import "YCNewsM.h"

///第三级详细界面
#import "YCSearchDetaiLlistVC.h"

#import "YCSearchDetailOphoneCell.h"

@interface YCSearchDetailVCP () <UITextFieldDelegate>
@property(nonatomic,strong) YCSearchDetailVM *viewModel;

@end

@implementation YCSearchDetailVCP
@synthesize viewModel;
-(void)dealloc{
    //    ok
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.viewModel.title;
    self.searchText.text = self.viewModel.searchText;
    self.searchText.delegate = self;
}

- (void)onKeyboardDone:(id)sender
{
    //[self onSeacrh:sender];
}


- (IBAction)onSeacrh:(UIButton *)sender {
    [self.view endEditing:YES];


    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
    
}
- (void)delayMethod{
    [SVProgressHUD dismiss];
    if ( self.viewModel.isSearch==YES) {
        if ([self.viewModel.searchText isEqualToString:self.searchText.text] && [self.viewModel numberOfSections]>0) {
            return;
        }
        self.viewModel.searchText = self.searchText.text;
    }

    else
    {
        YCSearchDetaiLlistVM *VM =[[YCSearchDetaiLlistVM alloc]initWithCellId:cell0 HeightRow:68.f SearchlistType:YCSearchlistTypeUser];
        VM.searchText = self.searchText.text;
        [self pushTo:[YCSearchDetaiLlistVC class] viewModel:VM];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeySearch) {
        [self onSeacrh:nil];
        
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [segue.destinationViewController setValue:self.viewModel forKey:KP(self.viewModel)];
    
}


@end




@interface YCSearchDetailVC ()
@property(nonatomic,strong) YCSearchDetailVM *viewModel;


@end
@implementation YCSearchDetailVC
@synthesize viewModel;
-(void)dealloc{
    //    ok
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.indicator) {
        [super onSetupActivityIndicatorView];
        [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }
}


#pragma mark-------发请求
- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.viewModel.isSearch==YES) {
        WSELF;
        ///监听self.viewMoel 的属性: 有值立马发请求
        [RACObserve(self.viewModel,searchText) subscribeNext:^(NSString *text) {
            SSELF;
            [self executeSignal:[self.viewModel searchText:text] next:^(id next) {
                
                [self onReloadItems:0];
            } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
        }];

        
    }
    
}



-(void)onSetupCell{
    [self onRegisterNibName:@"YCSearchDetailOphoneCell" Identifier:cell0];
}


#pragma mark---- 更新方法
-(void)onUpdateCell:(YCSearchDetailOphoneCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell.reuseIdentifier isEqualToString:cell2]) {
        return;
    }
    if(indexPath.section==0)
    {
        YCMeM *m = (id)model;
        [cell updateIcon:m.imagePath title:m.nickName shouldShowAction:YES isSelected:m.isFollow.boolValue];
        [cell.action addTarget:self action:@selector(onAttention:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    else if (indexPath.section==1){
        YCChihuoyingM_1_2 *m = (id)model;
        [cell updateIcon:m.imagePath AttributedStr:m.ui_desc shouldShowAction:NO isSelected:NO];
    }

    else if (indexPath.section==2){
        YCChihuoyingM_1_2 *m = (id)model;
        [cell updateIcon:m.imagePath AttributedStr:m.ui_desc shouldShowAction:NO isSelected:NO];
    }

    else {
        YCNewsList *m = (id)model;
        [cell updateIcon:m.imagePath AttributedStr:m.ui_desc shouldShowAction:NO isSelected:NO];
    }
    
}



#pragma mark----关注和取消关注
-(void)onAttention:(UIButton *)sender{
    UITableViewCell *cell = sender.findTableViewCell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YCMeM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
    
    BOOL isLike =!m.isFollow.boolValue;
    [sender executeActivitySignal:[self.viewModel followUserById:m.Id isFollow:isLike]  next:^(id x) {
        m.isFollow = @(isLike);
    } error:self.errorBlock completed:nil executing:nil];
    
}

#pragma mark--单元格的选择
/**
 点击更多；都是传入一个 ViewModel（cellID  ,单元格高度 枚举）
 
 选择对象的单元格  进入对应的详细界面
 ｛
 0:吃货
 1:随手拍
 2:视频
 3:资讯
 ｝
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark---第0区  吃货
    if (indexPath.section==0) {
        
        if (self.viewModel.model.userList.count ==indexPath.row) {
            
            YCSearchDetaiLlistVM *VM =[[YCSearchDetaiLlistVM alloc]initWithCellId:cell0 HeightRow:68.f SearchlistType:YCSearchlistTypeUser];
            VM.searchText = self.viewModel.searchText;
            [self pushTo:[YCSearchDetaiLlistVC class] viewModel:VM];
            
        }
        else {
            YCMeM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            YCOthersInfoVM * vm = [[YCOthersInfoVM alloc]initWithId:m.Id];
            [self pushTo:[YCOthersInfoVC class] viewModel:vm];
        }
        
    }
#pragma mark---第1区  随手拍
    else if(indexPath.section==1)
    {
        if (self.viewModel.model.youchiList.count ==indexPath.row){
            YCChihuoyingOtherVC *vc = [YCChihuoyingOtherVC vcClass:[YCChihuoyingVC class] vcId:NSStringFromClass([YCChihuoyingOtherVC class])];
            
            
            YCSearchYouchiVM *vm = [[YCSearchYouchiVM alloc]initWithViewModel:self.viewModel];
            vc.viewModel = vm;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            YCYouChiDetailVM *vm = [[YCYouChiDetailVM alloc]initWithId:m.Id];
            vm.previousModel = m;
            [self pushTo:[YCYouChiDetailVC class] viewModel:vm ];
        }
        
    }
#pragma mark---第2区  视频
    else if (indexPath.section==2)
    {
        if (self.viewModel.model.videoList.count ==indexPath.row){
            
            YCSearchDetaiLlistVM *vm =[[YCSearchDetaiLlistVM alloc]initWithCellId:cell2 HeightRow:130.0f SearchlistType:YCSearchlistTypeVideo];
            vm.searchText = self.viewModel.searchText;
            [self pushTo:[YCSearchDetaiLlistVC class] viewModel:vm];
        }
        else
        {
            YCChihuoyingM_1_2 *m = [self.viewModel modelForItemAtIndexPath:indexPath];
            YCVideosDetailVM *vm = [[YCVideosDetailVM alloc]initWithModel:m];
            vm.urlString = apiGetRecommendList;
            vm.isUpdate = YES;
            vm.previousModel = m;
            [self pushTo:[YCVideosDetailVC class] viewModel:vm];
        }
    }
#pragma mark---第3区  资讯
    else {
        if (self.viewModel.model.newsList.count ==indexPath.row){
        
        YCSearchDetaiLlistVM *VM =[[YCSearchDetaiLlistVM alloc]initWithCellId:cell3 HeightRow:295.0f SearchlistType:YCSearchlistTypeRecommend];
        VM.searchText = self.viewModel.searchText;
        [self pushTo:[YCSearchDetaiLlistVC class] viewModel:VM];
    }
    
        else {
        YCNewsList *m = [self.viewModel modelForItemAtIndexPath:indexPath];
        NSString *url = [NSString stringWithFormat:@"%@informaction.html?id=%@",html_share,m.Id];
        YCWebVM *vm = [[YCWebVM alloc]initWithUrl:url];
        vm.shareUrl =  [NSURL URLWithString:url];
        vm.shareImageUrl = m.imagePath;
        [self pushTo:[YCWebVC class] viewModel:vm];
    }
        
    }
    
}

#pragma mark-------去头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height ;
    switch (section) {
        case 0:{
            height = self.viewModel.model.userList.count==0?0:34.f;
        }
            break;
        case 1:{
            height = self.viewModel.model.youchiList.count==0?0:34.f;
        }
            break;
        case 2:{
            height = self.viewModel.model.videoList.count==0?0:34.f;
        }
            break;
        case 3:{
            height = self.viewModel.model.newsList.count==0?0:34.f;
            
        }
            break;
            
        default:
            break;
    }
    

    return height;
}
#pragma mark-------区头标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    
    
    switch (section) {
        case 0:{
            title = self.viewModel.model.userList.count==0?nil:@"吃货";
        }
            break;
        case 1:{
            title = self.viewModel.model.youchiList.count==0?nil:@"随手拍";
        }
            break;
        case 2:{
            title = self.viewModel.model.videoList.count==0?nil:@"视频";
        }
            break;
        case 3:{
            title = self.viewModel.model.newsList.count==0?nil:@"资讯";
            
        }
            break;
            
        default:
            break;
    }
    
    
    return title;
}


#pragma mark-------下拉刷新，上啦加载
- (void)onSetupRefreshControl{
    
}
- (void)onSetupActivityIndicatorView{
    //[super onSetupActivityIndicatorView];
}
- (void)onSetupFooter{
    [super onSetupFooter];
}
- (void)onSetupEmptyView
{
    if ([self.viewModel numberOfSections]==0) {
        self.tableView.backgroundView = self.emptyView;
        self.emptyView.emptyLabel.text = @"搜不到您想要的东西";
    } else {
        self.tableView.backgroundView = nil;
    }
}
/**
 
  //Create PetBreed Object and return corresponding breed from corresponding array
     PetBreed *petBreed = nil;
  
     if(tableView == self.searchDisplayController.searchResultsTableView)
         petBreed = [_filteredBreedsArray objectAtIndex:indexPath.row];
     else
         petBreed = [_breedsArray objectAtIndex:indexPath.row];
  
     cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
     cell.textLabel.text = petBreed.name;
  
     return cell;
 */

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSize.width,70.f)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KSize.width-10,70.f)];
//    label.text = @"搜索历史";
//    label.font = [UIFont systemFontOfSize:19];
//    [view addSubview:label];
//    return view;
//}


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
