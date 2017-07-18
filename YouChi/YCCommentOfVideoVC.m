//
//  YCCommentOfVideoVC.m
//  YouChi
//
//  Created by 朱国林 on 15/11/9.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCCommentM.h"
#import "YCCommentOfVideoVC.h"
#import "TQStarRatingView.h"
#import <IQTextView.h>
@interface YCCommentOfVideoVC ()<StarRatingViewDelegate>
/// 视频图片
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoPictrue;
/// 视频标题
@property (weak, nonatomic) IBOutlet UILabel *lVideoTitle;
/// 视频分数
@property (weak, nonatomic) IBOutlet UILabel *lVideoScore;
/// 星星
@property (weak, nonatomic) IBOutlet TQStarRatingView *startView;
/// 分数(打分)
@property (weak, nonatomic) IBOutlet UILabel *lScore;
/// 评论
@property (weak, nonatomic) IBOutlet IQTextView *textComment;


@end

@implementation YCCommentOfVideoVC
@synthesize viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textComment.placeholder = @"我也发表一下评论...";
    self.startView.delegate = self;
    [self.startView setScore:0.0 withAnimation:NO];
    
    WSELF;
    [[RACObserve(self.viewModel, videoModel) ignore:nil].deliverOnMainThread subscribeNext:^(YCChihuoyingM_1_2 *x) {
        SSELF;
        //[self.imgVideoPictrue sd_setImageWithURL:x.imagePath placeholderImage:AVATAR_LITTLE];
        [self.imgVideoPictrue yc_setImageWithURL:x.imagePath placeholder:AVATAR_LITTLE];
        self.lVideoTitle.text = x.title;
        self.lVideoScore.text = [NSString stringWithFormat:@"%.1f",x.totalFraction.intValue/10.0];
    }];
}
- (id)onCreateViewModel{
    
    return [YCCommentOfVideoVM new];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --代理方法
- (void)starRatingView:(TQStarRatingView *)view score:(float)score{
    
    self.lScore.text = [NSString stringWithFormat:@"%0.1f",score * 10 ];
    
}
- (IBAction)onSendComment:(id)sender {
    
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
