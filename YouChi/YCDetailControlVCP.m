



//
//  YCChihuoyingVCP.m
//  YouChi
//
//  Created by 李李善 on 15/8/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCDetailControlVCP.h"
#import "YCYouChiDetailVM.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "YCRunLabel.h"
#import <AutoScrollLabel/CBAutoScrollLabel.h>
///举报
#import "YCAccusationVC.h"
#import "YCCommentOfVideoVC.h"


#pragma mark -
@interface YCDetailControlVCP ()

@property(nonatomic,strong) CBAutoScrollLabel *runView;
@end

@implementation YCDetailControlVCP
SYNTHESIZE_VM;
@synthesize inputBar;

- (void)dealloc{
    //ok
    
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.runView;
    
    NSAssert([self.viewModel conformsToProtocol:@protocol(YCDetailControlDatasource)], @"协议未实现");
    NSAssert([self.viewModel isKindOfClass:[YCViewModel class]], @"类型不对");
    
    [self.inputBar.inputControl.send addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
    
    RAC(self, title) = RACObserve(self.viewModel, title).deliverOnMainThread;
    
    WSELF;
    [[RACObserve(self.viewModel, updateModel) ignore:nil].deliverOnMainThread subscribeNext:^(YCChihuoyingM_1_2 *x) {
        SSELF;
        [self.inputBar updateWithIsLike:x.isLike.boolValue isFavorite:x.isFavorite.boolValue];
    }];
    
    [RACObserve(self.viewModel, replyModel).deliverOnMainThread subscribeNext:^(YCChihuoyingM_1_2 *x) {
        SSELF;
        if (x) {
            self.inputBar.inputControl.content.placeholder = [[NSString alloc]initWithFormat:@"回复%@",x.userName];
        } else {
            self.inputBar.inputControl.content.placeholder = [[NSString alloc]initWithFormat:@"评论%@",self.title];
        }
    }];
}

-(CBAutoScrollLabel *)runView
{
    if (!_runView) {
        _runView = [[CBAutoScrollLabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
        _runView.textColor = color_yellow;
        _runView.textAlignment = NSTextAlignmentCenter;
        _runView.font = [UIFont systemFontOfSize:18];
    }
    return _runView;
}

- (NSString *)title
{
    return self.runView.text;
    
}

- (void)setTitle:(NSString *)title
{
    
    [self.runView setText:title];
    
}

#pragma mark --举报
-(IBAction)onReport:(id)sender
{
    YCChihuoyingM_1_2 *m = self.viewModel.updateModel;
    if (!m) {
        return;
    }
    
    if ([self pushToLoginVCIfNotLogin]) {
        return;
    }
    
    YCAccusationVM *vm = [[YCAccusationVM alloc]initWithModel:m];
    
    [self pushTo:[YCAccusationVC class] viewModel:vm];
}

#pragma mark - 操作
- (IBAction)onAct:(YCLeftCommentControl *)sender {
    YCChihuoyingM_1_2 *m = self.viewModel.updateModel;
    if (!m) {
        return;
    }
    
    YCBaseModel *model = self.viewModel.previousModel;
    
    if (sender.selectedIndex == 0) {
        ///点赞
        UIButton *button = sender.like;
        BOOL like = !m.isLike.boolValue;
        [button executeActivitySignal:[self.viewModel  likeById:m.Id isLike:like type:self.viewModel.cheatsType] next:^(NSNumber *likeCount) {
            m.isLike  = @(like);
            button.selected =  like;
            
            m.likeCount = likeCount;
            
            if ([model respondsToSelector:@selector(isLike)]) {
                [model setValue:m.isLike forKey:KP(m.isLike)];
            }
            if ([model respondsToSelector:@selector(likeCount)]) {
                [model setValue:m.likeCount forKey:KP(m.likeCount)];
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:YCClickNotification object:model];
        } error:self.errorBlock completed:nil executing:nil];
    }
    
    else if (sender.selectedIndex == 2) {
        ///收藏
        UIButton *button = sender.favorite;
        BOOL favorite = !m.isFavorite.boolValue;
        [button executeActivitySignal:[self.viewModel  favoriteById:m.Id isFavorite:favorite type:self.viewModel.cheatsType] next:^(id x) {
            m.isFavorite  = @(favorite);
            button.selected =  favorite;
            if ([model respondsToSelector:@selector(isFavorite)]) {
                [model setValue:m.isFavorite forKey:KP(m.isFavorite)];
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:YCClickNotification object:model];
        } error:self.errorBlock completed:nil executing:nil];
    }
    
    else if (sender.selectedIndex == 1) {
        [self onShare:sender.share];
    }
    
    else if (sender.selectedIndex == 3) {
        [sender becomeFirstResponder];
        self.viewModel.replyModel = nil;
    }
}


#pragma mark -  分享
- (IBAction)onShare:(id)sender {
    
    NSString *img = self.viewModel.shareImageUrl;
    NSString *html5 = self.viewModel.shareHtml5UrlString;
    WSELF;
    [[self.viewModel shareInView:self title:self.title text:self.viewModel.updateModel.desc image:[UIImage cacheImagewith:img] url:html5 shareId:self.viewModel.updateModel.Id type:self.viewModel.shareType].deliverOnMainThread subscribeNext:^(id x) {
        [self performSelector:@selector(showMessage:) withObject:x afterDelay:1];
    } error:^(NSError *error) {
        SSELF;
        [self performSelector:@selector(showMessage:) withObject:error.localizedDescription afterDelay:1];
    }];
    
}


///回复
- (IBAction)onReply:(UIButton *)sender {
    NSString *comment = self.inputBar.inputControl.content.text;
    
//    CHECK(comment.length<=0, @"请输入");
    
    if (comment.length <=0) {
        [self showmMidMessage:@"请输入您的评论"];
        return;
    }
    
    YCCheatsType type = self.viewModel.cheatsType;
    YCCommentM *cm = self.viewModel.replyModel;
    
    
    [sender executeActivitySignal:[self.viewModel replySignalId:self.viewModel.Id replyCommentId:cm.Id replyUserId:cm.userId comment:comment type:type] next:^(id next) {
        
        self.inputBar.inputControl.content.text = nil;
        [self.inputBar resignFirstResponder];
        if (next) {
            [self.tableViewController onInsertItemsIntoFront:1];
            [self showMessage:@"评论成功"];
        }
    } error:self.errorBlock completed:nil executing:nil];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{

    [self.inputBar resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    self.tableViewController = segue.destinationViewController;
    NSAssert([self.tableViewController isKindOfClass:[YCTableViewController class]], @"类型不对");
}





@end
