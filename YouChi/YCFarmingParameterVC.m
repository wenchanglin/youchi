//
//  YCFarmingParameterVC.m
//  YouChi
//
//  Created by 李李善 on 16/1/22.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFarmingParameterVC.h"
#import "YCCommodity.h"

@interface YCFarmingParameterVC ()

@end

@implementation YCFarmingParameterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)onUpdateCell:(UITableViewCell *)cell model:(YCShopSpecs *)model atIndexPath:(NSIndexPath *)indexPath{
     UILabel *parameterName = [cell viewByTag:1];
     UILabel *parameterValue =  [cell viewByTag:2];
    
    parameterName.font = [UIFont systemFontOfSize:13];
    parameterName.textColor = KBGCColor(@"#272636");
    
    parameterValue.font = [UIFont systemFontOfSize:13];
    parameterValue.textColor = KBGCColor(@"#65656D");
    
    parameterValue.text = [NSString stringWithFormat:@"%@",model.parameterValue];
    parameterName.text = model.parameterName;
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


@interface YCFarmingParameterVCP()
@property (strong, nonatomic) YCFarmingParameterVM *viewModel;
///图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
///名字
@property (weak, nonatomic) IBOutlet UILabel *lName;
///内容
@property (weak, nonatomic) IBOutlet UILabel *lDes;
/// 俩个线条高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHeight;

@end
@implementation YCFarmingParameterVCP
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.viewModel.title;
    WSELF;
    [[RACObserve(self.viewModel,itemDetailM)deliverOnMainThread ]subscribeNext:^(YCItemDetailM * x) {
        SSELF;
        [self.imgView ycShop_setImageWithURL:x.imagePath placeholder:AVATAR_LITTLE];
        
        self.lName.text = x.brief;
        self.lDes.text  = x.desc;
    }];
    
    self.leftHeight.constant = 0.5;
    self.rightHeight.constant = 0.5;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController]setViewModel:self.viewModel];
 }


@end

